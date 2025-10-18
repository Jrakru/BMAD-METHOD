# Audit 1C4D5 Data Flow

Trace a specific data flow end-to-end, reconcile it against LikeC4 documentation, and surface discrepancies. The workflow gathers the flow context, uses `code_tools` to inspect the real implementation, reviews the D-layer models, and produces an actionable report.

- **Input:** Flow name, triggering scenario, suspected issues
- **Process:** code_tools tracing → LikeC4 inspection → gap analysis → remediation plan
- **Output:** Audit report stored at `{output_folder}/1c4d5/data-flow-audit-<date>.md` with evidence and next steps
- **Follow-up:** Use `update-diagram` to apply corrections or open engineering work items if the implementation must change
