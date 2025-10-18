---
title: BMAD Agent Workflow Cheat Sheet
version: 6.0-alpha
last-updated: 2025-01-XX
---

# BMAD Agent Workflow Cheat Sheet

Quick reference for common workflows and commands in the BMAD system.

## Universal Commands

### Start Here (Any Agent)

```bash
bmad <agent-name> workflow-status
# or in chat: *workflow-status
```

**What it does**: Shows current phase, progress, and recommends next action

**Available in**: bmad-master, analyst, pm, architect, dev, sm

---

## Phase 1: Analysis (Optional)

### Starting a New Project

**Agent**: `analyst`

```bash
bmad analyst brainstorm-project
# or: bmad analyst brainstorm-game (for games)
```

**Produces**: Concept proposals using multiple methodologies

### Conducting Research

**Agent**: `analyst`

```bash
bmad analyst research
```

**Types**:
- Market research
- Technical research
- Deep dive analysis

**Produces**: Research findings and insights

### Creating Project Brief

**Agent**: `analyst`

```bash
bmad analyst product-brief
# or: bmad analyst game-brief (for games)
```

**Produces**: Strategic product/game brief document

**Next Step**: Phase 2 Planning

---

## Phase 2: Planning (Required)

### Plan Your Project

**Agent**: `pm` (John)

```bash
bmad pm plan-project
# or in chat: *plan-project
```

**What happens**:
1. Asks about project scope and complexity
2. Detects scale level (0-4)
3. Routes to appropriate sub-workflow
4. Generates scale-appropriate documents

**Produces**:
- **Level 0**: `tech-spec.md` + `story-{slug}.md`
- **Level 1**: `tech-spec.md` + `epic-stories.md` + 2-3 story files
- **Level 2**: `PRD.md` + `tech-spec.md` + `epics.md`
- **Level 3-4**: `PRD.md` + `epics.md`
- **All Levels**: `bmm-workflow-status.md`

**Next Step**:
- Level 0-2 → Phase 4 (Implementation)
- Level 3-4 → Phase 3 (Solutioning)

### Validate Planning Documents

**Agent**: `pm`

```bash
bmad pm validate
# or in chat: *validate
```

**What it does**: Validates documents against workflow checklists

---

## Phase 3: Solutioning (Levels 3-4 Only)

### Create System Architecture

**Agent**: `architect` (Winston)

```bash
bmad architect solution-architecture
# or in chat: *solution-architecture
```

**Produces**: `solution-architecture.md` with:
- System architecture overview
- Component design
- Architecture Decision Records (ADRs)
- Data flow diagrams
- Integration points

**Do this**: Once per project, before implementation

### Create Epic-Specific Tech Spec (JIT)

**Agent**: `architect`

```bash
bmad architect tech-spec
# or in chat: *tech-spec
```

**Produces**: `tech-spec-epic-N.md` for current epic

**Do this**: One epic at a time, just before implementing that epic

**Key Innovation**: Don't create all tech specs upfront—create as needed during Phase 4

### Validate Architecture

**Agent**: `architect`

```bash
bmad architect validate-architecture
# or: bmad architect validate-tech-spec
```

---

## Phase 4: Implementation (Iterative)

### The Story Workflow Loop

#### 1. Create Story (Draft)

**Agent**: `sm` (Scrum Master)

```bash
bmad sm create-story
# or in chat: *create-story
```

**Reads**: 
- `bmm-workflow-status.md` (TODO section)
- `epics.md`
- `PRD.md`

**Produces**: `story-{epic}.{story}.md` with Status: "Draft"

**Next**: User reviews and approves the story

---

#### 2. Approve Story (Ready for Development)

**Agent**: `sm`

```bash
bmad sm story-ready
# or in chat: *story-ready
```

**What it does**:
- Updates story Status: "Ready"
- Moves story: TODO → IN PROGRESS
- Moves next story: BACKLOG → TODO

**Next**: (Optional but recommended) Generate story context

---

#### 3. Generate Story Context (Optional but Recommended)

**Agent**: `sm`

```bash
bmad sm story-context
# or in chat: *story-context
```

**Produces**: `story-context-{epic}.{story}.xml` containing:
- Technical specifications
- Architecture guidance
- Relevant existing code
- Library documentation

**Purpose**: Provides authoritative context to Dev agent, reducing hallucinations

---

#### 4. Implement Story

**Agent**: `dev` (Amelia)

```bash
bmad dev develop
# or in chat: *develop
```

**Reads**:
- `bmm-workflow-status.md` (IN PROGRESS section)
- `story-{epic}.{story}.md` (acceptance criteria)
- `story-context-{epic}.{story}.xml` (authoritative context)

**What it does**:
- Implements all acceptance criteria
- Writes tests for each AC
- Runs ALL tests (must achieve 100% pass)
- Updates task checkboxes in story file
- Updates Status: "In Review"

**Executes continuously**: No pausing unless blocked

**Next**: User reviews implementation and DoD

---

#### 5. Complete Story

**Agent**: `dev`

```bash
bmad dev story-approved
# or in chat: *story-approved
```

**What it does**:
- Updates story Status: "Done"
- Adds completion date and points
- Moves story: IN PROGRESS → DONE
- Moves next story: TODO → IN PROGRESS
- Moves next story: BACKLOG → TODO

**Next**: Loop back to step 1 for next story, or epic complete

---

### Supporting Workflows

#### Course Correction

**Agent**: `sm` or `pm`

```bash
bmad sm correct-course
# or in chat: *correct-course
```

**When to use**:
- Requirements change
- Issues arise during implementation
- Need to adjust approach

**What it does**:
- Analyzes situation
- Proposes solutions
- Updates affected stories/documents

---

#### Review Story

**Agent**: `dev` or senior reviewer

```bash
bmad dev review
# or in chat: *review
```

**When to use**: Story flagged "Ready for Review"

**What it does**:
- Clean context review
- Validates against ACs
- Checks code quality
- Verifies tests
- Appends review notes to story

---

#### Retrospective

**Agent**: `sm`

```bash
bmad sm retrospective
# or in chat: *retrospective
```

**When to use**: Epic complete, or sprint boundaries

**What it does**:
- Reviews completed epic
- Identifies successes and improvements
- Captures learnings
- Informs future epic approach

**Pro Tip**: Use with `*party-mode` for full team simulation!

---

## Special Commands

### Party Mode (Multi-Agent Simulation)

**Agent**: `bmad-master`

```bash
bmad bmad-master party-mode
# or in chat: *party-mode
```

**What it does**:
- Simulates conversation with ALL installed agents
- Each agent has distinct voice and expertise
- Great for retrospectives, design discussions, complex problems

**Format**: `[emoji] Name: message`

**Exit**: Type `*exit-party`

---

### List All Tasks

**Agent**: `bmad-master`

```bash
bmad bmad-master list-tasks
# or in chat: *list-tasks
```

**Shows**: All available tasks from `task-manifest.csv`

---

### List All Workflows

**Agent**: `bmad-master`

```bash
bmad bmad-master list-workflows
# or in chat: *list-workflows
```

**Shows**: All available workflows from `workflow-manifest.csv`

---

## BMad Builder Commands

### Create New Agent

**Agent**: `bmad-builder`

```bash
bmad bmad-builder create-agent
# or in chat: *create-agent
```

**Creates**: New agent definition (`.agent.yaml`)

**Types**:
- Standalone agent
- Module agent
- Expert agent (with sidecar resources)

---

### Create New Workflow

**Agent**: `bmad-builder`

```bash
bmad bmad-builder create-workflow
# or in chat: *create-workflow
```

**Creates**: Complete workflow structure:
- `workflow.yaml` (config)
- `instructions.md` (logic)
- `template.md` (output)
- `checklist.md` (validation)

---

### Create Complete Module

**Agent**: `bmad-builder`

```bash
bmad bmad-builder create-module
# or in chat: *create-module
```

**Creates**: Full module with agents and workflows

---

### Convert Legacy Agent

**Agent**: `bmad-builder`

```bash
bmad bmad-builder convert
# or in chat: *convert
```

**Converts**: v4 or other style agents to v6 format

---

### Update Module Documentation

**Agent**: `bmad-builder`

```bash
bmad bmad-builder redoc
# or in chat: *redoc
```

**Updates**: Module README and documentation

---

## Common Workflows by Scenario

### Scenario: Brand New Small Feature (Level 0-1)

```
1. bmad pm workflow-status          # Check status
2. bmad pm plan-project             # Create tech-spec + stories
   → Detects Level 0 or 1
   → Skips to Phase 4
3. bmad sm story-context            # Generate context (if Level 1)
4. bmad dev develop                 # Implement
5. bmad dev story-approved          # Mark done
```

---

### Scenario: New Medium Project (Level 2-3)

```
1. bmad analyst product-brief       # (Optional) Create brief
2. bmad pm workflow-status          # Check status
3. bmad pm plan-project             # Create PRD + epics
   → Detects Level 2 or 3
   
   If Level 2 (skip to step 6)
   If Level 3:
   
4. bmad architect solution-architecture  # Create architecture
5. bmad architect tech-spec         # Create tech spec for Epic 1 (JIT)

6. bmad sm create-story             # Draft first story
7. [User reviews story]
8. bmad sm story-ready              # Approve for dev
9. bmad sm story-context            # Generate context
10. bmad dev develop                # Implement
11. [User reviews DoD]
12. bmad dev story-approved         # Mark done
13. Loop back to step 6 for next story
```

---

### Scenario: Large Enterprise Project (Level 4)

```
1. bmad analyst brainstorm-project  # Explore concepts
2. bmad analyst research            # Conduct research
3. bmad analyst product-brief       # Create strategic brief
4. bmad pm workflow-status          # Check status
5. bmad pm plan-project             # Create enterprise PRD + epics
   → Detects Level 4
6. bmad architect solution-architecture  # Create full architecture
7. [For each epic, during implementation:]
   a. bmad architect tech-spec      # Create epic-specific tech spec (JIT)
   b. bmad sm create-story          # Draft stories
   c. bmad sm story-ready           # Approve stories
   d. bmad sm story-context         # Generate context
   e. bmad dev develop              # Implement
   f. bmad dev story-approved       # Complete stories
   g. bmad sm retrospective         # Epic retrospective
8. Loop step 7 for all epics
```

---

### Scenario: Course Correction Mid-Project

```
1. bmad pm workflow-status          # Assess current state
2. bmad sm correct-course           # Analyze and propose solutions
3. [Update affected documents]
4. bmad pm validate                 # Validate changes
5. Continue implementation
```

---

## File Locations Quick Reference

### Configuration
- `{project-root}/bmad/core/config.yaml` - System config
- `{project-root}/bmad/_cfg/agents/*.customize.yaml` - Agent customizations

### Planning Documents (typically in `{output_folder}`)
- `PRD.md` - Product Requirements Document
- `epics.md` - Epic breakdown
- `tech-spec.md` - Technical specification
- `solution-architecture.md` - System architecture
- `GDD.md` - Game Design Document

### Tracking
- `bmm-workflow-status.md` - Workflow state and story backlog

### Stories (typically in `{story_dir}`)
- `story-{epic}.{story}.md` - User story
- `story-context-{epic}.{story}.xml` - Story context

---

## Status File Structure (Quick Ref)

```markdown
## Story Backlog Management

### BACKLOG
- [ ] Epic 1, Story 3: Feature X (story-1.3.md)
- [ ] Epic 1, Story 4: Feature Y (story-1.4.md)

### TODO
- [ ] Epic 1, Story 2: Feature Z (story-1.2.md)
      Status: Draft (awaiting user approval)

### IN PROGRESS
- [x] Epic 1, Story 1: Setup (story-1.1.md)
      Status: Ready (assigned to Dev)

### DONE
- [x] Epic 1, Story 0: Init (story-1.0.md)
      Completed: 2025-01-15, Points: 3
```

---

## Story Status Values

| Status | Meaning | State File Location |
|--------|---------|---------------------|
| **Draft** | Story created, awaiting user review | TODO |
| **Ready** | User approved, ready for dev | IN PROGRESS |
| **In Review** | Implementation complete, awaiting final approval | IN PROGRESS |
| **Done** | DoD complete, user approved | DONE |

---

## Tips & Tricks

### Always Start with Status
Every work session should begin with `*workflow-status` to understand where you are.

### Respect the Scale
Don't create a full PRD and architecture for a 1-story change. Trust the scale detection.

### Use Story Context
While optional, `story-context` dramatically improves Dev agent accuracy and reduces hallucinations.

### Party Mode for Complex Decisions
Use `*party-mode` to simulate multi-agent discussions for retrospectives or complex problems.

### Customize Your Agents
Edit `bmad/_cfg/agents/*.customize.yaml` to change agent names, personalities, and language.

### JIT Over Upfront
For Level 3-4 projects, create tech specs one epic at a time during Phase 4, not all in Phase 3.

### Human Gates Are Critical
Always review stories before approval and verify DoD before marking complete.

---

## Troubleshooting

### "I don't know what to do next"
→ Run `*workflow-status` - it will tell you exactly what to do

### "Agent can't find the right story"
→ Check `bmm-workflow-status.md` - stories are explicitly declared there

### "Implementation is hallucinating"
→ Run `*story-context` before `*develop` to provide authoritative context

### "Project scope changed"
→ Run `*correct-course` to analyze and adjust

### "Need to review architecture"
→ Run `*validate-architecture` or `*validate-tech-spec`

---

## Additional Resources

- **[Agent Architecture Overview](./agent-architecture-overview.md)** - Detailed agent guide
- **[Agent Document Flow Diagrams](./agent-document-flow-diagrams.md)** - Visual workflows
- **[BMM Workflows README](../src/modules/bmm/workflows/README.md)** - Complete workflow guide
- **[Main README](../README.md)** - Installation and overview

---

*Quick reference for BMAD-CORE v6-alpha. For detailed information, see the full documentation.*