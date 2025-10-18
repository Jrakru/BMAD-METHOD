# init-diagram

Bootstrap new C4/D5 documentation inside the 1C4D5 starter pack.

## What it does

- Captures business and technical context for the new system or data flow
- Audits starter-pack guidelines, templates, and live code reality via `code_tools`
- Copies scaffolds into the LikeC4 model directory using safe slugs and records every file touched
- Populates D1/D2/D3 layers, ensuring joins and story overlays align with the evidence
- Seeds companion documentation (`docs/<slug>-overview.md`, change log entries, specification catalog updates)
- Encourages a validation run (`run_likec4_validation.sh`) before handing the asset to stakeholders

## Outputs

- New/updated `likec4/model/*.c4` and `likec4/views/views.c4` entries
- Narrative overview and change-log entries inside `1C4D5/1C4D5-Starter-Pack/docs`
- Optional validation logs under project scripts output paths
- Initialization journal written to `1C4D5/1C4D5-Starter-Pack/docs/journal/diagram-init-<date>.md`
