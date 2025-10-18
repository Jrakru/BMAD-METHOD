# Initialize 1C4D5 Diagram Assets

<workflow>

<critical>All file operations must stay inside {{project_docs_root}} (the architecture workspace) unless the user explicitly authorizes another path.</critical>
<critical>Prefer the code_tools MCP server for repository intelligence; fall back to direct file reads only when the MCP response is insufficient and note the fallback in your summary.</critical>
<critical>Every artifact you create should align with the Modeling Guidelines, View Catalog, and any system catalog entries.</critical>

<step n="1" goal="Capture scope for the new documentation package">
  <action>Ensure {{docs_dir}}, {{docs_dir}}/journal, {{project_docs_root}}/likec4/model, and {{project_docs_root}}/likec4/views exist (create directories as needed).</action>
  <ask response="diagram_name">What is the canonical name (slug-friendly) for the system, product, or flow you are documenting?</ask>
  <action>Derive {{diagram_slug}} by lowercasing {{diagram_name}} and replacing spaces with hyphens. Example: "Payment Gateway" → `payment-gateway`.</action>
  <action>If {{docs_dir}}/{{diagram_slug}}-overview.md exists, read it now and reuse any documented purpose, stakeholders, or code anchors.</action>
  <action>If the overview is missing, consult official PO/Architect documents (docs/phase2/PRD.md and docs/phase2/ARCH-2.3_ARCHITECTURE.md). If neither exists, ask the user to provide the correct source instead of inferring from other files.</action>
  <action>If those sources contain an executive summary or intro paragraph, confirm with the user before reusing it as the current business driver.</action>
  <action>If {{init_output_dir}} contains previous entries for {{diagram_slug}}, review the latest entry for context before asking further questions.</action>
  <ask optional="true" response="business_driver">Summarize the business or technical driver that requires this documentation. Only ask for new information when the sources above do not already contain it.</ask>
  <ask optional="true" response="code_anchor">List the authoritative code paths or repositories (newline separated) that prove the system exists. If they are already documented, confirm they are still accurate. When nothing is documented, default to the primary runtime (`{{runtime_dir}}`) and test suite (`{{tests_dir}}`) and simply note that assumption.</ask>
  <ask optional="true" response="stakeholders">Which stakeholders own or review this system? (Comma separated, leave blank if unknown.)</ask>
  <template-output>init_context</template-output>
</step>

<step n="2" goal="Review starter-pack references and gather reality checks">
  <action>Review {{starter_pack_root}}/docs/Modeling-Guidelines.md and {{starter_pack_root}}/docs/View-Catalog.md. If your quick reference already reflects the latest rules, skim for updates; otherwise read in full.</action>
  <action>Inspect the available templates under {{templates_dir}} (C4/D layers and docs) so you know which scaffolds exist.</action>
  <action>Run {{code_tools_script}} summary {{code_anchor}} --export "diagram-init-{{date}}.json" to capture baseline evidence from the code.</action>
  <ask optional="true" response="extra_research">Note any ADRs, tickets, or additional repos that must be consulted (enter "none" if nothing extra is required).</ask>
  <template-output>reference_findings</template-output>
</step>

<step n="3" goal="Scaffold LikeC4 model and view files">
  <action>List the C4 and D-layer assets you need (containers, flows, joins, stories). For each, record the planned filename `{{diagram_slug}}_<artifact>.c4`.</action>
  <action>Copy the relevant LikeC4 templates from {{templates_dir}} into {{project_docs_root}}/likec4/model using shell commands (e.g., `cp {{templates_dir}}/D1_product.c4.tmpl {{project_docs_root}}/likec4/model/{{diagram_slug}}_product.c4`).</action>
  <action>If {{likec4_views_file}} does not exist, copy {{starter_pack_root}}/likec4/views/views.c4 to that path; then append entries referencing each new model file and view name.</action>
  <action>Record every created or modified file so reviewers can trace the initialization work.</action>
  <template-output>scaffold_plan</template-output>
</step>

<step n="4" goal="Populate initial LikeC4 content">
  <action>Edit each new C4/D file, replacing template placeholders with the data gathered in Steps 1-2.</action>
  <action>Ensure ownership joins, execution stages, and story overlays align with the Modeling Guidelines and the `code_tools` evidence.</action>
  <action>Document any open questions or missing data that prevented full population of a file.</action>
  <template-output>initial_content</template-output>
</step>

<step n="5" goal="Seed narrative documentation & catalog entries">
  <action>Copy {{overview_template}} to {{docs_dir}}/{{diagram_slug}}-overview.md (if it does not already exist) and populate it with context, drivers, stakeholders, and links to the LikeC4 assets.</action>
  <action>Append a journal entry by copying {{journal_template}} to {{init_output_dir}}/{{date}}-{{diagram_slug}}-init.md (or updating the existing file) and recording evidence gathered in prior steps.</action>
  <action>Append a change-log entry to {{change_log_file}} using {{change_log_template}}, capturing who initialized the system, when, and why.</action>
  <action>If {{specification_file}} tracks system catalog entries, copy {{starter_pack_root}}/likec4/specification.c4 to that location if it does not exist, then add or update the record referencing the new asset and its owner.</action>
  <template-output>narrative_outputs</template-output>
</step>

<step n="6" goal="Validate and log next actions">
  <action>Optionally run {{project-root}}/scripts/run_likec4_validation.sh to ensure the models compile without errors.</action>
  <action>Summarize the initialization, including files created, validation status, narrative docs touched (including entries under {{init_output_dir}}), outstanding gaps, and follow-up owners.</action>
  <template-output>init_summary</template-output>
  <ask>Ready to mark initialization complete? (y/n)</ask>
</step>

</workflow>
