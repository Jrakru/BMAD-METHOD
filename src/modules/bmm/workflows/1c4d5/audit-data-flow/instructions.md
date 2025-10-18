# Audit 1C4D5 Data Flow

<workflow>

<critical>Use the code_tools MCP server to map the real data path before relying on existing documentation.</critical>
<critical>Keep all file reads and edits within {{c4d5_root}} unless the user authorizes broader access.</critical>

<step n="1" goal="Define the flow under review">
  <action>Create the directory {{audit_output_dir}} if it does not exist.</action>
  <ask response="flow_name">Which data flow or stage should we audit?</ask>
  <ask response="business_context">What business capability or scenario triggers this flow?</ask>
  <ask response="entry_exit_points">Identify the entry points (APIs, events) and exit points (stores, downstream systems).</ask>
  <ask response="code_modules">List code modules/packages involved (space-separated for automation).</ask>
  <ask optional="true" response="known_concerns">List any known issues or hypotheses to verify.</ask>
  <template-output>audit_target</template-output>
</step>

<step n="2" goal="Trace implementation with code_tools">
  <action>Run code_tools dependency/maps against the referenced modules to uncover participating services, functions, and data stores.</action>
  <action>Execute {{code_tools_script}} summary {{code_modules}} --export "data-flow-audit-{{date}}.json" to capture summarised metrics.</action>
  <action>Capture notable findings: service boundaries, queues/topics, database tables, transformations, external calls.</action>
  <action>If code_tools reports drift or TODO areas, note them for follow-up.</action>
  <template-output>code_observations</template-output>
</step>

<step n="3" goal="Inspect LikeC4 D-layer representation">
  <action>Open relevant flow/model files in {{likec4_model_dir}} (e.g., D2_flow, D3_stage_exec_on, D1_product/owned_by).</action>
  <action>Verify that every stage has matching <code>exec_on</code> joins and every product has <code>owned_by</code> joins.</action>
  <action>Confirm that the story overlays reference the same tokens observed in code.</action>
  <template-output>documentation_review</template-output>
</step>

<step n="4" goal="Compare reality versus documentation">
  <action>List mismatches: missing stages, inaccurate relationships, outdated story hops, or undocumented data stores.</action>
  <action>Highlight any unnecessary diagram elements that code_tools shows as obsolete.</action>
  <action>Identify remediation tasks (diagram edits, code clean-up, follow-up research).</action>
  <template-output>gaps_and_actions</template-output>
</step>

<step n="5" goal="Summarize findings for stakeholders">
  <action>Synthesize the audit with sections for Overview, Evidence (code_tools snippets + file refs), Documentation gaps, Recommended actions, and Validation suggestions.</action>
  <action>Note whether to trigger the update-diagram workflow immediately or schedule a broader refactor.</action>
  <template-output>audit_summary</template-output>
  <ask>Share audit summary with architect/product owner now? (y/n)</ask>
</step>

</workflow>
