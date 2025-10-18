# Update 1C4D5 Diagram Assets

<workflow>

<critical>Operate strictly inside {{project_docs_root}} (the architecture workspace) unless the user explicitly authorizes additional paths.</critical>
<critical>Prefer the code_tools MCP server for any repository analysis; read source files directly only if code_tools cannot supply the needed detail.</critical>
<critical>All diagram edits must preserve LikeC4 syntax and follow the Modeling Guidelines and View Catalog references.</critical>

<step n="1" goal="Capture the requested change">
  <action>Ensure {{journal_dir}} exists for logging updates.</action>
  <ask response="change_summary">Describe the change that triggered this diagram update.</ask>
  <ask response="impacted_domains">Which modules, services, or data stores are affected? (Provide space-separated identifiers for automation.)</ask>
  <ask response="linked_artifacts">List any related tickets, PRs, or decision records to reference.</ask>
  <template-output>change_context</template-output>
</step>

<step n="2" goal="Map implementation reality with code_tools">
  <action>Use code_tools MCP commands to collect current insights about the cited modules (dependency graphs, hotspots, or summaries).</action>
  <action>Execute {{code_tools_script}} summary {{impacted_domains}} --export "diagram-update-{{date}}.json" to capture a reusable export.</action>
  <ask optional="true" response="code_tools_commands">Specify additional code_tools queries to run (enter "none" to skip).</ask>
  <action>Summarize key implementation facts that must be reflected in the diagrams.</action>
  <template-output>implementation_findings</template-output>
</step>

<step n="3" goal="Review existing diagrams and stories">
  <action>List relevant LikeC4 model files in {{likec4_model_dir}} that map to the impacted domains.</action>
  <action>If {{likec4_views_file}} is missing, copy {{starter_pack_root}}/likec4/views/views.c4 to that path; then review the relevant views.</action>
  <action>Check {{starter_pack_root}}/docs for any guidance that constrains the update (Modeling-Guidelines, View-Catalog, Story-Guide). If your quick reference is up to date, skim for changes; otherwise re-read the docs.</action>
  <action>If the change affects a story path, review the story definitions in {{project_docs_root}}/likec4/model/Story.c4 (or equivalent file). Copy from the starter pack if the file is missing.</action>
  <template-output>existing_diagram_snapshot</template-output>
</step>

<step n="4" goal="Plan the diagram changes">
  <action>Determine which elements require updates (containers, components, data flows, stages, owned_by joins, exec_on joins).</action>
  <action>Decide whether to append new entries using templates in {{templates_dir}} or edit existing blocks.</action>
  <action>Ensure every new element has the necessary joins between C4 and D-layer assets.</action>
  <template-output>diagram_update_plan</template-output>
</step>

<step n="5" goal="Apply updates to LikeC4 assets">
  <action>Edit the identified LikeC4 model files under {{likec4_model_dir}}, inserting or adjusting definitions to match the plan.</action>
  <action>Reference templates in {{templates_dir}} for consistent syntax when adding new stages, flows, products, or containers.</action>
  <action>Update story overlays if end-to-end paths change.</action>
  <action>Document each modified file and the exact changes made.</action>
  <template-output>diagram_changes</template-output>
</step>

<step n="6" goal="Update narrative records and follow-up">
  <action>Append a journal entry in {{journal_dir}} using the same format as initialization (date, change summary, impacted files, evidence). If helpful, reuse {{journal_template}}.</action>
  <action>Add or update the corresponding line in {{change_log_file}}, capturing who made the change, when, and why.</action>
  <action>If {{specification_file}} tracks catalog entries, ensure the change is reflected there as well.</action>
  <action>Summarize the update, noting affected files, rationale, validation status, outstanding gaps, and follow-up owners.</action>
  <template-output>review_summary</template-output>
  <ask>Ready to mark this update complete? (y/n)</ask>
</step>

</workflow>
