#!/usr/bin/env nix
//! ```cargo
//! [dependencies]
//! anyhow = "1.0.95"
//! ```
/*
#!nix shell nixpkgs#clang nixpkgs#cargo nixpkgs#rustc nixpkgs#rust-script --command rust-script
*/

use anyhow::{Result, Context};

fn main() -> Result<()> {
    Ok(())
}
