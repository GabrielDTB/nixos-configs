//! Stack RAW+JPEG pairs in Immich, and nothing else.
//!
//! Differences from `immich-go stack`:
//!   * an asset that is already in ANY stack is never touched;
//!   * only clusters of exactly one RAW + one original JPEG are stacked
//!     (Pixel `COVER_<n>.jpg` crops of that JPEG ride along, original primary);
//!   * ONLY Google Pixel filenames (`PXL_YYYYMMDD_HHMMSSmmm...`) are considered;
//!     everything else is ignored.  Deliberately strict: extend when needed;
//!   * nothing is ever deleted.
//!
//! Config via environment:
//!   IMMICH_URL           e.g. http://localhost:2283
//!   IMMICH_API_KEY_FILE  path to a file containing the API key
//!   IMMICH_API_KEY       (alternative to the file)
//!   RAWSTACK_COVER       "jpeg" (default) or "raw"
//!   RAWSTACK_STATE_FILE  cursor file for incremental runs
//!                        (default: $STATE_DIRECTORY/cursor, else full scan)
//! Flags: --dry-run   plan only
//!        --full      ignore the cursor and scan the whole library
//!
//! Safety: with no cursor file and no --full, a live run refuses, so the
//! first (full) pass is always a deliberate, human-invoked step.
//!
//! Incremental mode: fetch assets updated since the last run (minus a safety
//! margin), then for each unstacked RAW/JPEG among them fetch its namesakes
//! by filename substring and capture-time window.  Pairing logic is identical
//! to a full scan; the cursor only narrows what we look at.

use anyhow::{anyhow, bail, Context, Result};
use chrono::{DateTime, FixedOffset, Utc};
use serde::Deserialize;
use std::collections::{HashMap, HashSet};

const RAW_EXTS: &[&str] = &[
    "3fr", "ari", "arw", "cap", "cin", "cr2", "cr3", "crw", "dcr", "dng", "erf", "fff", "iiq",
    "k25", "kdc", "mrw", "nef", "nrw", "orf", "ori", "pef", "raf", "raw", "rw2", "rwl", "sr2",
    "srf", "srw", "x3f",
];
const JPEG_EXTS: &[&str] = &["jpg", "jpeg", "jpe"];
const PAIR_WINDOW_MS: i64 = 1000;
/// How far before the last cursor to look, to absorb clock skew and overlap.
const CURSOR_MARGIN_SECS: i64 = 15 * 60;

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
struct Asset {
    id: String,
    owner_id: String,
    original_file_name: String,
    file_created_at: String,
    is_trashed: bool,
    #[serde(rename = "type")]
    kind: String,
    /// NOTE: /search/metadata never fills this in (v3.0.x); we filter by
    /// `withStacked: false` instead.  Kept as belt-and-braces in case a later
    /// server version does populate it.
    stack: Option<serde_json::Value>,
}

#[derive(Deserialize)]
struct SearchPage {
    assets: SearchAssets,
}

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
struct SearchAssets {
    items: Vec<Asset>,
    next_page: Option<String>,
}

#[derive(Deserialize)]
struct StackCreated {
    id: String,
}

#[derive(Clone, Copy, PartialEq, Eq)]
enum Kind {
    Raw,
    Jpeg,
}

struct Candidate {
    id: String,
    name: String,
    kind: Kind,
    t_ms: i64,
    stacked: bool,
}

struct Client {
    base: String,
    key: String,
    agent: ureq::Agent,
}

impl Client {
    fn post_json<T: serde::de::DeserializeOwned>(
        &self,
        path: &str,
        body: serde_json::Value,
    ) -> Result<T> {
        let url = format!("{}/api{}", self.base, path);
        let resp = self
            .agent
            .post(&url)
            .set("x-api-key", &self.key)
            .set("accept", "application/json")
            .send_json(body)
            .map_err(|e| match e {
                ureq::Error::Status(code, r) => {
                    let text = r.into_string().unwrap_or_default();
                    anyhow!("POST {path} -> HTTP {code}: {text}")
                }
                other => anyhow!("POST {path}: {other}"),
            })?;
        resp.into_json().with_context(|| format!("decoding response from {path}"))
    }

    /// Page through /search/metadata with `extra` merged into every request,
    /// across the visibilities we care about.
    fn search(&self, extra: &serde_json::Map<String, serde_json::Value>) -> Result<Vec<Asset>> {
        let mut out = Vec::new();
        for visibility in ["timeline", "archive"] {
            let mut page: u64 = 1;
            loop {
                let mut body = serde_json::json!({
                    "page": page,
                    "size": 1000,
                    "type": "IMAGE",
                    "visibility": visibility,
                    // Server-side `asset.stackId IS NULL` filter. (search/metadata
                    // never populates the `stack` field, so this is the only way to
                    // avoid re-stacking assets that are already stacked.)
                    "withStacked": false,
                    "order": "asc",
                });
                body.as_object_mut().unwrap().extend(extra.clone());
                let res: SearchPage = self.post_json("/search/metadata", body)?;
                out.extend(res.assets.items);
                match res.assets.next_page {
                    Some(next) => page = next.parse().context("nextPage not numeric")?,
                    None => break,
                }
            }
        }
        Ok(out)
    }

    fn all_images(&self) -> Result<Vec<Asset>> {
        self.search(&serde_json::Map::new())
    }

    fn updated_since(&self, since: DateTime<Utc>) -> Result<Vec<Asset>> {
        let mut m = serde_json::Map::new();
        m.insert("updatedAfter".into(), serde_json::json!(since.to_rfc3339()));
        self.search(&m)
    }

    /// Assets sharing a filename radical, captured within a few seconds of `t`.
    /// `originalFileName` is a server-side ILIKE substring match, so this may
    /// over-fetch (IMG_0001 also matches IMG_00012); bucketing fixes that.
    fn siblings(&self, radical: &str, t: DateTime<Utc>) -> Result<Vec<Asset>> {
        let pad = chrono::Duration::seconds(5);
        let mut m = serde_json::Map::new();
        m.insert("originalFileName".into(), serde_json::json!(radical));
        m.insert("takenAfter".into(), serde_json::json!((t - pad).to_rfc3339()));
        m.insert("takenBefore".into(), serde_json::json!((t + pad).to_rfc3339()));
        self.search(&m)
    }

    fn create_stack(&self, ids: &[&str]) -> Result<String> {
        let res: StackCreated =
            self.post_json("/stacks", serde_json::json!({ "assetIds": ids }))?;
        Ok(res.id)
    }
}

/// Extension, lowercase, without dot.
fn ext_of(name: &str) -> Option<&str> {
    name.rsplit_once('.').map(|(_, e)| e)
}

fn kind_of(ext: &str) -> Option<Kind> {
    let e = ext.to_ascii_lowercase();
    if RAW_EXTS.contains(&e.as_str()) {
        Some(Kind::Raw)
    } else if JPEG_EXTS.contains(&e.as_str()) {
        Some(Kind::Jpeg)
    } else {
        None
    }
}

/// Pixel filenames only: `PXL_YYYYMMDD_HHMMSSmmm` followed by variant
/// suffixes (`.jpg`/`.dng`, `.RAW-01.COVER.jpg`/`.RAW-02.ORIGINAL.dng`, …).
/// Returns the shared prefix, or None for anything that isn't a Pixel name.
fn radical(name: &str) -> Option<String> {
    let base = name.rsplit('/').next().unwrap_or(name);
    let ok = base.len() > 22
        && base.starts_with("PXL_")
        && base[4..12].bytes().all(|b| b.is_ascii_digit())
        && base.as_bytes()[12] == b'_'
        && base[13..22].bytes().all(|b| b.is_ascii_digit())
        && base.as_bytes()[22] == b'.';
    ok.then(|| base[..22].to_string())
}

/// `….COVER_1.jpg`, `….COVER_2.jpg` are edited copies (crops) of `….COVER.jpg`.
fn is_variant(name: &str) -> bool {
    let stem = name.rsplit_once('.').map(|(s, _)| s).unwrap_or(name);
    match stem.rsplit_once('_') {
        Some((head, n)) => {
            head.ends_with(".COVER") && !n.is_empty() && n.bytes().all(|b| b.is_ascii_digit())
        }
        None => false,
    }
}

fn main() {
    if let Err(e) = run() {
        eprintln!("error: {e:#}");
        std::process::exit(1);
    }
}

fn run() -> Result<()> {
    let args: Vec<String> = std::env::args().collect();
    let dry_run = args.iter().any(|a| a == "--dry-run");
    let full = args.iter().any(|a| a == "--full");

    let base = std::env::var("IMMICH_URL")
        .context("IMMICH_URL not set")?
        .trim_end_matches('/')
        .to_string();
    let key = match std::env::var("IMMICH_API_KEY") {
        Ok(k) => k,
        Err(_) => {
            let path = std::env::var("IMMICH_API_KEY_FILE")
                .context("set IMMICH_API_KEY or IMMICH_API_KEY_FILE")?;
            std::fs::read_to_string(&path)
                .with_context(|| format!("reading {path}"))?
                .trim()
                .to_string()
        }
    };
    let cover = match std::env::var("RAWSTACK_COVER").as_deref() {
        Ok("raw") => Kind::Raw,
        Ok("jpeg") | Err(_) => Kind::Jpeg,
        Ok(other) => bail!("RAWSTACK_COVER must be 'jpeg' or 'raw', got {other:?}"),
    };

    let client = Client {
        base,
        key,
        agent: ureq::AgentBuilder::new()
            .timeout(std::time::Duration::from_secs(300))
            .build(),
    };

    let run_started = Utc::now();
    let state_file = std::env::var("RAWSTACK_STATE_FILE").ok().or_else(|| {
        std::env::var("STATE_DIRECTORY")
            .ok()
            .map(|d| format!("{d}/cursor"))
    });
    let cursor: Option<DateTime<Utc>> = if full {
        None
    } else {
        state_file
            .as_deref()
            .and_then(|p| std::fs::read_to_string(p).ok())
            .and_then(|s| DateTime::parse_from_rfc3339(s.trim()).ok())
            .map(|d| d.with_timezone(&Utc))
    };

    if cursor.is_none() && !full && !dry_run {
        bail!("no cursor file and --full not given: refusing to do a live full scan; inspect with `--dry-run --full`, then seed the cursor with `--full`");
    }

    let assets = match cursor {
        None => {
            let a = client.all_images()?;
            eprintln!("full scan: {} image assets", a.len());
            a
        }
        Some(c) => {
            let since = c - chrono::Duration::seconds(CURSOR_MARGIN_SECS);
            let recent = client.updated_since(since)?;
            let n_recent = recent.len();
            // Pull in namesakes of any unstacked RAW/JPEG among the recent ones.
            let mut seen: HashSet<String> = recent.iter().map(|a| a.id.clone()).collect();
            let mut wanted: HashSet<(String, i64)> = HashSet::new();
            for a in &recent {
                if a.is_trashed || a.stack.is_some() {
                    continue;
                }
                if ext_of(&a.original_file_name).and_then(kind_of).is_none() {
                    continue;
                }
                let Some(r) = radical(&a.original_file_name) else {
                    continue;
                };
                let t = DateTime::parse_from_rfc3339(&a.file_created_at)
                    .with_context(|| format!("bad fileCreatedAt on {}", a.original_file_name))?;
                // one lookup per (radical, second)
                wanted.insert((r, t.timestamp()));
            }
            let mut all = recent;
            for (r, secs) in &wanted {
                let t = DateTime::from_timestamp(*secs, 0).unwrap();
                for a in client.siblings(r, t)? {
                    if seen.insert(a.id.clone()) {
                        all.push(a);
                    }
                }
            }
            eprintln!(
                "incremental since {}: {} recent, {} radicals looked up, {} assets considered",
                since.to_rfc3339(),
                n_recent,
                wanted.len(),
                all.len()
            );
            all
        }
    };

    let (created, skipped_ambiguous) = stack_pairs(&client, assets, cover, dry_run)?;

    eprintln!(
        "done: {created} {}, {skipped_ambiguous} ambiguous clusters skipped",
        if dry_run { "would be created" } else { "created" }
    );

    if !dry_run {
        if let Some(p) = state_file {
            std::fs::write(&p, run_started.to_rfc3339())
                .with_context(|| format!("writing cursor to {p}"))?;
        }
    }
    Ok(())
}

/// Bucket by (owner, radical), cluster by capture time, stack 1 RAW + 1 JPEG
/// clusters.  Returns (created, skipped because ambiguous).
fn stack_pairs(
    client: &Client,
    assets: Vec<Asset>,
    cover: Kind,
    dry_run: bool,
) -> Result<(usize, usize)> {
    let mut buckets: HashMap<(String, String), Vec<Candidate>> = HashMap::new();
    for a in assets {
        if a.is_trashed || a.kind != "IMAGE" {
            continue;
        }
        let Some(kind) = ext_of(&a.original_file_name).and_then(kind_of) else {
            continue;
        };
        let Some(r) = radical(&a.original_file_name) else {
            continue; // not a Pixel filename: ignored by design
        };
        let t = DateTime::<FixedOffset>::parse_from_rfc3339(&a.file_created_at)
            .with_context(|| format!("bad fileCreatedAt on {}", a.original_file_name))?;
        buckets
            .entry((a.owner_id, r))
            .or_default()
            .push(Candidate {
                id: a.id,
                name: a.original_file_name,
                kind,
                t_ms: t.timestamp_millis(),
                stacked: a.stack.is_some(),
            });
    }

    let mut created = 0usize;
    let mut skipped_ambiguous = 0usize;

    for (_, mut cands) in buckets {
        if cands.len() < 2 {
            continue;
        }
        cands.sort_by_key(|c| c.t_ms);

        let mut clusters: Vec<Vec<&Candidate>> = Vec::new();
        for c in &cands {
            match clusters.last_mut() {
                Some(cl) if c.t_ms - cl.last().unwrap().t_ms <= PAIR_WINDOW_MS => cl.push(c),
                _ => clusters.push(vec![c]),
            }
        }

        for cl in clusters {
            if cl.len() < 2 {
                continue;
            }
            let raws: Vec<&Candidate> = cl.iter().copied().filter(|c| c.kind == Kind::Raw).collect();
            let (variants, jpegs): (Vec<&Candidate>, Vec<&Candidate>) = cl
                .iter()
                .copied()
                .filter(|c| c.kind == Kind::Jpeg)
                .partition(|c| is_variant(&c.name));
            if raws.len() != 1 || jpegs.len() != 1 {
                skipped_ambiguous += 1;
                if dry_run {
                    let names: Vec<_> = cl.iter().map(|c| c.name.as_str()).collect();
                    println!("ambiguous    {}", names.join("  +  "));
                }
                continue;
            }
            let (raw, jpeg) = (raws[0], jpegs[0]);
            if raw.stacked || jpeg.stacked {
                // Only reachable if a future server fills `stack` in search results.
                continue;
            }
            let (first, second) = match cover {
                Kind::Jpeg => (jpeg, raw),
                Kind::Raw => (raw, jpeg),
            };
            let mut ids: Vec<&str> = vec![&first.id, &second.id];
            let mut names: Vec<&str> = vec![&first.name, &second.name];
            for v in &variants {
                ids.push(&v.id);
                names.push(&v.name);
            }
            if dry_run {
                println!("would stack  {}", names.join("  +  "));
            } else {
                let id = client.create_stack(&ids)?;
                println!("stacked  {}  -> {id}", names.join("  +  "));
            }
            created += 1;
        }
    }
    Ok((created, skipped_ambiguous))
}
