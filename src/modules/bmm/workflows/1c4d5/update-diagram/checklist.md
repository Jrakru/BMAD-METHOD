# Update Diagram Workflow Validation Checklist

## Pre-Workflow Validation

- [ ] Architecture workspace root is configured in bmad/bmm/config.yaml
- [ ] Starter pack directory exists and is accessible
- [ ] Target diagram/system has been initialized (init-diagram completed)
- [ ] code_tools MCP server is available (if using)
- [ ] LikeC4 CLI is installed and accessible (optional for validation)
- [ ] User has identified the change requiring documentation update

## Step 1: Change Context Gathering

- [ ] Change description captured from user
- [ ] Related story/ticket/issue identified
- [ ] Impacted components or flows identified
- [ ] Code changes reviewed (via code_tools or direct inspection)
- [ ] Change type categorized (new feature, refactor, bug fix, etc.)
- [ ] Relevant ADRs or architectural decisions referenced
- [ ] Previous journal entries for context reviewed (if applicable)

## Step 2: Impact Analysis

- [ ] Affected C4/D layer files identified
- [ ] Ownership changes mapped
- [ ] Execution stage modifications documented
- [ ] Data flow changes traced
- [ ] Integration point impacts assessed
- [ ] Story overlay updates required (if applicable)
- [ ] View changes needed identified
- [ ] code_tools evidence gathered to support changes

## Step 3: Documentation Update Scope

- [ ] List of files to be modified created
- [ ] Scope approved by user before proceeding
- [ ] Modeling Guidelines reviewed for relevant standards
- [ ] View Catalog consulted for view requirements
- [ ] Existing content read and understood
- [ ] Update strategy defined (add, modify, deprecate)

## Step 4: LikeC4 Asset Updates

- [ ] Each identified C4/D file updated
- [ ] Changes align with code_tools evidence
- [ ] Ownership joins updated correctly
- [ ] Execution stages reflect new reality
- [ ] Story overlays updated (if applicable)
- [ ] Comments added explaining significant changes
- [ ] No inconsistencies introduced between related files
- [ ] View file updated if structure/relationships changed
- [ ] All changes follow Modeling Guidelines

## Step 5: Supporting Documentation Updates

- [ ] Overview file updated (if context changed)
- [ ] Journal entry created in `{journal_dir}/{date}-{diagram_slug}-update.md`
- [ ] Journal entry documents:
  - [ ] What changed
  - [ ] Why it changed
  - [ ] Code evidence supporting change
  - [ ] Files modified
  - [ ] Outstanding questions or TODOs
- [ ] Change log entry appended to `{change_log_file}`
- [ ] Change log includes: who, when, what, why
- [ ] System catalog updated if system responsibilities changed

## Step 6: Validation & Review

- [ ] LikeC4 validation executed
- [ ] Models compile without syntax errors
- [ ] No semantic errors reported
- [ ] Changes reviewed against code_tools evidence
- [ ] Consistency verified across all modified artifacts
- [ ] Update summary prepared including:
  - [ ] Files modified
  - [ ] Validation status
  - [ ] Evidence sources
  - [ ] Journal entry location
  - [ ] Review-ready status
- [ ] User confirmed changes are complete

## Post-Workflow Quality Checks

- [ ] All file paths stayed within `{project_docs_root}`
- [ ] code_tools MCP used as primary evidence source
- [ ] Direct file reads documented when used as fallback
- [ ] Changes preserve consistency with unmodified sections
- [ ] Diagrams still map to live codebase
- [ ] Documentation explains rationale for changes
- [ ] Change rationale captured for architect review
- [ ] No orphaned references or broken links

## Cross-Reference Validation

- [ ] Changes in one layer reflected in related layers
- [ ] Ownership joins remain consistent
- [ ] Execution flows remain coherent
- [ ] Story overlays align with updated structure
- [ ] Views accurately represent updated models
- [ ] Specification catalog remains synchronized

## Output Quality Standards

- [ ] Updated diagrams accurately reflect code changes
- [ ] Documentation explains "why" changes were made
- [ ] Consistency maintained across all updated artifacts
- [ ] No new discrepancies introduced
- [ ] Professional tone and precision maintained
- [ ] All changes are evidence-backed

## Common Issues to Avoid

- [ ] Updating diagrams without code evidence
- [ ] Making changes outside architecture workspace
- [ ] Missing journal or change log entries
- [ ] Incomplete impact analysis
- [ ] Inconsistencies between related files
- [ ] Skipping validation step
- [ ] No architect review summary
- [ ] Incomplete user confirmation
- [ ] Breaking existing references

## Traceability Requirements

- [ ] Change linked to story/ticket/issue
- [ ] Code evidence documented
- [ ] Previous state captured (via journal)
- [ ] New state documented clearly
- [ ] Decision rationale explained
- [ ] Review trail established

## Success Criteria

- [ ] Diagrams updated to reflect current codebase state
- [ ] All changes validated and error-free
- [ ] Evidence-backed audit trail in journal
- [ ] Change log updated appropriately
- [ ] Consistency maintained across artifact set
- [ ] Ready for architect review and approval
- [ ] User confirmed update completeness
- [ ] Documentation remains trustworthy and accurate