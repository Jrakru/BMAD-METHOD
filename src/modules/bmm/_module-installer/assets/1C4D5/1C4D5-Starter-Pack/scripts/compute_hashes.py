#!/usr/bin/env python3

"""
Computes illustrative hashes:
- C4H: hash of C4 subset (system/container/component/boundary definitions)
- WDH: hash per flow (dataflow blocks)
- USH: unified hash = hash(C4H + sorted(exec_on/owned_by edges) + sorted(flow WDHs))

Outputs JSON to dist/hashes.json.
"""

import os, re, json, hashlib, pathlib

ROOT = pathlib.Path(__file__).resolve().parents[1]
MODEL_DIR = ROOT / "likec4" / "model"
DIST = ROOT / "dist"
DIST.mkdir(exist_ok=True)

def h(s: str) -> str:
    return hashlib.sha256(s.encode("utf-8")).hexdigest()[:16]

def main():
    texts = [p.read_text(encoding="utf-8") for p in MODEL_DIR.glob("*.c4")]
    all_text = "\n".join(texts)

    # C4 slice
    c4_slice = "\n".join(re.findall(r"(system\s+[\s\S]*?)\n}\n", all_text))
    c4h = h(c4_slice)

    # flows (WDH per dataflow id)
    flows = re.findall(r"dataflow\s+([A-Za-z0-9_]+)\s+'[^']*'\s*{([\s\S]*?)\n}\n", all_text)
    wdh = {}
    for flow_id, body in flows:
        # normalize stage graph-like content
        normalized = re.sub(r"\s+", " ", body.strip())
        wdh[flow_id] = h(normalized)

    # join edges
    exec_on_edges = re.findall(r"\b([A-Za-z0-9_.]+)\s*-\s*\[exec_on\]\s*->\s*([A-Za-z0-9_.]+)", all_text)
    owned_by_edges = re.findall(r"\b([A-Za-z0-9_]+)\s*-\s*\[owned_by\]\s*->\s*([A-Za-z0-9_.]+)", all_text)
    join_blob = json.dumps(sorted(exec_on_edges) + sorted(owned_by_edges))

    ush = h(c4h + "|" + "|".join(sorted(wdh.values())) + "|" + join_blob)

    out = {
        "C4H": c4h,
        "WDH": wdh,
        "USH": ush
    }
    (DIST / "hashes.json").write_text(json.dumps(out, indent=2), encoding="utf-8")
    print(json.dumps(out, indent=2))

if __name__ == "__main__":
    main()
