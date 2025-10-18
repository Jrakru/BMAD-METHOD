#!/usr/bin/env python3

"""
Minimal validator for 1C4D5 starter (regex-based, illustrative).
Checks:
- E100: Every D3 stage has an exec_on edge
- E101: Every D1 product has an owned_by edge
- E300: Story steps reference existing tokens (best-effort string check)
- E400: View budget (≤30 visible stages) — naive: count "stage " in flow files
"""

import re, os, sys, json, pathlib

ROOT = pathlib.Path(__file__).resolve().parents[1]
MODEL_DIR = ROOT / "likec4" / "model"

def read_all():
    texts = {}
    for p in MODEL_DIR.glob("*.c4"):
        texts[p.name] = p.read_text(encoding="utf-8")
    return texts

def find_stages(text):
    # naive: "stage ID"
    return set(re.findall(r"\bstage\s+([A-Za-z0-9_]+)\b", text))

def find_products(text):
    return set(re.findall(r"\bproduct\s+([A-Za-z0-9_]+)\b", text))

def find_exec_on_targets(text):
    # pattern: <path> -[exec_on]-> <path>
    return set(re.findall(r"\b([A-Za-z0-9_.]+)\s*-\s*\[exec_on\]\s*->\s*([A-Za-z0-9_.]+)", text))

def find_owned_by_edges(text):
    return set(re.findall(r"\b([A-Za-z0-9_]+)\s*-\s*\[owned_by\]\s*->\s*([A-Za-z0-9_.]+)", text))

def find_story_hops(text):
    # hops something ; we just capture token-ish references
    return set(re.findall(r"hops\s+([A-Za-z0-9_.]+)", text))

def main():
    texts = read_all()
    combined = "\n".join(texts.values())

    # Collect entities
    stages = set()
    products = set()
    for name, txt in texts.items():
        stages |= find_stages(txt)
        products |= find_products(txt)

    # Collect joins
    exec_on_sources = set()
    owned_by_sources = set()
    for name, txt in texts.items():
        for src, dst in find_exec_on_targets(txt):
            # src might be qualified flow.group.STAGE; extract last token as stage id
            stage_id = src.split(".")[-1]
            exec_on_sources.add(stage_id)
        for src, dst in find_owned_by_edges(txt):
            owned_by_sources.add(src)

    # Story refs
    story_hops = set()
    for name, txt in texts.items():
        story_hops |= find_story_hops(txt)

    errors = []
    # E100: missing exec_on
    for st in sorted(stages):
        if st not in exec_on_sources:
            errors.append(("E100", f"Stage '{st}' missing exec_on join"))

    # E101: missing owned_by
    for pr in sorted(products):
        if pr not in owned_by_sources:
            errors.append(("E101", f"Product '{pr}' missing owned_by join"))

    # E300: story hops unknown (best effort: does token appear anywhere?)
    model_tokens = set(re.findall(r"\b[A-Za-z0-9_.]{3,}\b", combined))
    for tok in sorted(story_hops):
        if tok not in model_tokens:
            errors.append(("E300", f"Story hop '{tok}' not found in model tokens"))

    # E400: view budget (naive) – count "stage " occurrences in each file
    for name, txt in texts.items():
        stage_count = len(re.findall(r"\bstage\s+", txt))
        if stage_count > 30:
            errors.append(("E400", f"File '{name}' contains {stage_count} stages (>30 budget)"))

    if errors:
        for code, msg in errors:
            print(f"{code}: {msg}")
        print(f"\nFAILED with {len(errors)} error(s).")
        sys.exit(1)
    else:
        print("OK: validation passed.")

if __name__ == "__main__":
    main()
