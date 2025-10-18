# LikeC4 & C4/D5 Quick Reference

Use this as a refresher before touching the starter-pack assets. If the modeling rules change, fall back to the full docs in `1C4D5/1C4D5-Starter-Pack/docs/`.

## C4 Layers (Starter-Pack conventions)
- **Context**: captured once per portfolio in `specification.c4`; rarely edited by Atlas.
- **Container (`C4_container`)**: defines deployable units; include `tech`, `purpose`, and relationships via `->` syntax.
- **Component / Story overlays**: represented in D-layer files; keep alignment with container names.

## D5 Layers
- **D1 Product (`*_product.c4`)**: top-level business capability; include `owned_by` joins to stakeholders.
- **D2 Flow (`*_flow.c4`)**: ordered interactions; model inputs/outputs with `->` and label the guard conditions.
- **D3 Stage & Exec (`*_stage_exec_on.c4`)**: detail stages plus `exec_on` links to automation; ensure every stage ties back to a flow step.
- **Cross-layer joins**:
  - `owned_by` connects products/stages to people or teams.
  - `exec_on` maps automation or tooling back to stages.
  - `uses`/`depends_on` bridge D assets to C4 containers.

## LikeC4 Syntax Reminders
- Blocks start with `element` definitions, followed by property assignments (`key = value`).
- Use double quotes for string values; avoid smart quotes.
- Relationship syntax: `A -> B "label"` for directional flows.
- Group related definitions with comments (`// ---`) to keep diffs manageable.

## Modeling Guardrails
- Every new D-layer element must point to a proof in code (ticket, module, script) cited in the change log.
- Keep names consistent across files: use kebab-case filenames and PascalCase identifiers within LikeC4.
- When in doubt, refer back to `Modeling-Guidelines.md` and `View-Catalog.md` for canonical examples.
