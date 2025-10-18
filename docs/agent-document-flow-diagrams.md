---
title: BMAD Agent Document Flow Diagrams
version: 6.0-alpha
last-updated: 2025-01-XX
---

# BMAD Agent Document Flow Diagrams

This document provides visual representations of how agents interact and how documents flow through the BMAD system.

## Table of Contents

- [Complete Phase Flow](#complete-phase-flow)
- [Phase 1: Analysis Flow](#phase-1-analysis-flow)
- [Phase 2: Planning Flow](#phase-2-planning-flow)
- [Phase 3: Solutioning Flow](#phase-3-solutioning-flow)
- [Phase 4: Implementation Flow](#phase-4-implementation-flow)
- [Document Dependency Graph](#document-dependency-graph)
- [Agent Communication Patterns](#agent-communication-patterns)
- [Story State Machine](#story-state-machine)

---

## Complete Phase Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                         PHASE 0: ENTRY                              │
│                                                                     │
│  ANY AGENT → *workflow-status                                       │
│              ↓                                                      │
│         Check bmm-workflow-status.md                                │
│              ↓                                                      │
│         ┌────┴────┐                                                 │
│    [Exists?]   [New?]                                               │
│         ↓          ↓                                                │
│    Show Status   Guide Setup                                        │
└─────────┬──────────┬──────────────────────────────────────────────┘
          ↓          ↓
┌─────────────────────────────────────────────────────────────────────┐
│                      PHASE 1: ANALYSIS (Optional)                   │
│                                                                     │
│  Agents: Analyst, CIS Agents (Brainstorming, Innovation, etc.)     │
│                                                                     │
│  Workflows:                                                         │
│    • brainstorm-game / brainstorm-project                           │
│    • research (market/technical/deep)                               │
│    • game-brief / product-brief                                     │
│                                                                     │
│  Documents Produced:                                                │
│    ┌─────────────────────────────────────────┐                     │
│    │ • product-brief.md                       │                     │
│    │ • game-brief.md                          │                     │
│    │ • market-research.md                     │                     │
│    │ • Brainstorming artifacts                │                     │
│    └─────────────────────────────────────────┘                     │
└─────────────────────────┬───────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────────────┐
│                      PHASE 2: PLANNING (Required)                   │
│                                                                     │
│  Agent: PM (John)                                                   │
│                                                                     │
│  Workflow: *plan-project                                            │
│       ↓                                                             │
│  Scale Detection (Level 0-4)                                        │
│       ↓                                                             │
│  ┌────┴────┬────────┬────────┬────────┐                            │
│  ↓         ↓        ↓        ↓        ↓                            │
│ L0        L1       L2       L3       L4                             │
│                                                                     │
│  Documents Produced by Level:                                       │
│  ┌──────────────────────────────────────────────────────────┐      │
│  │ L0: tech-spec.md + story-{slug}.md                        │      │
│  │ L1: tech-spec.md + epic-stories.md + story-{slug}-N.md    │      │
│  │ L2: PRD.md + tech-spec.md + epics.md                      │      │
│  │ L3: PRD.md + epics.md                                     │      │
│  │ L4: PRD.md + epics.md (enterprise)                        │      │
│  │                                                           │      │
│  │ ALL: bmm-workflow-status.md (workflow tracking)           │      │
│  └──────────────────────────────────────────────────────────┘      │
│       ↓         ↓        ↓        ↓        ↓                        │
│  [L0/L1/L2 → Phase 4]   [L3/L4 → Phase 3]                           │
└─────────────────────────┬─────────┬─────────────────────────────────┘
                          ↓         ↓ (L3/L4 only)
                    (L0/L1/L2)      │
                          │    ┌────────────────────────────────────────┐
                          │    │  PHASE 3: SOLUTIONING (L3/L4 Only)     │
                          │    │                                        │
                          │    │  Agent: Architect (Winston)            │
                          │    │                                        │
                          │    │  Workflows:                            │
                          │    │    • *solution-architecture            │
                          │    │    • *tech-spec (JIT, per epic)        │
                          │    │                                        │
                          │    │  Documents Produced:                   │
                          │    │  ┌──────────────────────────────────┐ │
                          │    │  │ • solution-architecture.md       │ │
                          │    │  │   (overall system design + ADRs) │ │
                          │    │  │ • tech-spec-epic-N.md            │ │
                          │    │  │   (created JIT during Phase 4)   │ │
                          │    │  └──────────────────────────────────┘ │
                          │    └────────────┬───────────────────────────┘
                          │                 ↓
                          └─────────────────┴────────────────────┐
                                            ↓                    │
┌─────────────────────────────────────────────────────────────────────┐
│                  PHASE 4: IMPLEMENTATION (Iterative)                │
│                                                                     │
│  Agents: SM (Scrum Master), Dev (Amelia)                            │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────┐       │
│  │  STORY LIFECYCLE (see detailed diagram below)           │       │
│  │                                                          │       │
│  │  SM: create-story → story-{epic}.{story}.md             │       │
│  │      ↓                                                   │       │
│  │  User approves story                                     │       │
│  │      ↓                                                   │       │
│  │  SM: story-ready (TODO → IN PROGRESS)                    │       │
│  │      ↓                                                   │       │
│  │  SM: story-context → story-context-{epic}.{story}.xml    │       │
│  │      ↓                                                   │       │
│  │  Dev: dev-story (implements with context)                │       │
│  │      ↓                                                   │       │
│  │  User approves DoD                                       │       │
│  │      ↓                                                   │       │
│  │  Dev: story-approved (IN PROGRESS → DONE)                │       │
│  │      ↓                                                   │       │
│  │  [More stories? Loop back to create-story]               │       │
│  └─────────────────────────────────────────────────────────┘       │
│                                                                     │
│  Supporting Workflows:                                              │
│    • correct-course (course correction)                             │
│    • review-story (quality validation)                              │
│    • retrospective (epic learnings)                                 │
│                                                                     │
│  Documents Produced:                                                │
│  ┌──────────────────────────────────────────────────────┐          │
│  │ • story-{epic}.{story}.md (user stories)              │          │
│  │ • story-context-{epic}.{story}.xml (context injection)│          │
│  │ • Code implementation                                 │          │
│  │ • Test files and results                              │          │
│  │ • Updated bmm-workflow-status.md                      │          │
│  │ • Retrospective artifacts                             │          │
│  └──────────────────────────────────────────────────────┘          │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Phase 1: Analysis Flow

```
┌──────────────┐
│   Analyst    │
│      +       │
│  CIS Agents  │
└──────┬───────┘
       │
       ├──────────────────────────────────────────────┐
       │                                              │
       ↓                                              ↓
┌─────────────────┐                          ┌──────────────────┐
│  *brainstorm-*  │                          │    *research     │
│                 │                          │                  │
│ Methodologies:  │                          │ Types:           │
│ • Design Think  │                          │ • Market         │
│ • SCAMPER       │                          │ • Technical      │
│ • Mind Mapping  │                          │ • Deep Dive      │
│ • 6 Hats        │                          │                  │
│ • TRIZ          │                          │                  │
└────────┬────────┘                          └────────┬─────────┘
         │                                            │
         │ produces                                   │ produces
         ↓                                            ↓
    Concept                                    Research
    Proposals                                  Findings
         │                                            │
         └─────────────────┬──────────────────────────┘
                           ↓
                  ┌────────────────┐
                  │   *brief       │
                  │ (product/game) │
                  └────────┬───────┘
                           │ produces
                           ↓
              ┌────────────────────────────┐
              │   product-brief.md         │
              │   or game-brief.md         │
              │                            │
              │ Used by: PM in Phase 2     │
              └────────────────────────────┘
```

---

## Phase 2: Planning Flow

```
                        ┌─────────────────────────┐
                        │      PM (John)          │
                        │   *plan-project         │
                        └───────────┬─────────────┘
                                    │
                    ┌───────────────┴────────────────┐
                    │  Load Configuration & Inputs   │
                    │  • config.yaml                 │
                    │  • product-brief.md (optional) │
                    │  • market-research.md (opt)    │
                    └───────────────┬────────────────┘
                                    │
                    ┌───────────────┴────────────────┐
                    │   Scale Detection              │
                    │   Ask: Scope, Complexity,      │
                    │        Stories, Epics          │
                    └───────────────┬────────────────┘
                                    │
        ┌───────────┬───────────────┼───────────────┬───────────┐
        ↓           ↓               ↓               ↓           ↓
    Level 0     Level 1         Level 2         Level 3     Level 4
    ┌─────┐     ┌─────┐         ┌─────┐         ┌─────┐     ┌─────┐
    │Atom │     │Tiny │         │Small│         │Medium│    │Large│
    └──┬──┘     └──┬──┘         └──┬──┘         └──┬──┘     └──┬──┘
       │           │               │               │            │
       ↓           ↓               ↓               ↓            ↓
   tech-spec   tech-spec       PRD.md          PRD.md       PRD.md
       +           +          tech-spec       epics.md     epics.md
   story.md   epic-stories       +              (2-5)       (5+)
      (1)         +           epics.md
              story-N.md        (1-2)
                (2-3)
       │           │               │               │            │
       ├───────────┼───────────────┴───────────────┴────────────┤
       │                                                        │
       ↓                                                        ↓
   ALL LEVELS PRODUCE:                              PLUS FOR ALL:
   bmm-workflow-status.md                           • Populate BACKLOG
   (Workflow tracking file)                         • Set first story in TODO
       │                                                        │
       └───────────┬────────────────────────────────────────────┘
                   │
    ┌──────────────┴──────────────┐
    │                             │
    ↓ (Level 0-2)                 ↓ (Level 3-4)
To Phase 4                    To Phase 3
(Implementation)              (Solutioning)
```

### Scale Level Decision Matrix

```
┌────────┬─────────┬────────┬─────────────────────────┬──────────────┐
│ Level  │ Stories │ Epics  │ Key Documents           │ Next Phase   │
├────────┼─────────┼────────┼─────────────────────────┼──────────────┤
│   0    │    1    │   0    │ tech-spec + 1 story     │ Phase 4      │
├────────┼─────────┼────────┼─────────────────────────┼──────────────┤
│   1    │  1-10   │   1    │ tech-spec + epic-       │ Phase 4      │
│        │         │        │ stories + 2-3 stories   │              │
├────────┼─────────┼────────┼─────────────────────────┼──────────────┤
│   2    │  5-15   │  1-2   │ PRD + tech-spec +       │ Phase 4      │
│        │         │        │ epics                   │              │
├────────┼─────────┼────────┼─────────────────────────┼──────────────┤
│   3    │ 12-40   │  2-5   │ PRD + epics             │ Phase 3      │
├────────┼─────────┼────────┼─────────────────────────┼──────────────┤
│   4    │  40+    │   5+   │ PRD + epics (enterprise)│ Phase 3      │
└────────┴─────────┴────────┴─────────────────────────┴──────────────┘
```

---

## Phase 3: Solutioning Flow

```
┌──────────────────────────────────────────────────────────────┐
│                    Architect (Winston)                       │
└───────────────────────┬──────────────────────────────────────┘
                        │
        ┌───────────────┴───────────────┐
        │                               │
        ↓                               │
┌───────────────────┐                   │ (continues during Phase 4)
│ *solution-        │                   │
│  architecture     │                   │
│                   │                   │
│ Reads:            │                   │
│ • PRD.md          │                   │
│ • epics.md        │                   │
└─────────┬─────────┘                   │
          │                             │
          │ produces                    │
          ↓                             │
┌─────────────────────────────────┐     │
│ solution-architecture.md        │     │
│                                 │     │
│ Contains:                       │     │
│ • System architecture           │     │
│ • Component design              │     │
│ • ADRs (decisions)              │     │
│ • Data flow                     │     │
│ • Integration points            │     │
│                                 │     │
│ Consumed by:                    │     │
│ • Dev (Phase 4)                 │     │
│ • SM (context generation)       │     │
└─────────────────────────────────┘     │
          │                             │
          └─────────────────────────────┤
                                        ↓
                        ┌───────────────────────────────┐
                        │  During Phase 4 Implementation│
                        │  (Just-In-Time per Epic)      │
                        └───────────────┬───────────────┘
                                        │
                        ┌───────────────┴───────────────┐
                        │  When Epic N is ready:        │
                        │                               │
                        │  Architect: *tech-spec        │
                        │                               │
                        │  Reads:                       │
                        │  • PRD.md (Epic N section)    │
                        │  • solution-architecture.md   │
                        │  • epics.md (Epic N)          │
                        └───────────────┬───────────────┘
                                        │
                                        │ produces
                                        ↓
                        ┌──────────────────────────────────┐
                        │  tech-spec-epic-N.md             │
                        │                                  │
                        │  Contains:                       │
                        │  • Epic-specific architecture    │
                        │  • API contracts                 │
                        │  • Data models                   │
                        │  • Implementation guidance       │
                        │                                  │
                        │  Consumed by:                    │
                        │  • Dev (Epic N stories)          │
                        │  • SM (Epic N story context)     │
                        └──────────────────────────────────┘
                                        │
                                        ↓
                                  To Phase 4
                            (Epic N Implementation)
```

**Key Innovation**: Tech specs are created ONE AT A TIME as each epic is ready for implementation, not all at once upfront. This prevents over-engineering and incorporates learnings from previous epics.

---

## Phase 4: Implementation Flow

### Overall Implementation Loop

```
┌──────────────────────────────────────────────────────────────────┐
│                    bmm-workflow-status.md                        │
│                  (Single Source of Truth)                        │
│                                                                  │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌──────────┐  │
│  │  BACKLOG   │  │    TODO    │  │IN PROGRESS │  │   DONE   │  │
│  │            │  │            │  │            │  │          │  │
│  │ Story 3    │  │ Story 2    │  │ Story 1    │  │ Story 0  │  │
│  │ Story 4    │  │ (Draft)    │  │ (Ready)    │  │ (Done)   │  │
│  │ Story 5    │  │            │  │            │  │          │  │
│  │ ...        │  │            │  │            │  │          │  │
│  └────────────┘  └────────────┘  └────────────┘  └──────────┘  │
└──────────────────────────────────────────────────────────────────┘
         │              │                │                │
         │              ↓                ↓                ↑
         │      ┌───────────────┐ ┌─────────────┐       │
         │      │ SM:           │ │ Dev:        │       │
         │      │ create-story  │ │ dev-story   │       │
         │      └───────┬───────┘ └─────┬───────┘       │
         │              │               │               │
         │              ↓               ↓               │
         │      ┌───────────────┐ ┌─────────────┐       │
         │      │ User:         │ │ User:       │       │
         │      │ Reviews       │ │ Reviews DoD │       │
         │      └───────┬───────┘ └─────┬───────┘       │
         │              │               │               │
         │              ↓               ↓               │
         │      ┌───────────────┐ ┌─────────────┐       │
         │      │ SM:           │ │ Dev:        │       │
         │      │ story-ready   │ │ story-      │       │
         │      │               │ │ approved    │       │
         │      └───────┬───────┘ └─────┬───────┘       │
         │              │               │               │
         │              └───────┬───────┴───────────────┘
         │                      │
         │              ┌───────┴───────┐
         │              │ State Updates │
         │              │ • TODO → IN P │
         │              │ • IN P → DONE │
         │              │ • BACK → TODO │
         │              └───────┬───────┘
         │                      │
         └──────────────────────┘
                  (Loop continues)
```

### Detailed Story Workflow

```
START: Story in TODO section of bmm-workflow-status.md
│
├─► SM reads TODO section from status file
│   (No searching required - story explicitly declared)
│
├─► SM executes: *create-story workflow
│   │
│   ├─► Reads:
│   │   • bmm-workflow-status.md (TODO section)
│   │   • epics.md (story details)
│   │   • PRD.md (requirements context)
│   │   • tech-spec.md or tech-spec-epic-N.md (if exists)
│   │
│   ├─► Uses: template.md (story structure)
│   │
│   └─► Produces: story-{epic}.{story}.md
│       • Status: Draft
│       • Epic & Story IDs
│       • Title & Description
│       • Acceptance Criteria
│       • Tasks (empty - filled during implementation)
│       • Dev Agent Record (placeholder for context reference)
│
├─► User reviews story-{epic}.{story}.md
│   • Validates acceptance criteria
│   • Checks completeness
│   • Approves or requests changes
│
├─► SM executes: *story-ready workflow
│   │
│   ├─► Reads: TODO section
│   │
│   ├─► Updates story file: Status = "Ready"
│   │
│   └─► Updates bmm-workflow-status.md:
│       • TODO → IN PROGRESS
│       • Next story BACKLOG → TODO (if exists)
│
├─► SM executes: *story-context workflow (optional but recommended)
│   │
│   ├─► Reads:
│   │   • bmm-workflow-status.md (IN PROGRESS section)
│   │   • story-{epic}.{story}.md (story details)
│   │   • tech-spec.md or tech-spec-epic-N.md
│   │   • solution-architecture.md (if exists)
│   │   • Relevant code files (via glob/search)
│   │   • Relevant library docs
│   │
│   ├─► Uses: context-template.xml
│   │
│   ├─► Produces: story-context-{epic}.{story}.xml
│   │   ┌─────────────────────────────────────────────┐
│   │   │ <story-context>                             │
│   │   │   <story-meta>                              │
│   │   │     (Epic ID, Story ID, Title, etc.)        │
│   │   │   </story-meta>                             │
│   │   │   <technical-specification>                 │
│   │   │     (Relevant tech spec sections)           │
│   │   │   </technical-specification>                │
│   │   │   <architecture-guidance>                   │
│   │   │     (Architecture patterns, ADRs)           │
│   │   │   </architecture-guidance>                  │
│   │   │   <existing-code>                           │
│   │   │     (Related code files, interfaces)        │
│   │   │   </existing-code>                          │
│   │   │   <libraries>                               │
│   │   │     (Relevant library documentation)        │
│   │   │   </libraries>                              │
│   │   │ </story-context>                            │
│   │   └─────────────────────────────────────────────┘
│   │
│   └─► Updates story file: Dev Agent Record → Context Reference
│
├─► Dev (Amelia) executes: *develop workflow
│   │
│   ├─► CRITICAL: Checks story Status == "Ready" (MUST be approved)
│   │
│   ├─► Reads:
│   │   • bmm-workflow-status.md (IN PROGRESS section)
│   │   • story-{epic}.{story}.md (acceptance criteria)
│   │   • story-context-{epic}.{story}.xml (AUTHORITATIVE context)
│   │
│   ├─► Executes continuously (no pausing unless blocked):
│   │   ┌─────────────────────────────────────────┐
│   │   │ FOR each Acceptance Criterion:          │
│   │   │   FOR each Task:                        │
│   │   │     1. Implement code                   │
│   │   │     2. Write tests                      │
│   │   │     3. Run tests (MUST pass 100%)       │
│   │   │     4. Update task checkbox in story    │
│   │   │   NEXT Task                             │
│   │   │ NEXT Acceptance Criterion               │
│   │   └─────────────────────────────────────────┘
│   │
│   ├─► Produces:
│   │   • Code implementation
│   │   • Test files
│   │   • Test results (100% pass required)
│   │
│   └─► Updates story file:
│       • Tasks checked off
│       • Implementation notes
│       • Status: "In Review" (after all ACs complete)
│
├─► User reviews implementation
│   • Validates all acceptance criteria met
│   • Runs tests locally (if desired)
│   • Checks Definition of Done
│   • Approves or requests changes
│
├─► Dev executes: *story-approved workflow
│   │
│   ├─► Reads: IN PROGRESS section
│   │
│   ├─► Updates story file:
│   │   • Status = "Done"
│   │   • Completion date
│   │   • Story points (if tracked)
│   │
│   └─► Updates bmm-workflow-status.md:
│       • IN PROGRESS → DONE
│       • TODO → IN PROGRESS (if exists)
│       • BACKLOG → TODO (if exists)
│
└─► LOOP: If more stories exist, return to START
    Otherwise, epic complete → consider retrospective
```

### Supporting Workflows

```
┌────────────────────────────────────────────────────────┐
│                 correct-course                         │
│                                                        │
│  Used when: Issues arise, requirements change,        │
│             or course correction needed                │
│                                                        │
│  Agent: SM (sometimes PM)                              │
│                                                        │
│  Actions:                                              │
│  • Analyze situation                                   │
│  • Identify root cause                                 │
│  • Propose solutions                                   │
│  • Update affected stories                             │
│  • Update PRD/tech spec if needed                      │
└────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────┐
│                  review-story                          │
│                                                        │
│  Used when: Story flagged "Ready for Review"           │
│                                                        │
│  Agent: Dev or Senior Reviewer                         │
│                                                        │
│  Actions:                                              │
│  • Clean context review                                │
│  • Validate against acceptance criteria                │
│  • Check code quality                                  │
│  • Verify tests                                        │
│  • Append review notes to story file                   │
└────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────┐
│                 retrospective                          │
│                                                        │
│  Used when: Epic complete, or at sprint boundaries     │
│                                                        │
│  Agent: SM (with *party-mode for full team simulation) │
│                                                        │
│  Actions:                                              │
│  • Review completed epic                               │
│  • Identify what went well                             │
│  • Identify what could improve                         │
│  • Capture learnings                                   │
│  • Update future epic approach                         │
└────────────────────────────────────────────────────────┘
```

---

## Document Dependency Graph

```
                    ┌─────────────────────┐
                    │   config.yaml       │
                    │   (System Config)   │
                    └──────────┬──────────┘
                               │
                    ┌──────────┴──────────┐
                    │  ALL AGENTS LOAD    │
                    └─────────────────────┘


        PHASE 1                     PHASE 2                     PHASE 3
┌────────────────────┐    ┌──────────────────────┐    ┌──────────────────────┐
│ product-brief.md   │───→│     PRD.md           │───→│ solution-            │
│                    │    │                      │    │  architecture.md     │
│ game-brief.md      │───→│     GDD.md           │    └──────────┬───────────┘
│                    │    │                      │               │
│ market-research.md │───→│     epics.md         │               │
└────────────────────┘    │                      │               ↓
                          │  tech-spec.md (L0-2) │    ┌──────────────────────┐
                          │                      │    │ tech-spec-epic-N.md  │
                          │  bmm-workflow-       │    │ (created JIT)        │
                          │   status.md          │    └──────────┬───────────┘
                          └──────────┬───────────┘               │
                                     │                           │
                        ┌────────────┴───────────────────────────┘
                        │
                        ↓
        ┌───────────────────────────────────────────────────┐
        │              PHASE 4                              │
        │                                                   │
        │  bmm-workflow-status.md (Story State Machine)     │
        │       ↓                                           │
        │  story-{epic}.{story}.md ←───────┐               │
        │       ↓                           │               │
        │  story-context-{epic}.{story}.xml │               │
        │       ↓                           │               │
        │  Code Implementation              │               │
        │  Test Files                       │               │
        │       ↓                           │               │
        │  Updated bmm-workflow-status.md ──┘               │
        └───────────────────────────────────────────────────┘


Document Consumers Legend:
┌─────────────┐
│  Document   │ ─→  Consumed by Agent/Workflow
└─────────────┘
```

---

## Agent Communication Patterns

### Pattern 1: Document Handoff

```
Agent A                    Document                    Agent B
  │                           │                           │
  ├─► Execute Workflow        │                           │
  │                           │                           │
  ├─► Produce Document ──────►│                           │
  │   (writes to file)        │                           │
  │                           │                           │
  ├─► Update Status File      │                           │
  │   (signals completion)    │                           │
  │                           │                           │
  └─► Exit                    │   ◄──── Read Document ────┤
                              │                           │
                              │   ◄──── Load Context ─────┤
                              │                           │
                              └───────────────────────────┤
                                                          │
                                          Execute Next Workflow
```

### Pattern 2: Shared State File

```
Multiple Agents Access Single Source of Truth:

┌──────────────────────────────────────────────────────────┐
│            bmm-workflow-status.md                        │
│         (Workflow State Machine)                         │
└──────────────────────────────────────────────────────────┘
         ↑                    ↑                    ↑
         │                    │                    │
    Read │               Read │               Read │
         │                    │                    │
    ┌────┴────┐          ┌────┴────┐          ┌────┴────┐
    │   SM    │          │   Dev   │          │   PM    │
    │ (create)│          │  (impl) │          │(status) │
    └────┬────┘          └────┬────┘          └────┬────┘
         │                    │                    │
    Write│               Write│               Read │
         │                    │                Only│
         ↓                    ↓                    ↓
┌──────────────────────────────────────────────────────────┐
│            bmm-workflow-status.md                        │
│         (Updated State)                                  │
└──────────────────────────────────────────────────────────┘

Key: Agents coordinate through shared state file
     No direct agent-to-agent communication needed
```

### Pattern 3: Context Injection

```
Story Context Generation (SM):

┌─────────────────────────────────────────────────────────┐
│  SM: story-context workflow                             │
│                                                          │
│  Gathers from multiple sources:                         │
│  ┌──────────────────────────────────────────────────┐   │
│  │ • tech-spec.md or tech-spec-epic-N.md            │   │
│  │ • solution-architecture.md                       │   │
│  │ • Relevant code files (via glob)                 │   │
│  │ • Library documentation                          │   │
│  │ • Story acceptance criteria                      │   │
│  └──────────────────────────────────────────────────┘   │
│                                                          │
│  Assembles into XML:                                    │
│  ┌──────────────────────────────────────────────────┐   │
│  │ <story-context>                                  │   │
│  │   <technical-specification>...</...>             │   │
│  │   <architecture-guidance>...</...>               │   │
│  │   <existing-code>...</...>                       │   │
│  │   <libraries>...</...>                           │   │
│  │ </story-context>                                 │   │
│  └──────────────────────────────────────────────────┘   │
│                                                          │
│  Produces: story-context-{epic}.{story}.xml              │
└─────────────────────────────────────────────────────────┘
                          │
                          │ Consumed by
                          ↓
┌─────────────────────────────────────────────────────────┐
│  Dev: dev-story workflow                                │
│                                                          │
│  Loads context as AUTHORITATIVE:                        │
│  • Treats as single source of truth                     │
│  • Overrides model priors                               │
│  • Reduces hallucination                                │
│  • Ensures consistency with existing code               │
└─────────────────────────────────────────────────────────┘
```

### Pattern 4: Party Mode Simulation

```
┌──────────────────────────────────────────────────────────┐
│            BMad Master / Orchestrator                    │
│              *party-mode command                         │
└────────────────────────┬─────────────────────────────────┘
                         │
         ┌───────────────┴───────────────┐
         │  Load all agent personas      │
         │  from agent-party.xml or      │
         │  individual agent files       │
         └───────────────┬───────────────┘
                         │
         ┌───────────────┴───────────────────────┐
         │ Simulate multi-agent conversation:    │
         │                                       │
         │ [📋] John (PM): "Let's discuss..."    │
         │ [🏗️] Winston (Arch): "I suggest..."   │
         │ [💻] Amelia (Dev): "I can implement..." │
         │ [📊] Analyst: "Based on research..."  │
         │                                       │
         │ Each agent:                           │
         │ • Has distinct voice                  │
         │ • Contributes based on expertise      │
         │ • References their domain knowledge   │
         └───────────────────────────────────────┘
```

---

## Story State Machine

Detailed state transitions for Phase 4 stories:

```
┌─────────────────────────────────────────────────────────────────┐
│                     STORY STATE MACHINE                         │
│                 (Tracked in bmm-workflow-status.md)             │
└─────────────────────────────────────────────────────────────────┘

    [BACKLOG]
    Story exists in ordered list
    File: Does not exist yet
    Status: N/A
         │
         │ (Automatic on phase transition or story approval)
         ↓
    [TODO]
    Single story ready for drafting
    File: Does not exist yet
    Status: N/A
         │
         │ SM executes: *create-story
         ↓
    [TODO]
    Story drafted, awaiting approval
    File: story-{epic}.{story}.md exists
    Status: "Draft"
         │
         │ User reviews and approves
         │ SM executes: *story-ready
         ↓
    [IN PROGRESS]
    Story approved for development
    File: story-{epic}.{story}.md
    Status: "Ready"
         │
         │ (Optional) SM executes: *story-context
         │ Produces: story-context-{epic}.{story}.xml
         ↓
    [IN PROGRESS]
    Story being implemented
    File: story-{epic}.{story}.md
    Context: story-context-{epic}.{story}.xml
    Status: "Ready" → "In Review"
         │
         │ Dev executes: *develop
         │ Implements all ACs and tasks
         │ Runs all tests (100% pass)
         ↓
    [IN PROGRESS]
    Implementation complete, awaiting final approval
    File: story-{epic}.{story}.md
    Status: "In Review"
         │
         │ User reviews DoD
         │ Dev executes: *story-approved
         ↓
    [DONE]
    Story complete
    File: story-{epic}.{story}.md
    Status: "Done"
    Metadata: Completion date, points

    │
    │ (Automatic state transitions)
    │ • Next TODO → IN PROGRESS
    │ • Next BACKLOG → TODO
    ↓
[Loop to next story or epic complete]
```

### State Transition Rules

```
┌─────────────────────────────────────────────────────────────┐
│ Transition            │ Workflow       │ Side Effects       │
├───────────────────────┼────────────────┼────────────────────┤
│ BACKLOG → TODO        │ story-ready or │ Moves next story   │
│                       │ story-approved │ into drafting queue│
├───────────────────────┼────────────────┼────────────────────┤
│ TODO (no file) →      │ create-story   │ Creates story file │
│ TODO (Draft)          │                │ Status: "Draft"    │
├───────────────────────┼────────────────┼────────────────────┤
│ TODO → IN PROGRESS    │ story-ready    │ Story Status:      │
│                       │                │ "Ready"            │
│                       │                │ Next BACKLOG→TODO  │
├───────────────────────┼────────────────┼────────────────────┤
│ IN PROGRESS →         │ story-approved │ Story Status:      │
│ DONE                  │                │ "Done"             │
│                       │                │ Next TODO→IN PROG  │
│                       │                │ Next BACKLOG→TODO  │
└─────────────────────────────────────────────────────────────┘
```

---

## Summary

This document provides visual representations of:

1. **Complete Phase Flow**: How all four phases connect from analysis to implementation
2. **Phase-Specific Flows**: Detailed workflows for each phase
3. **Document Dependencies**: What documents are produced and consumed by whom
4. **Agent Communication**: How agents coordinate through documents
5. **Story State Machine**: The lifecycle of a story through implementation

### Key Takeaways

- **Document-Driven**: All agent communication happens through structured documents
- **State Machine**: Story progression is deterministic and trackable
- **No Search Required**: State files explicitly declare what to work on next
- **Scale-Adaptive**: Workflows adjust based on project complexity (Level 0-4)
- **Just-In-Time**: Architecture and tech specs created as needed, not upfront
- **Human-in-the-Loop**: Critical approval gates ensure quality and alignment

---

## Related Documentation

- **[Agent Architecture Overview](./agent-architecture-overview.md)** - Detailed agent roles and responsibilities
- **[BMM Workflows Guide](../src/modules/bmm/workflows/README.md)** - Complete v6 workflow documentation
- **[Main README](../README.md)** - Project overview and installation

---

*This document is part of the BMAD-CORE v6-alpha release. For questions or contributions, join our [Discord Community](https://discord.gg/gk8jAdXWmj).*