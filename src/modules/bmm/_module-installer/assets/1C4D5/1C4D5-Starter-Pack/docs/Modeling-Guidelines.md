# Modeling Guidelines (1C4D5)

## Entities (Kinds)

### C4
- `system`, `container`, `component`, `person`, `boundary`, `deployment`

### D5
- `domain` (D0), `product` (D1), `dataflow` (D2), `group`, `stage` (D3), `directive` (D4), `detail_code` (D5), `actor` (runtime)

### Story overlay
- `story`, `step` with `follows`, `hops`, `goto`

## Required relationships
- `exec_on`: `stage` → `container|component` (mandatory)
- `owned_by`: `product` → `component` (mandatory)

## Naming & IDs
- Use stable **IDs** (tokens) and human‑friendly **titles**.
- Prefix flows and products with a domain/topic if helpful, e.g., `cust_ingest_v1`, `silver_customers`.

## Budgets (keep views legible)
- Derivation (D3 stages): ≤ 30 visible nodes
- Directives (D4 ops): ≤ 7 visible nodes (collapse into macro-ops beyond this)
- Landscape (C4 or D5): ≤ 12–20 nodes

## Contracts & SLAs
- D2 flows must set `{id, owner, mode, SLA}`.
- D1 products should link schema/contract and PII tag where applicable.

## Boundaries and domains
- Align `boundary` (C4) ↔ `domain` (D5) via `trust_boundary` for policy reasoning.
