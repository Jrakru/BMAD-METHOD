# Story Context Assembly Workflow

## Overview

Assembles a dynamic Story Context XML by pulling latest documentation and existing code/library artifacts relevant to a drafted story. Creates comprehensive development context for AI agents and developers working on specific stories.

## Key Features

- **Epic Spine Reuse** – Loads the per-epic context once (docs, constraints, tests, deps) and blocks if it is stale
- **Automated Context Discovery** – Adds story-specific documentation, code touchpoints, and constraints
- **XML Output Format** – Structured context optimized for LLM consumption
- **Dependency Detection** – Identifies frameworks, packages, and technical dependencies
- **Interface Mapping** – Locates existing APIs and interfaces to reuse
- **Testing Integration** – Includes shared testing standards and generates story-specific test ideas
- **Status Tracking** – Updates story status and maintains context references

## Usage

### Basic Invocation

```bash
workflow story-context
```

### With Specific Story

```bash
# Process specific story file
workflow story-context --input /path/to/story.md

# Using story path variable
workflow story-context --story_path "docs/stories/1.2.feature-name.md"
```

### Configuration

- **story_path**: Path to target story markdown file (defaults to latest.md)
- **auto_update_status**: Whether to automatically update story status (default: false)

## Workflow Structure

### Files Included

```
story-context/
├── workflow.yaml           # Configuration and metadata
├── instructions.md         # Step-by-step execution guide
├── context-template.xml    # XML structure template
├── checklist.md           # Validation criteria
└── README.md              # This file
```

## Workflow Process

### Phase 1: Story Analysis (Steps 1-2)

- **Story Location**: Finds and loads target story markdown file
- **Content Parsing**: Extracts epic ID, story ID, title, acceptance criteria, and tasks
- **Template Initialization**: Creates initial XML context structure
- **User Story Extraction**: Parses "As a... I want... So that..." components

### Phase 2: Epic Spine Verification (Step 3)

- **Epic Context Load**: Ensures `epic-context-{epic}.xml` exists; auto-builds if missing
- **Staleness Check**: Re-hashes source docs and blocks until the spine is refreshed
- **Coverage Update**: Marks the current story as consulted in the epic checklist
- **Shared Data Seed**: Captures shared docs, constraints, testing standards, dependencies, and code baselines for reuse

### Phase 3: Story-Specific Discovery (Steps 4-7)

- **Documentation Append**: Adds story-unique doc snippets on top of the shared references
- **Code & Interfaces**: Identifies specific modules, functions, and APIs to touch while reusing shared baselines
- **Dependency Merge**: Extends package/tooling list only with story-required additions
- **Testing Enrichment**: Augments shared standards with AC-specific test ideas and locations

### Phase 4: Validation and Updates (Steps 8-9)

- **XML Validation**: Ensures structure and checklist compliance
- **Story Updates**: Changes status to `ContextReadyDraft` and appends context reference
- **Workflow Status**: Updates `bmm-workflow-status.md` (when present) with context completion details

## Output

### Generated Files

- **Primary output**: story-context-{epic_id}.{story_id}-{date}.xml
- **Story updates**: Modified original story file with context references

### Output Structure

```xml
<storyContext>
  <story>
    <basicInfo>
      <epicId>...</epicId>
      <storyId>...</storyId>
      <title>...</title>
      <status>...</status>
    </basicInfo>
    <userStory>
      <asA>...</asA>
      <iWant>...</iWant>
      <soThat>...</soThat>
    </userStory>
    <acceptanceCriteria>
      <criterion id="1">...</criterion>
    </acceptanceCriteria>
    <tasks>
      <task>...</task>
    </tasks>
  </story>

  <artifacts>
    <docs>
      <doc path="..." title="..." section="..." snippet="..."/>
    </docs>
    <code>
      <file path="..." kind="..." symbol="..." lines="..." reason="..."/>
    </code>
    <dependencies>
      <node>
        <package name="..." version="..."/>
      </node>
    </dependencies>
  </artifacts>

  <interfaces>
    <interface name="..." kind="..." signature="..." path="..."/>
  </interfaces>

  <constraints>
    <constraint>...</constraint>
  </constraints>

  <tests>
    <standards>...</standards>
    <locations>
      <location>...</location>
    </locations>
    <ideas>
      <idea ac="1">...</idea>
    </ideas>
  </tests>
</storyContext>
```

## Requirements

- **Story File**: Valid story markdown with proper structure (epic.story.title.md format)
- **Repository Access**: Ability to scan documentation and source code
- **Documentation**: Project documentation in standard locations (docs/, src/, etc.)

## Best Practices

### Before Starting

1. **Ensure Story Quality**: Verify story has clear acceptance criteria and tasks
2. **Update Documentation**: Ensure relevant docs are current and discoverable
3. **Clean Repository**: Remove obsolete code that might confuse context assembly

### During Execution

1. **Review Extracted Context**: Verify that discovered artifacts are actually relevant
2. **Check Interface Accuracy**: Ensure identified APIs and interfaces are current
3. **Validate Dependencies**: Confirm dependency information matches project state

### After Completion

1. **Review XML Output**: Validate the generated context makes sense
2. **Test with Developer**: Have a developer review context usefulness
3. **Update Story Status**: Verify story status was properly updated

## Troubleshooting

### Common Issues

**Issue**: Context contains irrelevant or outdated information

- **Solution**: Review keyword extraction and document filtering logic
- **Check**: Ensure story title and acceptance criteria are specific and clear

**Issue**: Missing relevant code or interfaces

- **Solution**: Verify code search patterns and symbol extraction
- **Check**: Ensure relevant code follows project naming conventions

**Issue**: Dependency information is incomplete or wrong

- **Solution**: Check for multiple package manifests or unusual project structure
- **Check**: Verify dependency files are in expected locations and formats

## Customization

To customize this workflow:

1. **Modify Search Patterns**: Update instructions.md to adjust code and doc discovery
2. **Extend XML Schema**: Customize context-template.xml for additional context types
3. **Add Validation**: Extend checklist.md with project-specific quality criteria
4. **Configure Dependencies**: Adjust dependency detection for specific tech stacks

## Version History

- **v6.0.0** - XML-based context assembly with comprehensive artifact discovery
  - Multi-ecosystem dependency detection
  - Interface and constraint extraction
  - Testing context integration
  - Story status management

## Support

For issues or questions:

- Review the workflow creation guide at `/bmad/bmb/workflows/create-workflow/workflow-creation-guide.md`
- Validate output using `checklist.md`
- Ensure story files follow expected markdown structure
- Check that repository structure supports automated discovery

---

_Part of the BMad Method v6 - BMM (Method) Module_
