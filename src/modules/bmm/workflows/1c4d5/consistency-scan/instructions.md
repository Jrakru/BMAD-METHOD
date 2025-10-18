# Scan 1C4D5 Consistency

<workflow>

<critical>This workflow is a governance sweep—capture evidence for every drift or alignment statement.</critical>
<critical>Use code_tools outputs as the source of truth for implementation state; diagrams and docs must line up with that evidence.</critical>

<step n="1" goal="Define scan scope">
  <action>Create the directory {{outputs_dir}} if it does not exist.</action>
  <ask response="scan_focus">Which modules, services, or diagrams should we prioritize in this scan?</ask>
  <ask optional="true" response="recent_changes">List recent releases or PRs that might have introduced drift.</ask>
  <ask optional="true" response="risk_flags">Note any risk areas (compliance, performance, data quality) needing extra scrutiny.</ask>
  <ask response="module_targets">Provide module/package identifiers to scan (space-separated for automation; enter 'none' if not applicable).</ask>
  <template-output>scan_scope</template-output>
</step>

<step n="2" goal="Gather implementation snapshot">
  <action>Run code_tools analyses to capture current dependency graphs, hotspots, and metrics for the scoped areas.</action>
  <action>If {{module_targets}} != "none" → Execute {{code_tools_script}} summary {{module_targets}} --export "consistency-scan-{{date}}.json".</action>
  <action>Export notable findings (e.g., new services, refactored modules, dormant code paths).</action>
  <action>If available, include code_tools change history or git metadata to spot churn.</action>
  <template-output>code_tools_snapshot</template-output>
</step>

<step n="3" goal="Compare documentation artifacts">
  <action>Iterate through LikeC4 model files in {{likec4_model_dir}} and verify that components/stages match the code_tools snapshot.</action>
  <action>Review supporting docs in {{docs_dir}} for statements that may now be outdated.</action>
  <action>Check story overlays to make sure hop sequences still align with real flows.</action>
  <template-output>documentation_comparison</template-output>
</step>

<step n="4" goal="Detect and classify drift">
  <action>Catalog discrepancies by severity: Critical (must fix now), Warning (schedule follow-up), Informational (monitor).</action>
  <action>Record the evidence path for each drift item (code_tools output, file lines, diagram IDs).</action>
  <action>Identify remediation owners (architect, feature team, documentation specialist).</action>
  <template-output>drift_findings</template-output>
</step>

<step n="5" goal="Recommend next actions">
  <action>Synthesize results into a concise summary with: Alignment highlights, Drift catalog, Required diagram updates, Follow-up tasks, Validation reminders.</action>
  <action>Call out when to trigger `update-diagram`, `audit-data-flow`, or `validate-likec4` as part of remediation.</action>
  <template-output>scan_summary</template-output>
  <ask>Notify architect/product owner about drift results now? (y/n)</ask>
</step>

</workflow>
