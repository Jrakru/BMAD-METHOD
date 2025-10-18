# View Catalog (Lenses)

**Principle:** One model, multiple *lenses* (Infra / Data / Story). Users can toggle lenses without losing selection.

## Infra lens
- Shows: Containers/Components/Boundaries and only the subset linked to selected flows/stages/products via `exec_on` / `owned_by`.
- Good for: capacity planning, infra changes, SRE runbooks.

## Data lens
- Shows: Dataflows (D2), Stages (D3), Products (D1) and their IO edges (`reads_from`, `writes_to`). Lanes by **executor container**.
- Good for: pipeline logic, contracts/SLA, lineage handoffs.

## Story lens
- Shows: a “playable” journey (`story` → `step`s) overlaying both infra and data nodes referenced by `hops`.
- Good for: design reviews, onboarding, incident walk-through.

## Hybrid views
- Container → Stages it runs (plus products touched)
- Product → Owners (components) + Upstream/Downstream footprints
