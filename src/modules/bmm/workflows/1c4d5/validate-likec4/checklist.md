# Validate LikeC4 Workflow Validation Checklist

## Pre-Workflow Validation

- [ ] Architecture workspace root is configured in bmad/bmm/config.yaml
- [ ] 1C4D5 documentation has been initialized
- [ ] LikeC4 model directory exists with .c4 files
- [ ] LikeC4 CLI is installed and accessible
- [ ] User has permission to execute validation commands
- [ ] Starter pack validation scripts are available

## Step 1: Validation Scope Definition

- [ ] Target models identified (all models or specific subset)
- [ ] Validation level defined (syntax, semantic, or both)
- [ ] Previous validation results reviewed (if applicable)
- [ ] Expected validation criteria understood
- [ ] Critical vs. warning-level issues defined
- [ ] Baseline compliance requirements established

## Step 2: Pre-Validation File Checks

- [ ] All .c4 model files are accessible
- [ ] View files exist and are readable
- [ ] Specification file exists (if required)
- [ ] No file permission issues
- [ ] File encoding is correct (UTF-8)
- [ ] No corrupted or incomplete files
- [ ] Backup of current state created (optional but recommended)

## Step 3: Syntax Validation

- [ ] LikeC4 CLI syntax check executed
- [ ] All model files parsed successfully
- [ ] No syntax errors reported, or all errors documented:
  - [ ] Missing braces/brackets
  - [ ] Invalid keywords
  - [ ] Malformed declarations
  - [ ] Quote/string issues
  - [ ] Indentation problems
- [ ] View definitions validated
- [ ] Specification syntax verified
- [ ] Error messages captured with file/line references

## Step 4: Semantic Validation

- [ ] Component definitions are complete
- [ ] Relationships reference existing components
- [ ] No circular dependencies detected
- [ ] Ownership joins are valid
- [ ] Execution stages are properly defined
- [ ] Story overlays reference valid stories
- [ ] Data flow definitions are coherent
- [ ] Technology tags are valid
- [ ] No orphaned references
- [ ] View references resolve correctly

## Step 5: Modeling Guidelines Compliance

- [ ] Naming conventions followed (from Modeling Guidelines)
- [ ] Required metadata present on all components
- [ ] Annotation standards met
- [ ] File organization matches standards
- [ ] Component types used correctly
- [ ] Relationship types appropriate
- [ ] Documentation comments present where required
- [ ] Template patterns followed consistently

## Step 6: Starter Pack Validation Checks

- [ ] Custom validation scripts executed (if available)
- [ ] Domain-specific rules checked
- [ ] Project-specific conventions verified
- [ ] Required views all defined
- [ ] Catalog completeness verified
- [ ] Change log references validated
- [ ] Journal entry consistency checked

## Step 7: View Generation Test

- [ ] Attempt to generate views from models
- [ ] System context views render correctly
- [ ] Container views render correctly
- [ ] Component views render correctly
- [ ] Dynamic views render correctly (if used)
- [ ] Deployment views render correctly (if used)
- [ ] Custom views render correctly
- [ ] No rendering errors or warnings
- [ ] View output matches expected format

## Step 8: Issue Categorization

- [ ] Critical errors identified (prevent compilation):
  - [ ] Syntax errors
  - [ ] Invalid references
  - [ ] Missing required elements
  - [ ] Circular dependencies
- [ ] Major warnings identified (impact usability):
  - [ ] Incomplete definitions
  - [ ] Missing documentation
  - [ ] Inconsistent naming
  - [ ] Deprecated patterns
- [ ] Minor warnings identified (style/convention):
  - [ ] Formatting issues
  - [ ] Optional metadata missing
  - [ ] Comment improvements needed
  - [ ] Style inconsistencies
- [ ] Each issue assigned priority and severity

## Step 9: Remediation Guidance

- [ ] Fix instructions provided for each critical error
- [ ] Fix instructions provided for major warnings
- [ ] Recommendations for minor improvements
- [ ] Example code/patterns provided where helpful
- [ ] Files requiring updates listed
- [ ] Update priorities assigned
- [ ] Estimated effort documented
- [ ] Dependencies between fixes noted
- [ ] Quick wins identified

## Step 10: Validation Report Generation

- [ ] Validation summary includes:
  - [ ] Validation date and version
  - [ ] Models validated (count and names)
  - [ ] Overall validation status (pass/fail)
  - [ ] Error counts by severity
  - [ ] Warning counts by category
- [ ] Detailed findings section complete with:
  - [ ] File/line references for all issues
  - [ ] Error/warning messages
  - [ ] Context around each issue
  - [ ] Impact assessment
- [ ] Remediation section includes:
  - [ ] Step-by-step fix instructions
  - [ ] Code examples
  - [ ] Best practices references
  - [ ] Priority matrix
- [ ] Report saved to validation output directory
- [ ] Supporting logs and outputs attached

## Post-Workflow Quality Checks

- [ ] All file paths stayed within architecture workspace
- [ ] LikeC4 CLI output captured completely
- [ ] All issues documented with sufficient detail
- [ ] Remediation guidance is specific and actionable
- [ ] No false positives included
- [ ] Severity classifications justified
- [ ] Professional formatting for review
- [ ] Audit trail complete

## Traceability Requirements

- [ ] Validation timestamp recorded
- [ ] LikeC4 CLI version documented
- [ ] Model file versions captured
- [ ] Starter pack version noted
- [ ] All issues numbered and tracked
- [ ] Previous validation results linked (if applicable)
- [ ] Fix tracking enabled for follow-up

## Output Quality Standards

- [ ] All findings are reproducible
- [ ] Error messages clearly explained
- [ ] Remediation guidance is clear and actionable
- [ ] Technical accuracy verified
- [ ] Report supports architecture governance
- [ ] Ready for architect review
- [ ] Enables continuous compliance

## Common Issues to Avoid

- [ ] Running validation without LikeC4 CLI installed
- [ ] Missing model files in validation scope
- [ ] Incomplete error documentation
- [ ] Vague remediation instructions
- [ ] No prioritization of issues
- [ ] Missing file/line references
- [ ] No follow-up action plan
- [ ] Incomplete audit trail
- [ ] No user confirmation

## CLI Execution Checks

- [ ] Correct LikeC4 CLI command syntax used
- [ ] All required parameters provided
- [ ] Working directory is correct
- [ ] Output format appropriate (JSON, text, etc.)
- [ ] Exit codes checked and interpreted
- [ ] Standard output captured
- [ ] Standard error captured
- [ ] Execution time recorded

## Validation Metrics

- [ ] Total models validated
- [ ] Models passing validation
- [ ] Models with errors
- [ ] Total error count
- [ ] Total warning count
- [ ] Critical error count
- [ ] Major warning count
- [ ] Minor warning count
- [ ] Validation pass rate percentage
- [ ] Trend analysis (if repeat validation)

## Continuous Validation Support

- [ ] Validation can be automated (if desired)
- [ ] Integration with CI/CD discussed (if applicable)
- [ ] Pre-commit validation hooks suggested
- [ ] Validation schedule recommended
- [ ] Baseline established for future validations
- [ ] Regression detection enabled

## Success Criteria

- [ ] Complete LikeC4 validation executed
- [ ] All syntax and semantic issues identified
- [ ] Clear, detailed validation report produced
- [ ] Actionable remediation guidance provided
- [ ] Issues prioritized and categorized
- [ ] Ready for architect and team review
- [ ] Supports quality assurance process
- [ ] User confirmed validation completeness
- [ ] Follow-up actions clearly defined
- [ ] Continuous validation process enabled