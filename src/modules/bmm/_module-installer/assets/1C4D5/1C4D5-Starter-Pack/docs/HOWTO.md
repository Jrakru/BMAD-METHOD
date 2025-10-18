# How to integrate 1C4D5 (LikeC4-only)

This guide covers the minimal steps to bring **1C4D5** into an existing project that already uses LikeC4 or is starting fresh.

## 1) Bring in the specification
- Keep the provided `likec4/specification.c4` as your canonical type system.
- Do **not** rename element/relationship kinds; IDs in commits and CI rely on them.

## 2) Model C4 (structure) and D5 (data) side-by-side
- C4: Systems, Boundaries, Containers, Components, Persons, Deployments.
- D5: Domains, Products (bronze/silver/gold), Dataflows (groups, stages), Directives, Detail Code, Actors (executors).

## 3) Bind the graphs with joins
- `exec_on`: every **stage** must map to a **container/component**.
- `owned_by`: every **durable product** must map to a **component**.
- Optional: `exposes_iface` (component→product), `trust_boundary` (boundary↔domain).

## 4) Author views
- Use the presets in `likec4/views/views.c4`: Data lens, Infra lens, Hybrid views, Story lens.
- Keep views lightweight: budgets ensure readability (30 visible stages, 7 ops per stage).

## 5) Add stories (optional but recommended)
- Create a `story` with ordered `step`s; each `step` uses `hops` to reference real nodes/edges.
- Generate the toy story player via `scripts/build_story_player.py` (HTML for demos/docs).

## 6) Validate & hash
- `scripts/validate.py`: coverage (all stages have `exec_on`, all products have `owned_by`), referential integrity for stories, view budgets.
- `scripts/compute_hashes.py`: computes C4H, WDH (per flow), and USH (unified). Persist to `dist/` for pipeline use.

## 7) Wire in Diagnostics (Dx) later
- Emit run events with `{stage_id, product_id, container_id, RPH, USH}` and link them from your observability pages into LikeC4‑rendered diagrams.
