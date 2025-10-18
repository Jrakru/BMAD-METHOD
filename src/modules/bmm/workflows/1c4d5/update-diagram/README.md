# Update 1C4D5 Diagram Assets

Refresh LikeC4 models in the 1C4D5 starter pack when architecture or data-flow changes land. The workflow collects change context, uses the `code_tools` MCP server to ground the request in real implementation details, reviews the current diagrams, plans the edits, applies updates using the starter-pack templates, and produces a review summary for the architect/PO.

- **Input:** Change description, impacted modules/services, supporting artifacts
- **Process:** code_tools analysis → diagram review → plan updates → edit LikeC4 assets → document changes
- **Output:** Updated `.c4` files under `1C4D5/1C4D5-Starter-Pack/likec4` and a summary note saved to `{output_folder}/1c4d5/diagram-update-<date>.md`
- **Follow-up:** Run `validate-likec4` workflow (or the menu command) to confirm syntax and semantic integrity
