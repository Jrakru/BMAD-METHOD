# 1C4D5 Starter Pack (LikeC4-only)

**Purpose.** Jumpstart a project that intertwines **C4 (software structure)** and **D5 (data design & diagnostics)** using **LikeC4**—with *one* model and multiple lenses (Infra / Data / Story).

**What’s inside**
- `likec4/` — Combined **specification** plus **example C4 + D5 model** and **hybrid views**.
- `docs/` — How‑to, modeling guidelines, view catalog, story guide, troubleshooting.
- `scripts/` — Minimal lints & hash calculator (C4H/WDH/USH) and a toy story player generator.
- `templates/` — Authoring templates for flows, stages, containers, stories.
- `.github/workflows/` — Example CI to run lints and compute hashes on PRs.

**Quickstart**
1. Copy this folder into your repo (or unzip the archive).  
2. Open `likec4/specification.c4`. Keep C4 kinds and D5 kinds as provided.  
3. Start modeling: edit the examples in `likec4/model/*.c4` to match your system, flows, and joins (`exec_on`, `owned_by`).  
4. Define views in `likec4/views/views.c4` (or reuse the presets) and render with your LikeC4 toolchain.  
5. Run validation locally:
   ```bash
   python3 scripts/validate.py
   python3 scripts/compute_hashes.py
   python3 scripts/build_story_player.py  # outputs: dist/story_player.html
   ```
6. Enable CI: commit `.github/workflows/1c4d5-ci.yml`.

**Key ideas**
- **Joins** bind C4 and D5: `exec_on` (stage→container) and `owned_by` (product→component) are mandatory.
- **Lenses**: toggle **Infra / Data / Story** over the same selection for seamless pivots.
- **Stories**: simple, step‑through overlays that walk real infra and data nodes—great for reviews, triage, onboarding.
- **Hashes**: `C4H`, `WDH`, `USH` help detect drift and tie runs to reviewed architecture.

---

© 2025 1C4D5. MIT License (optional—adjust to your needs).
