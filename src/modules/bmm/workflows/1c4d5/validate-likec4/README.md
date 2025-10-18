# Validate 1C4D5 LikeC4 Assets

Run the starter-pack validators and the LikeC4 CLI to ensure diagrams, flows, and stories are syntactically and semantically correct. The workflow captures the validation scope, executes the Python helpers, runs the CLI, and records remediation tasks.

- **Input:** Recently modified diagrams/flows, optional exclusions
- **Process:** `python3 scripts/validate.py` → `python3 scripts/compute_hashes.py` → `likec4 validate`
- **Output:** Validation report stored at `{output_folder}/1c4d5/validation-report-<date>.md`
- **Follow-up:** If errors occur, trigger `update-diagram` or `audit-data-flow`, then rerun this workflow
