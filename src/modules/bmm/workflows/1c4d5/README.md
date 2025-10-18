# 1C4D5 Documentation Workflows

Supporting workflows for Atlas, the C4/D5 Systems Librarian, to manage the project 1C4D5 assets (seeded from the starter-pack templates), seed companion documentation, and keep architecture records aligned with reality.

| Workflow | Purpose |
| --- | --- |
| `init-diagram` | Stand up new C4/D5 documentation using starter-pack templates and validation guardrails. |
| `update-diagram` | Collect change context, ground updates with `code_tools`, and refresh LikeC4 diagrams. |
| `audit-data-flow` | Trace a specific data flow, compare code against documentation, and surface discrepancies. |
| `impact-summary` | Assemble an evidence-backed briefing for architect/PO stakeholders. |
| `consistency-scan` | Perform a governance sweep to detect drift across diagrams and supporting docs. |
| `validate-likec4` | Run starter-pack validators and the LikeC4 CLI to ensure syntactic/semantic correctness. |

All workflows scope file operations to `1C4D5/1C4D5-Starter-Pack`, prefer the `code_tools` MCP server for repository intelligence, and write human-readable outputs to `{output_folder}/1c4d5/`.
