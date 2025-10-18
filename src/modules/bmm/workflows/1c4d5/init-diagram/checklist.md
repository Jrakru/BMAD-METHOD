# Init Diagram Workflow Validation Checklist

## Pre-Workflow Validation

- [ ] Architecture workspace root is configured in bmad/bmm/config.yaml
- [ ] Starter pack directory exists and is accessible
- [ ] User has provided system/diagram name
- [ ] code_tools MCP server is available (if using)
- [ ] LikeC4 CLI is installed and accessible (optional for validation)

## Step 1: Scope Capture

- [ ] Diagram name is captured and slug-friendly (lowercase, hyphen-separated)
- [ ] Directory structure exists:
  - [ ] `{docs_dir}` exists
  - [ ] `{docs_dir}/journal` exists
  - [ ] `{project_docs_root}/likec4/model` exists
  - [ ] `{project_docs_root}/likec4/views` exists
- [ ] Business driver is documented (either from existing docs or user input)
- [ ] Code anchors are identified (runtime and test paths)
- [ ] Stakeholders are captured (or marked as unknown)
- [ ] Existing overview file checked (if present, context reused)
- [ ] Referenced canonical sources (PRD, Architecture docs) if they exist

## Step 2: Reference Review

- [ ] Modeling Guidelines reviewed from starter pack
- [ ] View Catalog reviewed from starter pack
- [ ] Available templates inspected
- [ ] code_tools summary executed successfully (if applicable)
- [ ] Baseline evidence captured from codebase
- [ ] ADRs and additional documentation noted

## Step 3: Scaffold Creation

- [ ] Required C4 and D-layer assets identified
- [ ] Filenames follow naming convention: `{diagram_slug}_<artifact>.c4`
- [ ] Templates copied from starter pack to model directory
- [ ] Views file exists or created from starter pack template
- [ ] View entries added to views.c4 referencing new model files
- [ ] All created/modified files documented in scaffold plan

## Step 4: Content Population

- [ ] Each C4/D file edited with gathered data
- [ ] Template placeholders replaced with actual values
- [ ] Ownership joins defined correctly
- [ ] Execution stages aligned with Modeling Guidelines
- [ ] Story overlays mapped to code_tools evidence
- [ ] Open questions or missing data documented
- [ ] No placeholder text remains in files

## Step 5: Narrative Documentation

- [ ] Overview file created/updated at `{docs_dir}/{diagram_slug}-overview.md`
- [ ] Overview contains:
  - [ ] Context and business drivers
  - [ ] Stakeholder information
  - [ ] Links to LikeC4 assets
  - [ ] Code anchor references
- [ ] Journal entry created in `{init_output_dir}/{date}-{diagram_slug}-init.md`
- [ ] Journal entry captures evidence from all prior steps
- [ ] Change log entry appended to `{change_log_file}`
- [ ] Change log entry includes: who, when, why
- [ ] System catalog updated in `{specification_file}` (if exists)
- [ ] Catalog entry references new asset and owner

## Step 6: Validation & Summary

- [ ] LikeC4 validation executed (if available)
- [ ] Models compile without syntax errors
- [ ] No semantic errors reported
- [ ] Initialization summary includes:
  - [ ] List of all files created
  - [ ] Validation status
  - [ ] Narrative documents touched
  - [ ] Journal entries created
  - [ ] Outstanding gaps identified
  - [ ] Follow-up owners assigned
- [ ] User confirmed completion

## Post-Workflow Quality Checks

- [ ] All file paths stay within `{project_docs_root}`
- [ ] No direct file reads used when code_tools could provide data
- [ ] Fallbacks to direct file reads are documented
- [ ] All artifacts align with Modeling Guidelines
- [ ] View Catalog standards followed
- [ ] Change rationale captured for architect review
- [ ] Documentation is review-ready

## Output Quality Standards

- [ ] Diagrams map directly to live codebase
- [ ] Documentation explains "why" not just "what"
- [ ] Consistency maintained across all artifacts
- [ ] No discrepancies between code and diagrams
- [ ] Professional tone and precision maintained
- [ ] All placeholders resolved or marked as TODO

## Common Issues to Avoid

- [ ] Diagram names are not slug-friendly
- [ ] File operations outside architecture workspace
- [ ] Missing references to canonical PO/Architect documents
- [ ] Inferring information instead of consulting sources
- [ ] Skipping code_tools when available
- [ ] Incomplete journal or change log entries
- [ ] Unresolved template placeholders
- [ ] Missing validation step
- [ ] No user confirmation before completion

## Success Criteria

- [ ] Complete set of C4/D5 documentation initialized
- [ ] All files properly scoped within architecture workspace
- [ ] Evidence-backed documentation tied to actual code
- [ ] Clear audit trail in journal and change log
- [ ] Validation passed (or issues documented)
- [ ] Ready for ongoing maintenance by Atlas
- [ ] Architect can review and approve work