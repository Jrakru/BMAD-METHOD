# Troubleshooting & Failure Modes

## Coverage failures
- **E100** Missing `exec_on` for a stage → Find the stage in `likec4/model/*` and add an `exec_on` edge in `example_joins.c4` (or your joins file).
- **E101** Missing `owned_by` for a product → Add `owned_by` to a `component`.

## Cross-boundary policy
- **E200** Writes cross a disallowed `trust_boundary` → Align `boundary` ↔ `domain` mapping and update policy tags.

## Story drift
- **E300** Step references unknown nodes → The ID changed or was removed. Update the step’s `hops`.

## View budgets
- **E400** Too many visible nodes → Extract subflows or macro directives; split diagrams.

## Hash drift
- **W500** USH changed unexpectedly → Review what changed in C4, D5, or join edges.
