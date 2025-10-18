# Summarize Architecture Impact

<workflow>

<critical>This workflow produces a communication artifact for the architect and product owner. Keep tone professional, evidence-backed, and concise.</critical>
<critical>Ground every statement in observable facts from code_tools analysis, LikeC4 assets, or referenced documents.</critical>

<step n="1" goal="Capture change context">
  <action>Create the directory {{summary_output_dir}} if it does not exist.</action>
  <ask response="initiative_name">Name of the feature or initiative under review?</ask>
  <ask response="drivers">What business or technical drivers make this change necessary?</ask>
  <ask response="impacted_modules">List impacted modules/packages (space-separated for automation).</ask>
  <ask response="timeframe">What is the expected delivery or decision timeframe?</ask>
  <ask optional="true" response="constraints">Note any constraints or assumptions (budgets, SLAs, compliance).</ask>
  <template-output>impact_context</template-output>
</step>

<step n="2" goal="Analyze architecture touchpoints">
  <action>Run relevant code_tools commands (module summaries, dependency graphs, hotspot reports) for the impacted areas.</action>
  <action>Execute {{code_tools_script}} summary {{impacted_modules}} --export "architecture-impact-{{date}}.json" to archive the findings.</action>
  <action>Cross-reference the current LikeC4 container and component diagrams to confirm ownership and boundaries.</action>
  <action>Identify architectural qualities at risk (scalability, latency, reliability, security) and the components responsible.</action>
  <template-output>architecture_findings</template-output>
</step>

<step n="3" goal="Assess data flow implications">
  <action>Review D-layer flows and story overlays covering the change.</action>
  <action>Note upstream/downstream systems, data contracts, and persistence changes required.</action>
  <action>Highlight potential data quality or lineage concerns surfaced by the analysis.</action>
  <template-output>data_flow_impacts</template-output>
</step>

<step n="4" goal="Plan documentation and validation actions">
  <action>List required updates to LikeC4 models, docs, or stories.</action>
  <action>Specify validation activities (run `update-diagram`, `audit-data-flow`, `validate-likec4`, regression checks).</action>
  <action>Add decision or follow-up items that need architect/PO attention.</action>
  <template-output>documentation_actions</template-output>
</step>

<step n="5" goal="Compose stakeholder summary">
  <action>Draft a concise report with sections: Overview, Architectural Impact, Data Flow Impact, Risks & Mitigations, Required Actions, Open Questions.</action>
  <action>Ensure each claim cites evidence (code_tools output, file paths, view names).</action>
  <template-output>stakeholder_summary</template-output>
  <ask>Send summary to architect/product owner? (y/n)</ask>
</step>

</workflow>
