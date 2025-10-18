---
title: BMAD Documentation Index
version: 6.0-alpha
last-updated: 2025-01-XX
---

# BMAD Documentation

Welcome to the BMAD-CORE documentation. This directory contains comprehensive guides, architecture overviews, and technical references for the BMAD system.

## Core Documentation

### Agent System Documentation

#### [Agent Architecture Overview](./agent-architecture-overview.md)
**Comprehensive guide to the BMAD agent system**

This document provides detailed information about:
- System architecture and core principles
- All core and module-specific agents (roles, responsibilities, documents)
- Document flow through the four phases
- Agent interaction patterns and communication
- Workflow orchestration and state management
- Customization and extension capabilities

**Start here** if you want to understand how agents work, what documents they produce/consume, and how they interact with each other.

---

#### [Agent Document Flow Diagrams](./agent-document-flow-diagrams.md)
**Visual representations of agent interactions and document flows**

This document includes:
- Complete phase flow diagrams (Phases 1-4)
- Phase-specific workflow visualizations
- Document dependency graphs
- Agent communication patterns
- Story state machine diagrams
- State transition rules

**Start here** if you prefer visual learning and want to see how information flows through the system.

---

#### ⚠️ [Multi-Project Setup Guide](./multi-project-setup-guide.md) 🔴 CRITICAL
**Essential reading for users working with multiple BMAD projects**

This guide covers:
- How different IDEs store agents (per-project vs. global)
- The cross-project contamination issue and how it happens
- Complete prevention strategies
- Emergency fix scripts
- Diagnostic commands for troubleshooting

**Read this if:**
- ❗ You work on multiple projects with BMAD
- ❗ You use Codex or GitHub Copilot (global IDEs)
- ❗ Agents show wrong project name or data
- ❗ You're switching between projects frequently

---

## Quick Reference

### The Four Phases of BMAD Method (BMM)

```
Phase 1: Analysis (Optional)
  ├─ Agents: Analyst, CIS Agents
  ├─ Outputs: product-brief.md, market-research.md
  └─ Purpose: Discovery and requirements gathering

Phase 2: Planning (Required)
  ├─ Agent: PM (John)
  ├─ Outputs: PRD.md, epics.md, tech-spec.md, bmm-workflow-status.md
  ├─ Scale: Level 0-4 (adaptive)
  └─ Purpose: Project scope and requirements definition

Phase 3: Solutioning (Levels 3-4 only)
  ├─ Agent: Architect (Winston)
  ├─ Outputs: solution-architecture.md, tech-spec-epic-N.md (JIT)
  └─ Purpose: System architecture and technical design

Phase 4: Implementation (Iterative)
  ├─ Agents: SM (Scrum Master), Dev (Amelia)
  ├─ Outputs: story files, story context XML, code, tests
  └─ Purpose: Iterative story implementation
```

### Key Agents

| Agent | Icon | Role | Phase | Key Commands |
|-------|------|------|-------|--------------|
| **BMad Master** | 🧙 | Master Orchestrator | All | `*list-tasks`, `*list-workflows`, `*party-mode` |
| **PM (John)** | 📋 | Product Manager | 1-2 | `*workflow-status`, `*plan-project` |
| **Architect (Winston)** | 🏗️ | System Architect | 3 | `*solution-architecture`, `*tech-spec` |
| **Dev (Amelia)** | 💻 | Developer | 4 | `*develop`, `*story-approved` |
| **SM** | 📊 | Scrum Master | 4 | `*create-story`, `*story-ready`, `*story-context` |
| **Analyst** | 🔍 | Business Analyst | 1 | `*workflow-status`, analysis workflows |
| **BMad Builder** | 🧙 | Agent/Workflow Builder | N/A | `*create-agent`, `*create-workflow`, `*create-module` |

### Key Documents

| Document | Producer | Purpose | Consumers |
|----------|----------|---------|-----------|
| `bmm-workflow-status.md` | PM (Phase 2) | Workflow state tracking & story backlog | All agents |
| `PRD.md` | PM | Product requirements | Architect, SM, Dev |
| `epics.md` | PM | Epic/story breakdown | Architect, SM |
| `tech-spec.md` | PM or Architect | Technical specification | Dev, SM |
| `solution-architecture.md` | Architect | System architecture + ADRs | Dev, SM |
| `story-{epic}.{story}.md` | SM | User story with ACs | Dev |
| `story-context-{epic}.{story}.xml` | SM | Context injection for dev | Dev |

### Universal Entry Point

**Always start with**: `*workflow-status`

This command:
- ✅ Checks current workflow state
- ✅ Shows phase and progress
- ✅ Recommends next action
- ✅ Routes to appropriate workflows
- ✅ Handles new vs. existing projects

Available from: `bmad-master`, `analyst`, `pm`, `architect`, `dev`

---

## Additional Resources

### Technical Documentation

- **[Codebase Flattener](./codebase-flattener.md)** - Tool for analyzing codebases
- **[Technical Decisions Template](./technical-decisions-template.md)** - ADR template
- **[Recompiling Agents Guide](./recompiling-agents-guide.md)** - How to rebuild agents after modifications
- **[Multi-Project Setup Guide](./multi-project-setup-guide.md)** - ⚠️ CRITICAL: Preventing cross-project issues

### IDE & Installer Information

- **[IDE Info](./ide-info/)** - IDE-specific configurations
- **[Installers & Bundlers](./installers-bundlers/)** - Installation and bundling tools

### Module Documentation

- **[BMM (BMad Method) README](../src/modules/bmm/README.md)** - Software development module
- **[BMM Workflows Guide](../src/modules/bmm/workflows/README.md)** - **CRITICAL**: Complete v6 workflow documentation
- **[BMB (BMad Builder) README](../src/modules/bmb/README.md)** - Agent and workflow builder module
- **[CIS (Creative Intelligence Suite)](../src/modules/cis/)** - Innovation and ideation module

### Project Information

- **[Main README](../README.md)** - Project overview, installation, and getting started
- **[v6 Open Items](../v6-open-items.md)** - Current development roadmap
- **[Contributing Guidelines](../CONTRIBUTING.md)** - How to contribute
- **[Changelog](../CHANGELOG.md)** - Version history

---

## Key Concepts

### Scale-Adaptive Workflows

BMAD v6 introduces scale-adaptive workflows that automatically adjust based on project complexity:

- **Level 0**: Single atomic change (1 story + tech spec)
- **Level 1**: Tiny project (2-3 stories, 1 epic, tech spec)
- **Level 2**: Small project (5-15 stories, 1-2 epics, PRD + tech spec)
- **Level 3**: Medium project (12-40 stories, 2-5 epics, PRD + architecture)
- **Level 4**: Large/enterprise project (40+ stories, 5+ epics, full architecture)

### Just-In-Time Design

Architecture and technical specifications are created as needed during implementation:

1. **Phase 3**: Create overall system architecture only
2. **During Phase 4**: Create epic-specific tech specs one at a time
3. **Benefit**: Incorporate learnings, avoid over-engineering

### Story State Machine

Phase 4 stories progress through a deterministic state machine:

```
BACKLOG → TODO → IN PROGRESS → DONE
```

- **BACKLOG**: Ordered list of stories to be drafted
- **TODO**: Single story ready for drafting (or awaiting approval)
- **IN PROGRESS**: Single story approved for development
- **DONE**: Completed stories with dates and points

**Innovation**: Agents never search for stories—the `bmm-workflow-status.md` explicitly declares what to work on next.

### Story Context Injection

Dynamic expertise injection per story that:

- Assembles relevant code artifacts
- Includes technical specifications
- Provides architectural guidance
- Reduces AI hallucination through authoritative context
- Ensures consistency with existing code

### Human-in-the-Loop

Critical approval gates ensure quality:

1. **Story Approval**: User reviews drafted stories before implementation
2. **DoD Verification**: User confirms Definition of Done before story completion
3. **Course Corrections**: PM/SM can adjust when issues arise

---

## Best Practices

### For Users

1. **Always start with `*workflow-status`** to understand where you are
2. **Respect the scale** - Don't over-engineer small projects
3. **Trust the process** - Follow phase progression
4. **Review at gates** - Approve stories and DoD carefully
5. **Customize agents** - Use `bmad/_cfg/agents/` to personalize
6. **Recompile after changes** - Run `npx bmad-method build --all` after modifying agents
7. **Rebuild global IDEs** - When switching projects, rebuild Codex/Copilot agents (see Multi-Project Guide)

### For Developers

1. **Load at runtime** - Never pre-load resources
2. **Document-driven** - Communicate through structured documents
3. **State tracking** - Use status files for coordination
4. **Atomic steps** - Break complex workflows into manageable pieces
5. **Validate outputs** - Include checklists for quality assurance

### For Agent Design

1. **Human amplification** - Guide and facilitate, don't replace
2. **Present choices** - Always use numbered lists
3. **Just-in-time** - Create artifacts when needed
4. **Clear handoffs** - Define explicit producer-consumer relationships
5. **Explicit state** - Always indicate document status

---

## Getting Help

- **[Discord Community](https://discord.gg/gk8jAdXWmj)** - Join our active community for help and discussion
- **[YouTube Channel](https://www.youtube.com/@BMadCode)** - Video tutorials and demonstrations
- **[GitHub Issues](https://github.com/bmad-code-org/BMAD-METHOD/issues)** - Report bugs or request features
- **[Documentation](https://github.com/bmad-code-org/BMAD-METHOD)** - Browse source and docs

---

## Version Information

- **BMAD-CORE Version**: 6.0-alpha
- **Documentation Last Updated**: 2025-01-XX
- **Status**: Alpha (subject to change)

**Note**: v6-alpha is under active development. Features may change, and updates are frequent. Always pull latest changes and reinstall node_modules when updating.

---

## License

BMAD-CORE is released under the MIT License. See [LICENSE](../LICENSE) for details.

---

*"Human Amplification, Not Replacement"* - The BMAD Philosophy