# Scan 1C4D5 Consistency

Perform a governance sweep across the 1C4D5 starter-pack assets. The workflow defines a scan scope, captures the current implementation snapshot with `code_tools`, compares the observations to LikeC4 models and supporting docs, and records any drift.

- **Input:** Scan focus (modules, diagrams, recent changes, risk flags)
- **Process:** code_tools snapshot → documentation comparison → drift classification → remediation plan
- **Output:** Consistency report saved to `{output_folder}/1c4d5/consistency-scan-<date>.md`
- **Follow-up:** Trigger targeted workflows (`update-diagram`, `audit-data-flow`, `validate-likec4`) or escalate issues to owning teams
