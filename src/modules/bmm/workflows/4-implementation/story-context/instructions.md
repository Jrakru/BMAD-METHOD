<!-- BMAD BMM Story Context Assembly Instructions (v6) -->

```xml
<critical>The workflow execution engine is governed by: {project_root}/bmad/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: {installed_path}/workflow.yaml</critical>
<critical>Communicate all responses in {communication_language} tailored to {user_skill_level}; generated documents must be in {document_output_language}</critical>
<critical>This workflow assembles a Story Context XML for a single user story by combining the reusable epic spine and story-specific research (ACs, tasks, docs, code touchpoints, tests) so the DEV agent can implement with zero guesswork.</critical>
<critical>Default execution mode: #yolo (non-interactive). Only elicit input when {{non_interactive}} == false. If auto-discovery fails, HALT and request explicit paths.</critical>

<workflow>

  <step n="1" goal="Validate workflow sequence">
    <invoke-workflow path="{project-root}/bmad/bmm/workflows/workflow-status">
      <param>mode: validate</param>
      <param>calling_workflow: story-context</param>
    </invoke-workflow>

    <check if="warning != ''">
      <output>{{warning}}</output>
      <ask>Continue with story-context anyway? (y/n)</ask>
      <check if="n">
        <output>{{suggestion}}</output>
        <action>Exit workflow</action>
      </check>
    </check>

    <action>Store {{status_file_path}} for later updates</action>
  </step>

  <step n="2" goal="Locate story and initialize template">
    <action>If {{story_path}} provided → validate existence. Otherwise, read {{story_dir}} and list markdown files named "story-*.md".</action>
    <action>If no stories found → HALT with guidance to run create-story first.</action>
    <action>If {{non_interactive}} == false → display top {{story_selection_limit}} candidates (index, filename, modified time) and ASK for selection/path. If == true → use most recently modified file.</action>
    <action>READ the selected story; extract:
      - {{epic_id}}, {{story_id}} from filename/header
      - {{story_title}}, {{story_status}}
      - Story narrative (As/I want/So that)
      - Acceptance criteria (preserve order)
      - Tasks/Subtasks block
      - Dev Notes / Project Structure Notes for later hints.</action>
    <action>Normalize project-relative paths by stripping {project-root} prefix when recording artifacts.</action>
    <action>Initialize {default_output_file} from template and seed:
      - metadata fields (epic_id, story_id, title, status, generatedAt)
      - story narrative and tasks
      - acceptance criteria as bullet list (numbered).</action>
  </step>

  <step n="3" goal="Ensure epic context spine is current">
    <action>Derive shared artifact paths:
      - {{epic_context_xml}} = {{epic_context_dir}}/epic-context-{{epic_id}}.xml
      - {{epic_context_md}} = {{epic_context_dir}}/epic-context-{{epic_id}}.md
      - {{epic_context_lock}} = {{epic_context_dir}}/epic-context-{{epic_id}}.lock</action>

    <check if="{{auto_refresh_epic_context}} == true">
      <check if="{{epic_context_lock}} exists">
        <action>Wait up to {{epic_context_lock_timeout_seconds}} seconds for the lock to clear (poll every 5 seconds). If still locked after timeout → HALT with message "Epic context lock active for epic {{epic_id}}. Retry shortly."</action>
      </check>
    </check>

    <check if="{{auto_refresh_epic_context}} == true">
      <check if="epic_context_xml missing">
        <invoke-workflow path="{{epic_context_workflow}}">
          <param>epic_id: {{epic_id}}</param>
          <param>run_mode: build</param>
          <param>non_interactive: true</param>
        </invoke-workflow>
      </check>
    </check>

    <action>If {{epic_context_xml}} still missing → HALT with instructions: "Run epic-context (Epic {{epic_id}}) to build the spine, then retry."</action>

    <action>READ {{epic_context_xml}} and PARSE via XML tools into {{epic_context_data}} (doc_index, docs, constraints, tests, dependencies, code_baseline, coverage).</action>

    <check if="{{auto_refresh_epic_context}} == true">
      <action>Compute current SHA256 for each document listed in doc_index (using hash_file on {project-root}/{{doc.path}}). Collect mismatches.</action>
      <check if="mismatches not empty">
        <check if="{{block_until_fresh}} == true">
          <invoke-workflow path="{{epic_context_workflow}}">
            <param>epic_id: {{epic_id}}</param>
            <param>run_mode: refresh</param>
            <param>force_refresh: true</param>
            <param>non_interactive: true</param>
          </invoke-workflow>
          <action>Reload {{epic_context_xml}}; recompute hashes. If mismatches persist → HALT with message "Epic context could not be refreshed automatically. Resolve doc diffs then rerun epic-context."</action>
        </check>
        <check if="{{block_until_fresh}} == false">
          <output>⚠️ Epic {{epic_id}} source documents changed: {{mismatches}}. Proceeding without refresh (auto_refresh disabled).</output>
        </check>
      </check>
    </check>

    <action>Ensure coverage entry exists for {{story_id}}. If missing → append new entry with consulted=false (in-memory only for now).</action>
    <check if="coverage entry consulted == false">
      <invoke-workflow path="{{epic_context_workflow}}">
        <param>epic_id: {{epic_id}}</param>
        <param>run_mode: consult</param>
        <param>target_story_id: {{story_id}}</param>
        <param>story_title: {{story_title}}</param>
        <param>non_interactive: true</param>
      </invoke-workflow>
      <action>Reload {{epic_context_xml}} to pick up latest coverage metadata.</action>
    </check>

    <action>Extract shared components from epic context and build baseline markup strings (do NOT write to template yet):
      - {{base_docs_markup}} beginning with "Shared Epic References:" followed by bullet list `- [Shared] {section} — `{path}` :: {snippet}` for each entry.
      - {{base_constraints_markup}} listing `- [Shared] …` for each constraint.
      - {{base_test_standards}} = shared_tests.standards.
      - {{base_test_locations_markup}} listing `- [Shared] path`.
      - {{base_test_ideas_markup}} listing `- [Shared] idea`.
      - {{base_dependencies_markup}} listing `- [Shared ecosystem] package (version)`.
      - {{base_code_markup}} listing `- [Shared] path → symbol — reason`.</action>
    <action>Retain the raw lists (shared_docs, shared_constraints, shared_tests, shared_dependencies, shared_code_baseline) for deduplication when adding story-specific entries.</action>
  </step>

  <step n="4" goal="Collect story-specific documentation">
    <action>Initialize {{docs_markup}} with {{base_docs_markup}}.</action>
    <action>Scan authoritative sources (story, epic tech spec, PRD, architecture, standards) for additional sections unique to this story (e.g., implementation notes, niche constraints) not already covered in the epic spine.</action>
    <action>For each new reference:
      - Ensure it is not already present in shared_docs (compare path + section).
      - Produce a concise snippet (≤3 sentences).
      - Append to {{docs_markup}} as `- [Story] …` bullet.</action>
    <template-output file="{default_output_file}">
      docs_artifacts {{docs_markup}}
    </template-output>
  </step>

  <step n="5" goal="Analyze existing code, interfaces, and constraints">
    <action>Scope search to modules referenced by epic context (shared_code_baseline paths) plus sections mentioned in Dev Notes/tasks.</action>
    <action>Initialize {{code_markup}} = {{base_code_markup}} and {{constraints_markup}} = {{base_constraints_markup}}.</action>
    <action>Identify code artifacts the developer must touch or review (classes, functions, tests). For each new artifact (not already in shared_code_baseline), append bullet `- [Story] …` to {{code_markup}} with rationale.</action>
    <action>Add any new constraints (e.g., thread-safety, error handling) ensuring no duplicates with shared constraints; append as `- [Story] …`.</action>
    <action>List interface signatures required for this story (pull from tech spec or code stubs). Output as bullet list inside {{interfaces}} field.</action>
    <template-output file="{default_output_file}">
      code_artifacts {{code_markup}}
    </template-output>
    <template-output file="{default_output_file}">
      constraints {{constraints_markup}}
    </template-output>
    <template-output file="{default_output_file}">
      interfaces {{#story_interfaces}}- {{name}} — {{signature}} (`{{path}}`)
{{/story_interfaces}}
    </template-output>
  </step>

  <step n="6" goal="Consolidate dependencies and frameworks">
    <action>Set {{dependencies_markup}} = {{base_dependencies_markup}}.</action>
    <action>Inspect manifests relevant to this story (e.g., pyproject.toml, package.json). For each new package or tool not already in shared list, append labelled `[Story]` to {{dependencies_markup}} (group by ecosystem when helpful).</action>
    <template-output file="{default_output_file}">
      dependencies_artifacts {{dependencies_markup}}
    </template-output>
  </step>

  <step n="7" goal="Refine testing standards and ideas">
    <action>Initialize {{combined_test_standards}} = {{base_test_standards}}.</action>
    <action>Initialize {{combined_test_locations}} = {{base_test_locations_markup}}.</action>
    <action>Initialize {{combined_test_ideas}} = {{base_test_ideas_markup}}.</action>
    <action>Augment shared testing guidance with story-specific expectations:
      - Extend standards paragraph with unique verification notes.
      - Add new locations (e.g., dedicated test folders) if required.
      - Generate concrete test ideas mapped to acceptance criteria IDs, labelled `[Story][ACx]`.</action>
    <action>If additional standards text created → append to {{combined_test_standards}} separated by blank line.</action>
    <action>If new locations exist → append bullets `- [Story] …` to {{combined_test_locations}}.</action>
    <action>If new test ideas generated → append `- [Story][ACx] ...` entries to {{combined_test_ideas}}.</action>
    <template-output file="{default_output_file}">
      test_standards {{combined_test_standards}}
    </template-output>
    <template-output file="{default_output_file}">
      test_locations {{combined_test_locations}}
    </template-output>
    <template-output file="{default_output_file}">
      test_ideas {{combined_test_ideas}}
    </template-output>
  </step>

  <step n="8" goal="Validate output and persist context">
    <action>Validate XML structure against checklist at {installed_path}/checklist.md using bmad/core/tasks/validate-workflow.xml.</action>
    <invoke-task>Validate against checklist at {installed_path}/checklist.md using bmad/core/tasks/validate-workflow.xml</invoke-task>
    <action>Open {{story_path}}; if Status == 'Draft' set to 'ContextReadyDraft'. Update Dev Agent Record → Context Reference with {default_output_file}. Save story.</action>
  </step>

  <step n="9" goal="Update workflow status file">
    <action>Locate {output_folder}/bmm-workflow-status.md (latest). If missing → skip update.</action>
    <check if="status file exists">
      <invoke-workflow path="{project-root}/bmad/bmm/workflows/workflow-status">
        <param>mode: update</param>
        <param>action: set_current_workflow</param>
        <param>workflow_name: story-context</param>
        <param>story_id: {{story_id}}</param>
        <param>epic_id: {{epic_id}}</param>
        <param>context_file: {default_output_file}</param>
      </invoke-workflow>

      <check if="success == true">
        <output>✅ Status updated: Context generated for Story {{story_id}}</output>
      </check>

      <output>**✅ Story Context Generated Successfully, {user_name}!**

**Story Details:**
- Story ID: {{story_id}}
- Title: {{story_title}}
- Context File: {{default_output_file}}

**Status file updated:**
- Current step: story-context (Story {{story_id}}) ✓
- Progress: {{new_progress_percentage}}%

**Next Steps:**
1. Load DEV agent (bmad/bmm/agents/dev.md)
2. Run `dev-story` workflow to implement the story
3. The context file will provide comprehensive implementation guidance

Check status anytime with: `workflow-status`</output>
    </check>

    <check if="status file not found">
      <output>**✅ Story Context Generated Successfully, {user_name}!**

**Story Details:**
- Story ID: {{story_id}}
- Title: {{story_title}}
- Context File: {{default_output_file}}

Note: Running in standalone mode (no status file).

To track progress across workflows, run `workflow-status` first.

**Next Steps:**
1. Load DEV agent and run `dev-story` to implement
      </output>
    </check>
  </step>

</workflow>
```
