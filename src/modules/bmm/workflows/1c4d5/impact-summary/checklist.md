# Impact Summary Workflow Validation Checklist

## Pre-Workflow Validation

- [ ] Architecture workspace root is configured in bmad/bmm/config.yaml
- [ ] 1C4D5 documentation exists and is up-to-date
- [ ] code_tools MCP server is available
- [ ] User has defined the proposed change or feature
- [ ] Target stakeholders identified (architect, PO, etc.)

## Step 1: Change Context Gathering

- [ ] Proposed change description captured
- [ ] Related story/ticket/epic identified
- [ ] Business justification documented
- [ ] Technical scope defined
- [ ] Expected benefits articulated
- [ ] Timeline constraints noted
- [ ] Related ADRs or decisions referenced

## Step 2: Architecture Impact Analysis

- [ ] Affected systems/components identified
- [ ] Impacted C4 layers documented (containers, components, etc.)
- [ ] D-layer impacts assessed (flows, joins, stories)
- [ ] Ownership changes evaluated
- [ ] Execution stage modifications analyzed
- [ ] Integration point impacts identified
- [ ] Performance/scalability implications considered
- [ ] Security implications assessed

## Step 3: Code Evidence Collection

- [ ] code_tools executed for relevant code paths
- [ ] Current implementation state documented
- [ ] Proposed changes mapped to code locations
- [ ] Dependencies and coupling identified
- [ ] Test coverage implications assessed
- [ ] Migration/deployment considerations noted
- [ ] Technical debt implications evaluated

## Step 4: LikeC4 Model Review

- [ ] Current model state reviewed
- [ ] Required model updates identified
- [ ] View changes assessed
- [ ] Documentation updates scoped
- [ ] Consistency requirements defined

## Step 5: Stakeholder Impact Assessment

- [ ] Team/ownership impacts identified
- [ ] Downstream system impacts documented
- [ ] User-facing impacts assessed
- [ ] Operational impacts considered
- [ ] Training/documentation needs identified
- [ ] Communication requirements defined

## Step 6: Risk and Mitigation Analysis

- [ ] Technical risks identified and categorized
- [ ] Business risks documented
- [ ] Mitigation strategies proposed
- [ ] Contingency plans outlined
- [ ] Risk severity assessed (high/medium/low)
- [ ] Acceptance criteria defined

## Step 7: Impact Summary Report Generation

- [ ] Executive summary created (non-technical)
- [ ] Technical summary created (for engineers)
- [ ] Change overview included
- [ ] Architecture impact section complete
- [ ] Code impact section complete
- [ ] Risk analysis section complete
- [ ] Mitigation recommendations included
- [ ] Timeline and effort estimates provided
- [ ] Stakeholder-specific recommendations included
- [ ] Visual diagrams/charts included (if beneficial)
- [ ] Decision recommendation provided (approve/defer/modify)

## Post-Workflow Quality Checks

- [ ] All file paths stayed within architecture workspace
- [ ] code_tools evidence properly cited
- [ ] All claims are evidence-backed
- [ ] Technical accuracy verified
- [ ] Business context clearly explained
- [ ] Professional stakeholder-ready formatting
- [ ] No jargon without explanation
- [ ] Actionable recommendations provided

## Report Quality Standards

- [ ] Executive summary understandable by non-technical stakeholders
- [ ] Technical details sufficient for architect review
- [ ] Risks clearly articulated with severity
- [ ] Mitigation strategies are specific and actionable
- [ ] Evidence supports all claims
- [ ] Neutral, objective tone maintained
- [ ] Clear recommendation provided
- [ ] Next steps defined

## Stakeholder Communication

- [ ] Report tailored to audience needs
- [ ] Key decision points highlighted
- [ ] Trade-offs clearly explained
- [ ] Options presented where applicable
- [ ] Timeline implications clear
- [ ] Resource requirements stated
- [ ] Approval/review process defined

## Traceability Requirements

- [ ] Change request linked to source
- [ ] Evidence timestamped and versioned
- [ ] Model files and versions documented
- [ ] Code paths clearly referenced
- [ ] Dependencies explicitly mapped
- [ ] Review trail established

## Common Issues to Avoid

- [ ] Making technical claims without code evidence
- [ ] Omitting business context
- [ ] Unclear or vague recommendations
- [ ] Missing risk assessment
- [ ] No mitigation strategies
- [ ] Incomplete stakeholder analysis
- [ ] Too technical for intended audience
- [ ] No clear decision recommendation
- [ ] Missing effort/timeline estimates

## Validation Checks

- [ ] All referenced systems exist in model
- [ ] All code paths are valid
- [ ] Risk assessments are realistic
- [ ] Effort estimates are reasonable
- [ ] Recommendations are actionable
- [ ] No broken references in report

## Success Criteria

- [ ] Comprehensive impact analysis completed
- [ ] Evidence-backed findings throughout
- [ ] Clear, stakeholder-appropriate communication
- [ ] Actionable recommendations provided
- [ ] Risks and mitigations well-defined
- [ ] Ready for architect and PO review
- [ ] Supports informed decision-making
- [ ] User confirmed report completeness
- [ ] Follow-up actions clearly defined