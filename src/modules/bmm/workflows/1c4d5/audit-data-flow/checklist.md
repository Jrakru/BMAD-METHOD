# Audit Data Flow Workflow Validation Checklist

## Pre-Workflow Validation

- [ ] Architecture workspace root is configured in bmad/bmm/config.yaml
- [ ] 1C4D5 documentation has been initialized (init-diagram completed)
- [ ] code_tools MCP server is available
- [ ] User has identified the specific data flow to audit
- [ ] Target system/diagram exists in LikeC4 model directory

## Step 1: Data Flow Identification

- [ ] Data flow name/ID captured from user
- [ ] Source system/component identified
- [ ] Destination system/component identified
- [ ] Intermediate systems/components listed
- [ ] Expected data transformations documented
- [ ] Relevant D-layer files identified
- [ ] Related story overlays noted (if applicable)

## Step 2: Code Evidence Collection

- [ ] code_tools executed to trace data flow in codebase
- [ ] Source code paths identified
- [ ] Data transformation logic located
- [ ] API endpoints/interfaces documented
- [ ] Database operations traced
- [ ] Message queue/event handling mapped
- [ ] External integrations identified
- [ ] Evidence exported for audit trail

## Step 3: LikeC4 Model Review

- [ ] Relevant D-layer files read and understood
- [ ] Data flow representation located in models
- [ ] Execution stages reviewed
- [ ] Story overlays examined
- [ ] Ownership joins verified
- [ ] Flow annotations checked
- [ ] Related views inspected

## Step 4: Discrepancy Analysis

- [ ] Code evidence compared with LikeC4 representation
- [ ] Differences identified and categorized:
  - [ ] Missing components in diagram
  - [ ] Extra components in diagram (no longer in code)
  - [ ] Incorrect flow direction
  - [ ] Missing transformation steps
  - [ ] Incorrect ownership mapping
  - [ ] Outdated story overlays
  - [ ] Stale execution stage assignments
- [ ] Severity assessed for each discrepancy (critical, major, minor)
- [ ] Root cause identified (when possible)

## Step 5: Remediation Planning

- [ ] Fix strategy defined for each discrepancy
- [ ] Files requiring updates listed
- [ ] Update priority assigned
- [ ] Owner identified for each fix
- [ ] Estimated effort documented
- [ ] Dependencies between fixes noted

## Step 6: Audit Report Generation

- [ ] Audit report created with:
  - [ ] Executive summary
  - [ ] Data flow overview
  - [ ] Code evidence summary
  - [ ] Model representation summary
  - [ ] Detailed discrepancy list
  - [ ] Remediation plan
  - [ ] Priority recommendations
  - [ ] Timeline estimates
- [ ] Report saved to audit output directory
- [ ] Supporting evidence files referenced
- [ ] Stakeholders identified for review

## Post-Workflow Quality Checks

- [ ] All file paths stayed within architecture workspace
- [ ] code_tools used as primary evidence source
- [ ] Direct file reads documented when used as fallback
- [ ] All discrepancies have clear descriptions
- [ ] Remediation recommendations are actionable
- [ ] Audit trail is complete and traceable
- [ ] Professional tone and precision maintained

## Traceability Requirements

- [ ] Audit linked to specific data flow and version
- [ ] Code evidence timestamped
- [ ] Model files and versions documented
- [ ] Discrepancies numbered and tracked
- [ ] Remediation plan includes acceptance criteria
- [ ] Review and approval process defined

## Output Quality Standards

- [ ] Audit findings are evidence-backed
- [ ] No assumptions made without documentation
- [ ] Discrepancies are specific and verifiable
- [ ] Remediation guidance is clear and actionable
- [ ] Report is review-ready for architect and stakeholders
- [ ] All technical terms explained or referenced

## Common Issues to Avoid

- [ ] Auditing without sufficient code evidence
- [ ] Making assumptions about missing documentation
- [ ] Incomplete discrepancy descriptions
- [ ] Missing remediation recommendations
- [ ] Unclear severity classifications
- [ ] No stakeholder notification
- [ ] Incomplete audit trail
- [ ] Missing user confirmation

## Validation Checks

- [ ] All identified components exist in codebase
- [ ] All referenced model files are valid
- [ ] Data flow trace is complete end-to-end
- [ ] No broken references in report
- [ ] Evidence files are accessible
- [ ] Timestamps are accurate

## Success Criteria

- [ ] Complete data flow audit performed
- [ ] All discrepancies identified and documented
- [ ] Evidence-backed findings with clear traceability
- [ ] Actionable remediation plan produced
- [ ] Report ready for architect and stakeholder review
- [ ] Audit trail suitable for governance purposes
- [ ] User confirmed audit completeness
- [ ] Follow-up actions clearly assigned