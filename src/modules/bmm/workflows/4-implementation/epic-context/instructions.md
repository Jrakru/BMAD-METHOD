# Epic Context Workflow Instructions

````xml
<critical>The workflow execution engine is governed by: {project_root}/bmad/core/tasks/workflow.xml</critical>
<critical>You MUST have already loaded and processed: {installed_path}/workflow.yaml</critical>
<critical>This workflow builds and maintains the epic-level context spine consumed by story-context. It distills architecture, PRD, tech-spec, constraints, testing standards, dependencies, and coverage metadata into shared XML + Markdown artifacts.</critical>
<critical>Always operate on a single epic per run. Acquire the lock file before mutating artifacts to avoid concurrent writes.</critical>

<workflow>

  <step n="0" goal="Resolve epic id, mode, and acquire lock">
    <action>If {{epic_id}} empty: HALT with clear message. (Story-context auto-populates this; manual runs must supply it.)</action>
    <action>Normalize {{epic_id}} → strip whitespace → ensure numeric (e.g., "1").</action>
    <action>Resolve output paths: {{xml_output}}, {{md_output}}, {{lock_file}}.</action>
    <action>If {{run_mode}} == "auto":
      - If {{xml_output}} missing → set mode = build.
      - Else if {{target_story_id}} provided and coverage entry for that story is unchecked → set mode = consult.
      - Else → set mode = refresh.
    </action>
    <action>If {{run_mode}} == "consult" AND {{xml_output}} missing → set mode = build (consult requires existing spine).</action>
    <action>Attempt to create lock file {{lock_file}} with optimistic write (include process info & timestamp). If file already exists:
      - READ lock to check age. If < 2 minutes old → WAIT 10 seconds and retry up to 5 times.
      - If retries exhausted → HALT with message "Epic context lock active for epic {{epic_id}}. Try again shortly."</action>
  </step>

  <step n="1" goal="Assemble source document set">
    <action>Build the canonical list of input documents (in priority order):
      1) bmad/PRD.md (project requirements)
      2) bmad/epics.md (story breakdown)
      3) Epic tech spec: glob {project-root}/bmad/tech-spec-epic-{{epic_id}}*.md (pick latest by modified time)
      4) bmad/solution-architecture.md (overall architecture)
      5) Any epic-specific architecture/standards in {tech_docs_root}/ and {output_folder}/docs/ (e.g., testing-strategy.md, coding-standards.md)
      6) Product brief or research documents that explicitly mention the epic (optional – include when relevant)</action>
    <action>Verify each required document exists. If missing and {{run_mode}} in ["build","refresh"] → HALT with message listing the missing paths.</action>
    <action>For each included document, compute SHA256 hash of its full contents (use hash_file tool) and capture last modified timestamp (ISO 8601). Store in a temporary doc_index list for later serialization.</action>
  </step>

  <step n="2" goal="Extract reusable epic context">
    <action>For each required document, extract focused snippets relevant to Epic {{epic_id}}:
      - PRD: locate functional requirements, success criteria, and constraints referencing this epic.
      - Epics.md: capture the epic header, narrative, and risk/assumption blocks. Build the story coverage list from the ordered stories table/sections.
      - Tech spec: extract architecture decisions, module boundaries, data flows, and acceptance verification details.
      - Solution architecture & standards: capture constraints, patterns, environment requirements, coding/testing standards that apply to the epic.</action>
    <action>Summaries must be concise (2–3 sentences or bullet list) and cite the source document + section heading.</action>
    <action>Derive the following canonical sections:
      - constraints[]: non-negotiable patterns, boundaries, NFRs (list of short bullet strings).
      - tests.standards: paragraph describing testing approach for the epic.
      - tests.locations: list of directories/globs for relevant tests.
      - tests.shared_ideas: reusable scenarios that every story should consider (tie to epic-wide ACs when possible).
      - dependencies: runtime & dev packages (collect from pyproject.toml or other manifests; include name + version range).
      - code_baseline: shared interfaces/boundaries (path, symbol, brief reason). Focus on modules all stories will touch (e.g., AgentBackend interface, Registry module, shared DTOs).</action>
    <action>When deriving lists, avoid duplication; normalize paths relative to {project-root}.</action>
  </step>

  <step n="3" goal="Update coverage checklist">
    <action>Parse stories for Epic {{epic_id}} from bmad/epics.md (ordered list). For each story record story_id (e.g., "1.3") and title.
      - If existing {{xml_output}} present: read prior coverage section to preserve consulted flags/timestamps.
      - Merge with current story list → stories not present previously receive consulted=false by default.</action>
    <action>If {{run_mode}} in ["consult","auto"] AND {{target_story_id}} provided:
      - Locate that story entry; set consulted=true, consulted_at={{date}}, store story_title if provided.</action>
    <action>Update the Markdown checklist to reflect consulted status (use GitHub style `- [x]` / `- [ ]`). Include timestamp for the most recent consult and mention which story triggered the update.</action>
  </step>

  <step n="4" goal="Render XML + Markdown artifacts">
    <action>Prepare template data object with keys:
      metadata (epicId, title, generatedAt, updatedAt, sourceCount)
      doc_index (array of {path, sha256, mtime})
      docs (array of {path, section, snippet})
      constraints (array of strings)
      tests (standards string, locations array, shared_ideas array)
      dependencies (array of {ecosystem, packages[{name, version}]})
      code_baseline (array of {path, symbol, reason})
      coverage (array of {story_id, title, consulted, consulted_at})
    </action>
    <action>Fill {xml_template} with the data using template-output directives. Ensure:
      - All text is escaped for XML where necessary.
      - Dates use ISO 8601 format.
      - Consulted booleans render as "true"/"false".</action>
    <action>Fill {md_template} for the human summary. Include:
      - Epic header & synopsis (pull from epics.md)
      - Story coverage checklist (with consulted markers)
      - Condensed sections for Docs, Constraints, Testing, Dependencies, Code Baseline
      - Refresh status block referencing doc hash count and last update time.</action>
    <action>Write both files atomically (temp file → move) to avoid partial writes.</action>
  </step>

  <step n="5" goal="Validate, release lock, and summarize">
    <invoke-task>{validation}</invoke-task>
    <action>Delete {{lock_file}}.</action>
    <output>**Epic Context Updated**

- Epic: {{epic_id}}
- Mode: {{run_mode}}
- XML: {{xml_output}}
- Markdown summary: {{md_output}}
- Documents indexed: {{doc_index|length}}
- Stories consulted: {{count of coverage entries with consulted=true}} / {{coverage|length}}

Run `workflow epic-context` in interactive mode when you want to review the checklist manually or add additional story notes.</output>
  </step>

</workflow>
````
