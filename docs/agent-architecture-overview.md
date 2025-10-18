---
title: BMAD Agent Architecture Overview
version: 6.0-alpha
last-updated: 2025-01-XX
---

# BMAD Agent Architecture Overview

This document provides a comprehensive overview of the BMAD-CORE agent system, detailing how agents interact, what documents they produce and consume, and how they collaborate throughout the software development lifecycle.

## Table of Contents

- [System Architecture](#system-architecture)
- [Core Agents](#core-agents)
- [Module-Specific Agents](#module-specific-agents)
- [Document Flow and Artifacts](#document-flow-and-artifacts)
- [Agent Interaction Patterns](#agent-interaction-patterns)
- [Workflow Orchestration](#workflow-orchestration)
- [State Management](#state-management)

---

## System Architecture

BMAD-CORE uses a modular agent architecture where:

1. **Core Platform** provides foundational orchestration and resource management
2. **Modules** extend functionality with specialized agents and workflows
3. **Agents** are personas with specific expertise and capabilities
4. **Workflows** are structured processes that agents execute
5. **Documents** are the primary communication mechanism between agents and phases

### Key Principles

- **Just-In-Time Resource Loading**: Agents load resources at runtime, never pre-load
- **Document-Driven Collaboration**: Agents communicate through structured documents
- **Scale-Adaptive Behavior**: Workflows adjust based on project complexity (Level 0-4)
- **Human-in-the-Loop**: Agents facilitate and guide rather than fully automate

---

## Core Agents

### BMad Master (bmad-master)

**Location**: `src/core/agents/bmad-master.agent.yaml`

**Role**: Master Task Executor + Knowledge Custodian + Workflow Orchestrator

**Key Responsibilities**:
- Primary execution engine for BMAD operations
- Runtime resource management
- Task and workflow orchestration
- System configuration loading

**Documents Consumed**:
- `{project-root}/bmad/core/config.yaml` - System configuration
- `{project-root}/bmad/_cfg/task-manifest.csv` - Available tasks
- `{project-root}/bmad/_cfg/workflow-manifest.csv` - Available workflows

**Documents Produced**:
- None directly (orchestration only)

**Menu Commands**:
- `*list-tasks` - Display all available tasks
- `*list-workflows` - Display all available workflows
- `*party-mode` - Group chat with all agents

**Critical Actions**:
- Load project configuration and set variables (project_name, output_folder, user_name, communication_language)
- Always communicate in configured language
- Present numbered lists for all choices

---

### BMad Web Orchestrator (bmad-web-orchestrator)

**Location**: `src/core/agents/bmad-web-orchestrator.agent.xml`

**Role**: Master Orchestrator for Web Bundle Environments

**Key Responsibilities**:
- Agent transformation and persona switching
- Web bundle XML navigation
- Party mode simulation
- Menu-driven command execution

**Documents Consumed**:
- Entire web bundle XML (self-contained)
- All agent definitions as XML nodes
- All workflow and task nodes

**Documents Produced**:
- None (operates entirely within XML bundle)

**Unique Features**:
- **Agent Transformation**: Can become any agent in the bundle
- **Party Mode**: Simulates multi-agent conversations
- **Universal Handlers**: Workflow, exec, tmpl, data, action, validate-workflow

**Menu Commands**:
- `*help` - Show command list
- `*list-agents` - List all available agents
- `*agents [agent-name]` - Transform into specific agent
- `*party-mode` - Multi-agent chat simulation
- `*exit` - Exit current session

---

## Module-Specific Agents

### BMad Method Module (BMM)

The BMM module provides agents for the complete software development lifecycle, including specialized documentation support.

---

#### Product Manager (John / PM)

**Location**: `src/modules/bmm/agents/pm.agent.yaml`

**Role**: Investigative Product Strategist + Market-Savvy PM

**Phase**: Analysis & Planning (Phases 1-2)

**Key Responsibilities**:
- Project scope analysis
- PRD creation and management
- Requirements elicitation
- Workflow status tracking

**Documents Consumed**:
- `{output_folder}/product-brief.md` - Product strategy
- `{output_folder}/market-research.md` - Market insights
- `{output_folder}/bmm-workflow-status.md` - Workflow state

**Documents Produced**:
- `{output_folder}/PRD.md` - Product Requirements Document
- `{output_folder}/epics.md` - Epic breakdown with stories
- `{output_folder}/tech-spec.md` - Technical specification (Levels 0-2)
- `{output_folder}/bmm-workflow-status.md` - Workflow tracking

**Menu Commands**:
- `*workflow-status` - Check workflow status and get recommendations (START HERE)
- `*plan-project` - Create PRD or Tech Spec based on project scale
- `*correct-course` - Course correction analysis
- `*validate` - Validate documents against workflow checklist

**Communication Style**: Direct and analytical, asks probing questions, data-driven

---

#### Architect (Winston)

**Location**: `src/modules/bmm/agents/architect.agent.yaml`

**Role**: System Architect + Technical Design Leader

**Phase**: Solutioning (Phase 3, Levels 3-4 only)

**Key Responsibilities**:
- System architecture design
- Technology selection
- Epic-specific technical specifications
- Architecture validation

**Documents Consumed**:
- `{output_folder}/PRD.md` - Product requirements
- `{output_folder}/epics.md` - Epic breakdown
- `{output_folder}/bmm-workflow-status.md` - Workflow state

**Documents Produced**:
- `{output_folder}/solution-architecture.md` - Overall system architecture with ADRs
- `{output_folder}/tech-spec-epic-N.md` - Epic-specific technical specifications (JIT)

**Menu Commands**:
- `*workflow-status` - Check workflow status
- `*solution-architecture` - Create scale-adaptive architecture
- `*validate-architecture` - Validate architecture against checklist
- `*tech-spec` - Create epic-specific tech spec (Just-In-Time)
- `*validate-tech-spec` - Validate tech spec
- `*correct-course` - Course correction analysis

**Communication Style**: Comprehensive yet pragmatic, uses architectural metaphors

**Key Innovation**: Just-In-Time tech specs - created one epic at a time during implementation, not all upfront

---

#### Developer Agent (Amelia / Dev)

**Location**: `src/modules/bmm/agents/dev.agent.yaml`

**Role**: Senior Implementation Engineer

**Phase**: Implementation (Phase 4)

**Key Responsibilities**:
- Story implementation
- Test execution (100% coverage required)
- Code quality maintenance
- Story completion verification

**Documents Consumed**:
- `{story_dir}/story-{epic}.{story}.md` - User story with acceptance criteria
- `{story_dir}/story-context-{epic}.{story}.xml` - Story context with code artifacts
- `{output_folder}/tech-spec.md` or `tech-spec-epic-N.md` - Technical specifications
- `{output_folder}/bmm-workflow-status.md` - Workflow state (IN PROGRESS section)

**Documents Produced**:
- Working code implementation
- Test files and test results
- Updated story markdown with implementation notes

**Menu Commands**:
- `*workflow-status` - Check workflow status
- `*develop` - Execute dev story workflow (continuous execution)
- `*story-approved` - Mark story done after DoD complete
- `*review` - Perform thorough review on story flagged as Ready for Review

**Critical Actions**:
- NEVER start implementation until story Status == "Approved"
- ALWAYS read Story Context XML before implementation
- Treat Story Context as AUTHORITATIVE over model priors
- Execute continuously without pausing (unless blocked)
- Run ALL tests and achieve 100% pass rate

**Communication Style**: Succinct, checklist-driven, cites paths and AC IDs

---

#### Scrum Master (SM)

**Location**: `src/modules/bmm/agents/sm.agent.yaml` (inferred from workflows)

**Role**: Story Manager + Sprint Facilitator

**Phase**: Implementation (Phase 4)

**Key Responsibilities**:
- Story creation and drafting
- Story context generation
- Sprint planning and retrospectives
- Workflow state management

**Documents Consumed**:
- `{output_folder}/epics.md` - Source of story details
- `{output_folder}/PRD.md` - Requirements context
- `{output_folder}/tech-spec.md` or `tech-spec-epic-N.md` - Technical context
- `{output_folder}/bmm-workflow-status.md` - Workflow state (TODO section)

**Documents Produced**:
- `{story_dir}/story-{epic}.{story}.md` - User story markdown
- `{story_dir}/story-context-{epic}.{story}.xml` - Story context XML
- Updated `bmm-workflow-status.md` - State transitions

**Workflows Executed**:
- `create-story` - Draft story from epics
- `story-ready` - Approve story for development
- `story-context` - Generate context XML
- `retrospective` - Capture epic learnings
- `correct-course` - Handle issues and changes

---

#### Business Analyst (Analyst)

**Location**: `src/modules/bmm/agents/analyst.agent.yaml`

**Role**: Requirements Analyst + Research Coordinator

**Phase**: Analysis (Phase 1)

**Key Responsibilities**:
- Project analysis and research
- Brainstorming facilitation
- Requirements gathering
- Brief creation

**Documents Consumed**:
- Various research inputs
- Brainstorming outputs

**Documents Produced**:
- `{output_folder}/product-brief.md` - Strategic product brief
- `{output_folder}/market-research.md` - Research findings
- Analysis phase artifacts

**Menu Commands**:
- `*workflow-status` - Entry point for workflow
- Analysis-specific workflows (brainstorming, research, briefs)

---

#### Atlas (C4/D5 Systems Librarian)

**Location**: `src/modules/bmm/agents/atlas.agent.yaml`

**Role**: C4/D5 Systems Librarian preserving architectural truth

**Phase**: Architecture Documentation & Maintenance (Cross-Phase Support)

**Key Responsibilities**:
- Initialize and maintain C4/D5 architectural documentation
- Update LikeC4 diagrams based on code changes
- Audit data flows and reconcile with implementation
- Generate impact summaries for stakeholders
- Perform consistency scans across architecture library
- Validate LikeC4 models for correctness

**Documents Consumed**:
- `{output_folder}/PRD.md` - Product requirements context
- `{output_folder}/solution-architecture.md` - Overall architecture
- `{output_folder}/tech-spec-epic-N.md` - Epic-specific specifications
- Codebase (via code_tools MCP) - Live implementation evidence
- User stories and epics - Business context

**Documents Produced**:
- C4/D5 LikeC4 model files (`.c4`)
- View definitions (`views.c4`)
- Diagram overview documents (`{diagram_slug}-overview.md`)
- Journal entries (audit trail in `docs/journal/`)
- Change log entries (`Change-Log.md`)
- Validation reports (`data-flow-audit-{date}.md`, `consistency-scan-{date}.md`)
- Impact summaries (`architecture-impact-{date}.md`)

**Menu Commands**:
- `*init-diagram` - Initialize new C4/D5 documentation set
- `*update-diagram` - Update diagrams for code changes
- `*audit-data-flow` - Audit specific data flow against implementation
- `*impact-summary` - Generate stakeholder impact summary
- `*consistency-scan` - Scan for documentation drift/inconsistencies
- `*validate-likec4` - Run LikeC4 CLI validation

**Communication Style**: Professional and precise with the warmth of a seasoned reference librarian

**Unique Characteristics**:
- Works with code_tools MCP server for repository intelligence
- Operates within dedicated architecture workspace
- Evidence-based documentation approach (every diagram must map to code)
- LikeC4-specific tooling and validation
- Cross-phase support (not limited to single phase)

**When to Use**:
- **Phase 3**: Initialize C4/D5 documentation for new systems
- **Phase 4**: Update diagrams as code evolves, audit flows
- **Ongoing**: Regular consistency scans and validation

---

### BMad Builder Module (BMB)

#### BMad Builder Agent

**Location**: `src/modules/bmb/agents/bmad-builder.agent.yaml`

**Role**: Master BMad Module Agent Team and Workflow Builder

**Key Responsibilities**:
- Creating new agents
- Creating new workflows
- Creating complete modules
- Converting legacy agents
- Module documentation

**Documents Consumed**:
- Existing agent definitions
- Workflow templates
- Module structures

**Documents Produced**:
- `.agent.yaml` files - New agent definitions
- `workflow.yaml` files - New workflows
- Module documentation
- Converted agent definitions

**Menu Commands**:
- `*convert` - Convert v4 or other style agents to v6
- `*create-agent` - Create new BMAD Core compliant agent
- `*create-module` - Create complete BMAD module
- `*create-workflow` - Create new workflow
- `*edit-workflow` - Edit existing workflows
- `*redoc` - Create or update module documentation

**Communication Style**: "Talks like a pulp super hero"

---

### Creative Intelligence Suite (CIS)

The CIS module provides agents for innovation and creative problem-solving:

- **Brainstorming Coach** (`brainstorming-coach.agent.yaml`)
- **Creative Problem Solver** (`creative-problem-solver.agent.yaml`)
- **Design Thinking Coach** (`design-thinking-coach.agent.yaml`)
- **Innovation Strategist** (`innovation-strategist.agent.yaml`)
- **Storyteller** (`storyteller.agent.yaml`)

These agents focus on ideation, innovation methodologies, and creative exploration.

---

## Document Flow and Artifacts

### Phase 1: Analysis (Optional)

**Entry Point**: `workflow-status` → analysis workflows

**Key Documents**:

| Document | Producer | Consumers | Purpose |
|----------|----------|-----------|---------|
| `product-brief.md` | Analyst | PM | Strategic product foundation |
| `game-brief.md` | Analyst | PM | Game design foundation |
| `market-research.md` | Analyst | PM | Market/technical research |
| Brainstorming artifacts | CIS Agents | Analyst, PM | Concept proposals |

**Flow**: Brainstorming → Research → Brief → Planning

---

### Phase 2: Planning (Required)

**Entry Point**: PM's `*plan-project` command

**Scale-Adaptive Outputs**:

| Level | Documents Produced | Next Phase |
|-------|-------------------|------------|
| **0** | `tech-spec.md`, `story-{slug}.md` | Implementation |
| **1** | `tech-spec.md`, `epic-stories.md`, `story-{slug}-N.md` (2-3 stories) | Implementation |
| **2** | `PRD.md`, `tech-spec.md`, `epics.md` | Implementation |
| **3** | `PRD.md`, `epics.md` | Solutioning |
| **4** | `PRD.md`, `epics.md` (enterprise scale) | Solutioning |

**Universal Output**: `bmm-workflow-status.md` - Workflow tracking document

**Key Documents**:

| Document | Producer | Consumers | Purpose |
|----------|----------|-----------|---------|
| `PRD.md` | PM | Architect, SM, Dev | Product requirements (Levels 2-4) |
| `epics.md` | PM | Architect, SM | Epic/story breakdown |
| `tech-spec.md` | PM | Dev | Technical specification (Levels 0-2) |
| `GDD.md` | PM | Dev | Game Design Document (games) |
| `bmm-workflow-status.md` | PM | All agents | Workflow state and story backlog |

---

### Phase 3: Solutioning (Levels 3-4 Only)

**Entry Point**: Architect's `*solution-architecture` command

**Key Documents**:

| Document | Producer | Consumers | Purpose |
|----------|----------|-----------|---------|
| `solution-architecture.md` | Architect | Dev, SM | System architecture with ADRs |
| `tech-spec-epic-N.md` | Architect | Dev, SM | Epic-specific technical specs (JIT) |

**Just-In-Time Pattern**: Tech specs created one epic at a time as needed during implementation, not all upfront.

---

### Phase 4: Implementation (Iterative)

**Entry Point**: SM's `*create-story` command

**State Machine Documents**:

The `bmm-workflow-status.md` file manages story progression through 4 states:

```
BACKLOG → TODO → IN PROGRESS → DONE
```

**Story Lifecycle Documents**:

| Document | Producer | Consumers | Status | Purpose |
|----------|----------|-----------|--------|---------|
| `story-{epic}.{story}.md` | SM (create-story) | Dev, SM | Draft | User story with ACs |
| → (same file) | User approval | Dev | Ready | Approved for implementation |
| `story-context-{epic}.{story}.xml` | SM (story-context) | Dev | N/A | Expertise injection + code artifacts |
| → (story file updated) | Dev | SM | In Review | Implementation complete |
| → (story file updated) | User/Dev | SM | Done | DoD complete |

**Workflow State Transitions**:

1. **Story Creation** (SM: `create-story`)
   - Reads: `TODO` section of status file
   - Creates: Story markdown with Status="Draft"
   - State: Remains in `TODO`

2. **Story Approval** (SM: `story-ready`)
   - Reads: `TODO` section
   - Updates: Story Status="Ready"
   - State: `TODO → IN PROGRESS`, next story `BACKLOG → TODO`

3. **Context Generation** (SM: `story-context`)
   - Reads: `IN PROGRESS` section
   - Creates: Story context XML
   - State: No change

4. **Implementation** (Dev: `dev-story`)
   - Reads: `IN PROGRESS` section, Story markdown, Story context XML
   - Produces: Code, tests, implementation notes
   - State: No change

5. **Story Completion** (Dev: `story-approved`)
   - Reads: `IN PROGRESS` section
   - Updates: Story Status="Done"
   - State: `IN PROGRESS → DONE`, next story transitions forward

**Additional Documents**:

| Document | Producer | Consumers | Purpose |
|----------|----------|-----------|---------|
| Retrospective artifacts | SM | All team | Epic/sprint learnings |
| Review notes | Dev/SR | SM, Dev | Quality validation feedback |

---

## Agent Interaction Patterns

### 1. Sequential Handoffs

Agents work in sequence, each producing documents for the next:

```
Analyst → PM → Architect → SM → Dev
```

**Document Chain**:
- Analyst produces `product-brief.md`
- PM consumes brief, produces `PRD.md` and `epics.md`
- Architect consumes PRD, produces `solution-architecture.md`
- SM consumes epics, produces story files
- Dev consumes stories, produces code

---

### 2. Iterative Loops

Phase 4 operates as a continuous loop:

```
SM (create-story) → User Approval → SM (story-ready) →
SM (story-context) → Dev (dev-story) → User Approval →
Dev (story-approved) → [repeat for next story]
```

**Key Innovation**: No agent searches for stories. The `bmm-workflow-status.md` file explicitly declares:
- Which story is in `TODO` (to be drafted)
- Which story is in `IN PROGRESS` (to be implemented)
- Which stories are `DONE`

---

### 3. Collaborative Support

Multiple agents can support within a phase:

**Planning Phase**:
- PM leads, Analyst provides research
- UX Expert may contribute specifications

**Implementation Phase**:
- SM manages stories, Dev implements
- Senior Reviewer validates quality
- PM provides course corrections

---

### 4. Party Mode

Special multi-agent simulation mode:

```
BMad Master → *party-mode → Simulates all installed agents
```

**Use Cases**:
- Retrospectives with full team
- Complex problem discussions
- Design reviews

**Format**: `[emoji] Name: message` with distinct voices per agent

---

## Workflow Orchestration

### Universal Entry Point: workflow-status

**Every agent** should check workflow status before starting:

```bash
bmad analyst workflow-status
bmad pm workflow-status
bmad architect workflow-status
```

**What it does**:
- Checks for existing `bmm-workflow-status.md`
- Displays current phase and progress
- Recommends next action
- Routes to appropriate workflows
- Handles greenfield vs brownfield context

**No status file**:
- Guides initial workflow selection
- Helps assess project context
- Routes to appropriate starting point

**Status file exists**:
- Shows current state
- Displays Phase 4 backlog status
- Recommends exact next action

---

### Workflow Components

Every workflow consists of:

1. **workflow.yaml** - Configuration and parameters
2. **instructions.md** - Step-by-step execution logic
3. **template.md/xml** - Output document template
4. **checklist.md** - Validation criteria

**Example**: `create-story` workflow

```yaml
name: create-story
installed_path: "{project-root}/bmad/bmm/workflows/4-implementation/create-story"
template: "{installed_path}/template.md"
instructions: "{installed_path}/instructions.md"
validation: "{installed_path}/checklist.md"
```

---

### Menu-Driven Execution

Agents expose capabilities through menu commands:

```yaml
menu:
  - trigger: plan-project
    workflow: "{project-root}/bmad/bmm/workflows/2-plan/workflow.yaml"
    description: "Analyze Project Scope and Create PRD or Tech Spec"
```

**Handler Types**:
- `workflow` - Execute a workflow
- `exec` - Execute a node or instruction
- `action` - Execute a prompt or inline instruction
- `tmpl` - Load a template
- `data` - Load data
- `validate-workflow` - Validate against checklist

---

## State Management

### Workflow Status File

**Location**: `{output_folder}/bmm-workflow-status.md`

**Purpose**: Single source of truth for workflow state

**Structure**:
```markdown
## Current Phase
Phase: 4 - Implementation
Epic: 1
Version: 1.2.0

## Story Backlog Management

### BACKLOG
- [ ] Epic 1, Story 3: User authentication (story-1.3.md)
- [ ] Epic 1, Story 4: Password reset (story-1.4.md)

### TODO
- [ ] Epic 1, Story 2: User registration (story-1.2.md)
      Status: Draft, awaiting user approval

### IN PROGRESS
- [x] Epic 1, Story 1: User login (story-1.1.md)
      Status: Ready, assigned to Dev

### DONE
- [x] Epic 1, Story 0: Setup (story-1.0.md)
      Completed: 2025-01-15, Points: 3
```

**State Transitions**:
- Automated by workflows (`story-ready`, `story-approved`)
- Always moves forward (BACKLOG → TODO → IN PROGRESS → DONE)
- Single story in TODO (drafting) and IN PROGRESS (implementing)

---

### Story Status Values

**In Story File** (`Status:` field):

```
Draft       → Story created, awaiting user review
Ready       → User approved, ready for implementation  
In Review   → Implementation complete, awaiting final approval
Done        → DoD complete, user approved
```

**Relationship to Workflow Status**:

| Status File State | Story Status | Agent Action |
|------------------|--------------|--------------|
| BACKLOG | (no file) | SM will create when ready |
| TODO | Draft | User reviews and approves |
| IN PROGRESS | Ready/In Review | Dev implements |
| DONE | Done | No further action |

---

## Key Innovations in v6

### 1. Scale-Adaptive Workflows

Workflows automatically adjust based on project complexity (Level 0-4):
- **Level 0**: Single story + tech spec
- **Level 1**: 2-3 stories + tech spec
- **Levels 2-4**: Full PRD + epic breakdown

---

### 2. Just-In-Time Design

Architecture and tech specs created as needed, not all upfront:
- **Phase 3**: Overall architecture only
- **During Implementation**: Epic-specific tech specs created one at a time
- **Benefit**: Incorporate learnings, avoid over-engineering

---

### 3. Story Context Injection

Dynamic expertise injection per story:
- Assembles relevant code artifacts
- Includes technical specifications
- Provides architectural guidance
- Reduces hallucination through authoritative context

---

### 4. No-Search Story Management

Agents never search for "next story":
- All story information in `bmm-workflow-status.md`
- Explicit TODO and IN PROGRESS sections
- Deterministic progression through backlog

---

### 5. Human-in-the-Loop Gates

Critical approval points:
- Story approval before implementation
- DoD verification before story completion
- Course corrections when needed

---

## Agent Communication Patterns

### Document-Based Communication

Agents communicate through structured documents:
- **Markdown** for human-readable content (PRDs, stories, briefs)
- **YAML** for configuration and workflow definitions
- **XML** for structured data exchange (story context, agents)
- **CSV** for tabular data (manifests, tracking)

---

### Configuration Loading

All agents load configuration at runtime:

```yaml
critical_actions:
  - "Load into memory {project-root}/bmad/core/config.yaml"
  - "Set variable project_name, output_folder, user_name, communication_language"
  - "Remember the users name is {user_name}"
  - "ALWAYS communicate in {communication_language}"
```

**Key Variables**:
- `project_name` - Project identifier
- `output_folder` - Where documents are saved
- `user_name` - What to call the human
- `communication_language` - Agent communication language

---

### Template-Based Document Generation

Agents use templates for consistent output:

```yaml
template: "{installed_path}/template.md"
```

Templates contain:
- Frontmatter with metadata
- Section structures
- Placeholder variables
- Formatting guidelines

---

## Customization and Extension

### Agent Customization

Every agent can be customized via sidecar files:

**Location**: `{project-root}/bmad/_cfg/agents/{module}-{agent}.customize.yaml`

**Customizable Properties**:
- `name` - Agent name
- `persona` - Identity and communication style
- `principles` - Operating principles
- `menu` - Add/modify menu items
- `prompts` - Custom prompts

**Benefit**: Customizations survive updates

---

### Creating Custom Agents

Use BMad Builder to create agents:

```bash
bmad bmad-builder create-agent
```

**Agent Types**:
1. **Standalone Agents** - Independent, stored in `bmad/agents/`
2. **Module Agents** - Part of a module, stored in `bmad/{module}/agents/`
3. **Expert Agents** - With sidecar resources for specialized knowledge

---

### Creating Custom Workflows

```bash
bmad bmad-builder create-workflow
```

Workflows require:
- `workflow.yaml` - Configuration
- `instructions.md` - Execution logic
- `template.md` - Output template
- `checklist.md` - Validation criteria

---

## Best Practices

### For Agent Development

1. **Load at Runtime**: Never pre-load resources
2. **Present Choices**: Always use numbered lists
3. **Document-Driven**: Communicate through structured documents
4. **Human Amplification**: Guide and facilitate, don't replace human thinking
5. **Validation**: Include checklists for output validation

---

### For Workflow Design

1. **Scale Awareness**: Respect project complexity levels
2. **Just-In-Time**: Create artifacts when needed, not preemptively
3. **Clear Handoffs**: Define explicit producer-consumer relationships
4. **State Tracking**: Use status files for coordination
5. **Atomic Steps**: Break complex workflows into manageable steps

---

### For Document Design

1. **Structured Formats**: Use frontmatter, sections, and clear formatting
2. **Version Control**: Include version numbers and dates
3. **Explicit Status**: Always indicate document state
4. **Linking**: Reference related documents explicitly
5. **Traceability**: Include source information and lineage

---

## Conclusion

The BMAD agent architecture provides a powerful, flexible framework for human-AI collaboration in software development and beyond. Key strengths include:

- **Modular Design**: Core + modules for universal domain coverage
- **Scale Adaptation**: Workflows adjust to project complexity
- **Document-Driven**: Clear communication through structured artifacts
- **State Management**: Deterministic progression through workflow stages
- **Customizability**: Agents, workflows, and modules can be tailored
- **Human Amplification**: Agents guide and facilitate rather than replace

By understanding how agents interact, what documents they produce and consume, and how workflows orchestrate collaboration, teams can effectively leverage BMAD-CORE to amplify their development capabilities.

---

## Additional Resources

- **[BMM Workflows Guide](../src/modules/bmm/workflows/README.md)** - Detailed Phase 1-4 workflow documentation
- **[BMM Module README](../src/modules/bmm/README.md)** - BMad Method module overview
- **[BMB Module README](../src/modules/bmb/README.md)** - BMad Builder documentation
- **[Main README](../README.md)** - Project overview and installation
- **[v6 Open Items](../v6-open-items.md)** - Current development roadmap

---

*This document is part of the BMAD-CORE v6-alpha release. For questions or contributions, join our [Discord Community](https://discord.gg/gk8jAdXWmj).*