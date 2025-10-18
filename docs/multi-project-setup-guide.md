---
title: Multi-Project Setup Guide - Preventing Cross-Project Contamination
version: 6.0-alpha
date: 2025-01-XX
status: Critical Reference
---

# Multi-Project Setup Guide

## Problem Recap: The Cross-Project Contamination Issue

### What Happened

While working on the **DeepAgents** project, all BMAD agents were incorrectly showing data from a different project (**wanELF**):

```
• 📊 Current Workflow Status
  Project: wanELF  ❌ (Expected: DeepAgents)
  Started: 2025-10-16
  ...
```

The Dev agent, when invoked in DeepAgents, was reading wanELF's configuration and workflow status files.

### Root Cause Analysis

The issue had **multiple layers** of problems:

#### Layer 1: Misidentification of IDE
- **Initial assumption**: User was using Cursor/Claude Code (`.claude` directory)
- **Reality**: User was using Codex IDE
- **Impact**: Spent time fixing the wrong IDE's agents

#### Layer 2: IDE-Specific Architecture Differences

**Claude Code / Cursor** (`.claude/commands/`):
- ✅ **Per-project** agent storage
- ✅ Agents stored in project directory: `{project}/.claude/commands/bmad/`
- ✅ Each project has its own agent files
- ✅ Switching projects automatically uses correct agents

**Codex** (`~/.codex/prompts/`):
- ❌ **Global** agent storage (shared across ALL projects)
- ❌ Agents stored in home directory: `~/.codex/prompts/`
- ❌ Single set of agent files for all projects
- ❌ Switching projects requires rebuilding agents

#### Layer 3: Path Hardcoding During Compilation

BMAD agents use template variables like `{project-root}` in source files:

```xml
<item cmd="*workflow-status" 
      workflow="{project-root}/bmad/bmm/workflows/1-analysis/workflow-status/workflow.yaml">
```

**During IDE setup/update**, these variables are **replaced with absolute paths**:

```xml
<!-- For wanELF project: -->
<item cmd="*workflow-status" 
      workflow="/home/jpw/git/wanELF/bmad/bmm/workflows/1-analysis/workflow-status/workflow.yaml">

<!-- For DeepAgents project: -->
<item cmd="*workflow-status" 
      workflow="/home/jpw/git/DeepAgents/bmad/bmm/workflows/1-analysis/workflow-status/workflow.yaml">
```

#### Layer 4: Installation History

The timeline of what happened:

1. **User installed BMAD in wanELF project** → Codex agents got wanELF paths
2. **User later installed BMAD in DeepAgents project** → `.claude` got DeepAgents paths
3. **User switched to Codex IDE** → Codex still had old wanELF agents
4. **User invoked agents in DeepAgents** → Codex used global agents with wanELF paths
5. **Agents read wanELF config/status files** → Showed wrong project data

### Why Standard Rebuild Commands Didn't Work

1. **`bmad build --all`** - Only rebuilds `.agent.yaml` to `.md` in project directories, doesn't touch Codex
2. **`bmad update`** - Failed due to module detection issues
3. **Initial rebuild script** - Only targeted `.claude` directory, didn't know about `~/.codex`

---

## The Complete Fix

### Step 1: Identified the Correct IDE

Instead of assuming `.claude`, checked which IDE was actually in use:
- Searched for Codex-specific directories
- Found agents in `~/.codex/prompts/` with hardcoded wanELF paths

### Step 2: Rebuilt Codex Agents with Correct Project

Ran Codex setup from DeepAgents project with proper module specification:

```javascript
const { CodexSetup } = require('./tools/cli/installers/lib/ide/codex.js');
const setup = new CodexSetup();

await setup.setup(
  '/home/jpw/git/DeepAgents',           // Current project
  '/home/jpw/git/DeepAgents/bmad',      // BMAD installation
  { 
    codexMode: 'cli',
    selectedModules: ['bmm', 'bmb', 'cis']  // Critical: Must specify modules!
  }
);
```

### Step 3: Verified the Fix

Checked that all 18 agents in `~/.codex/prompts/` now had DeepAgents paths:

```bash
grep -n "wanELF\|DeepAgents" ~/.codex/prompts/bmad-bmm-agents-dev.md
# Results: All paths now show /home/jpw/git/DeepAgents/
```

---

## Prevention: How to Avoid This Issue

### Rule 1: Know Your IDE Storage Model

| IDE | Storage Location | Scope | Requires Rebuild When Switching Projects? |
|-----|-----------------|-------|------------------------------------------|
| **Cursor** | `{project}/.claude/commands/` | Per-project | ❌ No |
| **Cline** | `{project}/.cline/commands/` | Per-project | ❌ No |
| **Claude Code** | `{project}/.claude/commands/` | Per-project | ❌ No |
| **Codex** | `~/.codex/prompts/` | **Global** | ✅ **YES** |
| **GitHub Copilot** | `~/.github/copilot/` | **Global** | ✅ **YES** |
| **Windsurf** | `{project}/.windsurf/commands/` | Per-project | ❌ No |

### Rule 2: Always Rebuild Global IDEs When Switching Projects

**If you use Codex or GitHub Copilot:**

```bash
# EVERY TIME you switch to a different project:

# 1. Navigate to the new project
cd /path/to/new-project

# 2. Rebuild IDE agents for this project
node /path/to/BMAD-METHOD/tools/cli/bmad-cli.js update --directory $(pwd)

# OR use the manual method:
node -e "
const { CodexSetup } = require('./path/to/BMAD-METHOD/tools/cli/installers/lib/ide/codex.js');
const setup = new CodexSetup();
const manifest = require('./bmad/_cfg/manifest.yaml');

(async () => {
  await setup.setup(
    process.cwd(),
    process.cwd() + '/bmad',
    { 
      codexMode: 'cli',
      selectedModules: manifest.modules || ['bmm', 'bmb', 'cis']
    }
  );
})();
"
```

### Rule 3: Verify After Switching Projects

Always verify you're in the correct project before running agents:

```bash
# Quick verification command
cat bmad/bmm/config.yaml | grep project_name

# Should show your current project name
# project_name: DeepAgents  ← Correct!
```

### Rule 4: Use Project-Scoped IDEs for Multi-Project Work

If you frequently switch between projects, prefer IDEs with **per-project** storage:
- ✅ **Cursor** (recommended)
- ✅ **Cline**
- ✅ **Windsurf**
- ⚠️ **Codex** (requires manual rebuild when switching)

### Rule 5: Set Up Shell Aliases for Quick Switching

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
# Quick project switcher with automatic IDE rebuild
bmad-switch() {
  local project_path="$1"
  
  if [ -z "$project_path" ]; then
    echo "Usage: bmad-switch /path/to/project"
    return 1
  fi
  
  cd "$project_path" || return 1
  
  echo "📂 Switched to: $project_path"
  
  # Check project name
  if [ -f "bmad/bmm/config.yaml" ]; then
    local project_name=$(grep "project_name:" bmad/bmm/config.yaml | cut -d' ' -f2)
    echo "📊 Project: $project_name"
  fi
  
  # Rebuild Codex if it's installed
  if [ -d "$HOME/.codex/prompts" ]; then
    echo "🔨 Rebuilding Codex agents for this project..."
    # Add rebuild command here
  fi
}

# Quick aliases for your projects
alias bmad-wanelf='bmad-switch ~/git/wanELF'
alias bmad-deepagents='bmad-switch ~/git/DeepAgents'
```

---

## Diagnostic Commands

When experiencing wrong-project issues, use these commands to diagnose:

### 1. Check Which IDE You're Using

```bash
# List all IDE directories in current project
ls -la | grep "^\."

# Check global IDE directories
ls -la ~/.codex 2>/dev/null && echo "Codex installed"
ls -la ~/.github/copilot 2>/dev/null && echo "Copilot installed"
```

### 2. Check Current Project Configuration

```bash
# What project does the config think it is?
cat bmad/bmm/config.yaml | grep project_name

# Where is output folder?
cat bmad/bmm/config.yaml | grep output_folder
```

### 3. Check Agent Paths (Per-Project IDEs)

```bash
# For Cursor/Claude
grep -n "project-root\|/home/" .claude/commands/bmad/bmm/agents/dev.md | head -5

# Should show either {project-root} or correct absolute path
```

### 4. Check Agent Paths (Global IDEs)

```bash
# For Codex
grep -n "/home/.*/git/" ~/.codex/prompts/bmad-bmm-agents-dev.md | head -5

# Should show paths matching your CURRENT project
```

### 5. Check Workflow Status File

```bash
# What project is in the status file?
head -5 bmad/bmm-workflow-status.md

# Line 3 should show:
# **Project:** YourCurrentProjectName
```

---

## Quick Fix Scripts

### Script 1: Emergency Project Reset

Save as `reset-bmad-project.sh`:

```bash
#!/bin/bash

# Emergency script to reset BMAD for current project

echo "🔧 BMAD Project Reset Script"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Verify we're in a BMAD project
if [ ! -f "bmad/bmm/config.yaml" ]; then
  echo "❌ Error: Not in a BMAD project directory"
  echo "   Run this script from your project root"
  exit 1
fi

# Show current project
PROJECT_NAME=$(grep "project_name:" bmad/bmm/config.yaml | cut -d' ' -f2)
echo "📊 Current project: $PROJECT_NAME"
echo ""

# Find BMAD-METHOD source
if [ -d "research_material/BMAD-METHOD" ]; then
  BMAD_SOURCE="research_material/BMAD-METHOD"
elif [ -d "../BMAD-METHOD" ]; then
  BMAD_SOURCE="../BMAD-METHOD"
else
  echo "⚠️  Cannot find BMAD-METHOD source"
  echo "   Please specify path to BMAD-METHOD"
  read -p "Path: " BMAD_SOURCE
fi

echo "📂 BMAD Source: $BMAD_SOURCE"
echo ""

# Rebuild per-project IDEs
if [ -d ".claude" ]; then
  echo "🔨 Rebuilding Cursor/Claude agents..."
  node "$BMAD_SOURCE/rebuild-agents-for-deepagents.js"
fi

# Rebuild global IDEs
if [ -d "$HOME/.codex/prompts" ]; then
  echo "🔨 Rebuilding Codex agents..."
  node -e "
    const { CodexSetup } = require('$BMAD_SOURCE/tools/cli/installers/lib/ide/codex.js');
    const setup = new CodexSetup();
    (async () => {
      await setup.setup(
        process.cwd(),
        process.cwd() + '/bmad',
        { codexMode: 'cli', selectedModules: ['bmm', 'bmb', 'cis'] }
      );
    })();
  "
fi

echo ""
echo "✅ Done! Please restart your IDE."
```

### Script 2: Project Verification

Save as `verify-bmad-project.sh`:

```bash
#!/bin/bash

echo "🔍 BMAD Project Verification"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Current directory
echo "📂 Current directory: $(pwd)"
echo ""

# Project configuration
if [ -f "bmad/bmm/config.yaml" ]; then
  echo "✅ BMAD config found"
  PROJECT_NAME=$(grep "project_name:" bmad/bmm/config.yaml | cut -d' ' -f2)
  OUTPUT_FOLDER=$(grep "output_folder:" bmad/bmm/config.yaml | cut -d' ' -f2)
  echo "   Project name: $PROJECT_NAME"
  echo "   Output folder: $OUTPUT_FOLDER"
else
  echo "❌ No BMAD config found"
  exit 1
fi

echo ""

# Workflow status
if [ -f "bmad/bmm-workflow-status.md" ]; then
  echo "✅ Workflow status found"
  STATUS_PROJECT=$(grep "^\*\*Project:\*\*" bmad/bmm-workflow-status.md | cut -d' ' -f2)
  echo "   Status file project: $STATUS_PROJECT"
  
  if [ "$PROJECT_NAME" = "$STATUS_PROJECT" ]; then
    echo "   ✓ Matches config"
  else
    echo "   ⚠️  MISMATCH! Config says $PROJECT_NAME but status says $STATUS_PROJECT"
  fi
else
  echo "⚠️  No workflow status file"
fi

echo ""

# Check IDEs
echo "🖥️  Installed IDEs:"
[ -d ".claude" ] && echo "   ✓ Cursor/Claude (.claude)"
[ -d ".cline" ] && echo "   ✓ Cline (.cline)"
[ -d ".windsurf" ] && echo "   ✓ Windsurf (.windsurf)"
[ -d "$HOME/.codex" ] && echo "   ✓ Codex (global: ~/.codex)"
[ -d "$HOME/.github/copilot" ] && echo "   ✓ Copilot (global: ~/.github/copilot)"

echo ""

# Check agent paths for global IDEs
if [ -d "$HOME/.codex/prompts" ] && [ -f "$HOME/.codex/prompts/bmad-bmm-agents-dev.md" ]; then
  echo "🔍 Checking Codex agent paths..."
  CODEX_PATH=$(grep -m1 "/home/.*/git/" "$HOME/.codex/prompts/bmad-bmm-agents-dev.md" | sed 's/.*\(\/home\/[^/]*\/git\/[^/]*\).*/\1/')
  echo "   Codex agents point to: $CODEX_PATH"
  
  if [[ "$(pwd)" == *"$CODEX_PATH"* ]] || [[ "$CODEX_PATH" == *"$(basename $(pwd))"* ]]; then
    echo "   ✓ Matches current project"
  else
    echo "   ❌ MISMATCH! You're in $(pwd) but Codex points to $CODEX_PATH"
    echo "   ⚠️  RUN: bmad update or rebuild Codex agents"
  fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
```

---

## Best Practices Summary

### ✅ DO:

1. **Know your IDE storage model** (per-project vs. global)
2. **Always rebuild global IDE agents** when switching projects
3. **Verify project name** before running agents
4. **Use per-project IDEs** for multi-project workflows
5. **Create shell aliases** for quick project switching
6. **Run verification scripts** when something seems wrong

### ❌ DON'T:

1. **Don't assume all IDEs work the same way**
2. **Don't switch projects without verifying** agent paths
3. **Don't ignore project name mismatches** in agent output
4. **Don't modify agents directly** in global directories
5. **Don't use `bmad build`** - it won't rebuild IDE-specific agents
6. **Don't forget to restart your IDE** after rebuilding agents

---

## Troubleshooting Flowchart

```
Agent showing wrong project?
    │
    ├─→ Check: What IDE are you using?
    │   └─→ grep "prompt" $(which yourIDE)
    │
    ├─→ Is it a global IDE (Codex/Copilot)?
    │   ├─→ YES: Check agent paths in global directory
    │   │   └─→ Wrong project? Rebuild agents for current project
    │   │
    │   └─→ NO: Check agent paths in project directory
    │       └─→ Wrong project? Re-run bmad install/update
    │
    ├─→ Verify config file
    │   └─→ cat bmad/bmm/config.yaml | grep project_name
    │
    ├─→ Verify status file
    │   └─→ head -5 bmad/bmm-workflow-status.md
    │
    └─→ Still broken? Run verification script
        └─→ ./verify-bmad-project.sh
```

---

## Lessons Learned

### For Users:

1. **Global IDEs require extra care** when working with multiple projects
2. **Always verify your environment** before running agents
3. **Set up automation** (shell aliases, scripts) to prevent mistakes

### For BMAD Developers:

1. **Better IDE detection** in diagnostic commands
2. **Warn users about global IDE limitations** during installation
3. **Auto-detect project switches** and prompt for rebuild
4. **Add `bmad switch-project`** command
5. **Improve error messages** to mention which project is being used

### For Documentation:

1. **Document IDE storage models** prominently
2. **Create troubleshooting guides** for common issues
3. **Provide ready-to-use scripts** for project management
4. **Add warnings in installation** about multi-project setups

---

## Future Enhancements

### Planned Improvements:

1. **`bmad switch-project` command** - Automatic project switching with IDE rebuild
2. **Project name in agent greeting** - Always show which project agents think they're in
3. **Pre-flight checks** - Verify project context before executing workflows
4. **IDE-agnostic rebuild** - Single command that rebuilds all installed IDEs
5. **Project workspace manager** - GUI/CLI tool for managing multiple BMAD projects

---

## Related Documentation

- **[Recompiling Agents Guide](./recompiling-agents-guide.md)** - How to rebuild agents
- **[Agent Architecture Overview](./agent-architecture-overview.md)** - How agents work
- **[Troubleshooting Wrong Project](./troubleshooting-wrong-project.md)** - Diagnostic steps

---

*This guide was created after resolving a critical multi-project contamination issue. It serves as both a post-mortem and a prevention guide for future users.*

**Last Updated**: 2025-01-XX  
**Affected Versions**: BMAD-CORE v6.0-alpha  
**Severity**: High - Can cause data corruption if agents modify wrong project