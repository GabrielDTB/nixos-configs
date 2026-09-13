import base64
import hashlib
import hmac
import json
import os
import sys
import time
import urllib.parse
import urllib.request

API = "https://api.kraken.com"
ASSET = os.environ["KRAKEN_ASSET"]
KEY_NAME = os.environ["KRAKEN_WITHDRAW_KEY"]
MAX_FEE_FRACTION = float(os.environ["KRAKEN_MAX_FEE_FRACTION"])


def load_credentials():
    creds = {}
    path = os.path.join(os.environ["CREDENTIALS_DIRECTORY"], "kraken")
    with open(path) as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#") and "=" in line:
                k, v = line.split("=", 1)
                creds[k.strip()] = v.strip()
    return creds["KRAKEN_API_KEY"], creds["KRAKEN_API_SECRET"]


def private(path, data, key, secret):
    data = dict(data)
    data["nonce"] = str(int(time.time() * 1000))
    post = urllib.parse.urlencode(data)
    sha = hashlib.sha256((data["nonce"] + post).encode()).digest()
    mac = hmac.new(base64.b64decode(secret),
                   path.encode() + sha, hashlib.sha512)
    req = urllib.request.Request(
        API + path, data=post.encode(),
        headers={"API-Key": key,
                 "API-Sign": base64.b64encode(mac.digest()).decode(),
                 "User-Agent": "kraken-sweep"})
    with urllib.request.urlopen(req, timeout=30) as r:
        body = json.load(r)
    if body.get("error"):
        raise RuntimeError(", ".join(body["error"]))
    return body["result"]


def main():
    key, secret = load_credentials()

    balances = private("/0/private/Balance", {}, key, secret)
    # Kraken prefixes legacy assets: XMR shows up as XXMR.
    bal = float(balances.get(ASSET) or balances.get("X" + ASSET) or 0)
    if bal <= 0:
        print(f"no {ASSET} balance; nothing to do")
        return

    info = private("/0/private/WithdrawInfo",
                   {"asset": ASSET, "key": KEY_NAME, "amount": f"{bal:.8f}"},
                   key, secret)
    # `limit` is what can leave right now: it already reflects holds on
    # recent purchases and the rolling 30-day cap. `fee` is the flat
    # withdrawal fee in asset units, read live so a fee change on Kraken's
    # side moves the threshold automatically.
    limit = float(info["limit"])
    fee = float(info["fee"])
    threshold = fee / MAX_FEE_FRACTION
    print(f"balance={bal} withdrawable={limit} "
          f"fee={fee} threshold={threshold:.6f}")

    if limit < threshold:
        if limit > 0:
            print(f"fee would be {fee / limit:.2%}; "
                  f"waiting for {threshold:.6f} {ASSET}")
        else:
            print("nothing withdrawable yet (funds on hold)")
        return

    res = private("/0/private/Withdraw",
                  {"asset": ASSET, "key": KEY_NAME, "amount": f"{limit:.8f}"},
                  key, secret)
    print(f"withdrew {limit} {ASSET} -> {KEY_NAME} "
          f"(fee {fee / limit:.2%}); refid={res.get('refid')}")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:  # noqa: BLE001
        print(f"error: {e}", file=sys.stderr)
        sys.exit(1)
