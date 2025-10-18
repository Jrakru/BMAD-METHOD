# Consistency Scan Workflow Validation Checklist

## Pre-Workflow Validation

- [ ] Architecture workspace root is configured in bmad/bmm/config.yaml
- [ ] 1C4D5 documentation set has been initialized
- [ ] Multiple diagram assets exist to scan for consistency
- [ ] code_tools MCP server is available
- [ ] Modeling Guidelines and View Catalog are accessible
- [ ] Access to architect/PO canonical documents (PRD, Architecture docs)

## Step 1: Scope Definition

- [ ] Scan scope defined (full library or subset)
- [ ] Target systems/diagrams identified
- [ ] Baseline references identified (PRD, architecture docs)
- [ ] Previous scan results reviewed (if applicable)
- [ ] Consistency criteria defined based on Modeling Guidelines
- [ ] Critical vs. non-critical discrepancies defined

## Step 2: Model Asset Inventory

- [ ] All C4 layer files enumerated
- [ ] All D-layer files enumerated
- [ ] View files inventoried
- [ ] Specification/catalog files checked
- [ ] Supporting documentation listed (overviews, journals, change logs)
- [ ] File versions/timestamps recorded
- [ ] Orphaned files identified

## Step 3: Internal Consistency Checks

- [ ] Cross-references between files validated
- [ ] Ownership joins consistent across layers
- [ ] Execution stages coherent across flows
- [ ] Story overlays align with defined stories
- [ ] Component relationships consistent
- [ ] Data flow integrity verified
- [ ] View definitions match model content
- [ ] No duplicate or conflicting definitions

## Step 4: Code Evidence Comparison

- [ ] code_tools executed for all documented systems
- [ ] Current codebase state captured
- [ ] Components in diagrams verified against code
- [ ] Data flows validated against actual implementation
- [ ] API contracts checked against code
- [ ] Integration points verified
- [ ] Deprecated code vs. active diagrams identified
- [ ] New code not yet documented identified

## Step 5: Canonical Reference Verification

- [ ] PRD requirements cross-referenced
- [ ] Architecture decisions (ADRs) verified
- [ ] System catalog entries validated
- [ ] Stakeholder information current
- [ ] Business drivers still accurate
- [ ] Technical constraints still valid
- [ ] Compliance requirements verified

## Step 6: Modeling Guidelines Compliance

- [ ] Naming conventions followed
- [ ] File organization standards met
- [ ] Required metadata present
- [ ] Annotation standards adhered to
- [ ] View Catalog standards followed
- [ ] Template usage consistent
- [ ] Documentation patterns uniform

## Step 7: Discrepancy Categorization

- [ ] Critical discrepancies identified:
  - [ ] Code/diagram mismatches
  - [ ] Broken references
  - [ ] Security/compliance gaps
  - [ ] Invalid ownership assignments
- [ ] Major discrepancies identified:
  - [ ] Outdated documentation
  - [ ] Missing components
  - [ ] Inconsistent naming
  - [ ] Incomplete flows
- [ ] Minor discrepancies identified:
  - [ ] Formatting inconsistencies
  - [ ] Missing annotations
  - [ ] Outdated comments
  - [ ] Style variations
- [ ] Each discrepancy assigned severity and priority

## Step 8: Remediation Recommendations

- [ ] Fix strategy defined for each critical issue
- [ ] Fix strategy defined for major issues
- [ ] Fix strategy defined for minor issues
- [ ] Files requiring updates listed
- [ ] Update priorities assigned
- [ ] Owners identified for each fix
- [ ] Effort estimates provided
- [ ] Dependencies between fixes documented
- [ ] Quick wins identified
- [ ] Long-term improvements suggested

## Step 9: Consistency Report Generation

- [ ] Scan summary includes:
  - [ ] Scan scope and date
  - [ ] Total assets scanned
  - [ ] Discrepancy counts by severity
  - [ ] Overall consistency score/rating
- [ ] Detailed findings section complete
- [ ] Remediation plan included
- [ ] Priority matrix provided
- [ ] Timeline recommendations given
- [ ] Governance recommendations included
- [ ] Next scan schedule suggested
- [ ] Report saved to output directory

## Post-Workflow Quality Checks

- [ ] All file paths stayed within architecture workspace
- [ ] code_tools used for evidence gathering
- [ ] All discrepancies clearly documented
- [ ] Recommendations are specific and actionable
- [ ] Severity assessments are justified
- [ ] No false positives included
- [ ] Audit trail is complete
- [ ] Professional governance-ready formatting

## Governance Requirements

- [ ] Scan methodology documented
- [ ] Evidence properly cited
- [ ] Findings are reproducible
- [ ] Remediation tracking enabled
- [ ] Stakeholder notification plan defined
- [ ] Follow-up process established
- [ ] Metrics captured for trend analysis

## Traceability Requirements

- [ ] Scan date and version recorded
- [ ] Scanned assets and versions documented
- [ ] Code evidence timestamped
- [ ] Baseline references cited
- [ ] Discrepancies numbered and tracked
- [ ] Previous scan results linked (if applicable)
- [ ] Remediation progress trackable

## Output Quality Standards

- [ ] Findings are evidence-backed
- [ ] No unsubstantiated claims
- [ ] Discrepancies are specific and verifiable
- [ ] Remediation guidance is clear
- [ ] Report supports governance decisions
- [ ] Suitable for architect and compliance review
- [ ] Metrics support trend analysis

## Common Issues to Avoid

- [ ] Scanning without baseline references
- [ ] Missing code evidence validation
- [ ] Incomplete asset inventory
- [ ] Vague discrepancy descriptions
- [ ] No prioritization of findings
- [ ] Missing remediation recommendations
- [ ] No governance follow-up plan
- [ ] Incomplete audit trail
- [ ] No user confirmation

## Validation Checks

- [ ] All referenced assets exist
- [ ] All code paths are valid
- [ ] Severity classifications are consistent
- [ ] Recommendations are feasible
- [ ] No broken references in report
- [ ] Timestamps are accurate
- [ ] Metrics are calculated correctly

## Metrics Tracking

- [ ] Total assets scanned
- [ ] Critical discrepancies count
- [ ] Major discrepancies count
- [ ] Minor discrepancies count
- [ ] Consistency score/percentage
- [ ] Time since last scan
- [ ] Remediation completion rate (if follow-up scan)
- [ ] Trend analysis (improvement/degradation)

## Success Criteria

- [ ] Comprehensive consistency scan completed
- [ ] All asset types included in scan
- [ ] Evidence-backed findings with clear traceability
- [ ] Actionable remediation plan produced
- [ ] Priority and severity clearly defined
- [ ] Ready for governance review
- [ ] Supports continuous improvement
- [ ] User confirmed scan completeness
- [ ] Follow-up actions clearly assigned
- [ ] Establishes baseline for future scans