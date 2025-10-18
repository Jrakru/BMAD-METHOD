---
title: Recompiling and Redeploying Agents Guide
version: 6.0-alpha
last-updated: 2025-01-XX
---

# Recompiling and Redeploying Agents Guide

This guide explains how to recompile agents after modifying their YAML source files and redeploy them so that your IDE (Cursor, Cline, etc.) picks up the changes.

## Overview

BMAD agents are authored as `.agent.yaml` files and compiled to `.md` (XML format) files that IDEs consume. When you modify an agent's YAML source, you need to:

1. **Compile** the YAML to XML/MD format
2. **Verify** the compilation succeeded
3. **Reload** your IDE (if necessary)

The compilation process uses the `bmad build` command, which reads the YAML source and generates the final agent file with proper XML structure.

---

## Quick Reference

```bash
# Check which agents need recompiling
npx bmad-method build

# Recompile a specific agent
npx bmad-method build <agent-name>

# Recompile all agents
npx bmad-method build --all

# Force rebuild (even if up to date)
npx bmad-method build --all --force
```

---

## Understanding Agent Compilation

### Agent File Locations

BMAD has two types of agents with different locations:

#### 1. Standalone Agents
**Source**: `bmad/agents/{agent-name}/{agent-name}.agent.yaml`  
**Compiled**: `bmad/agents/{agent-name}/{agent-name}.md`  
**Customization**: `bmad/_cfg/agents/{agent-name}.customize.yaml`

#### 2. Module Agents
**Source**: `.claude/commands/bmad/{module}/agents/{agent-name}.agent.yaml`  
**Compiled**: `.claude/commands/bmad/{module}/agents/{agent-name}.md`  
**Customization**: `.claude/_cfg/agents/{agent-name}.customize.yaml`

### What Gets Compiled

The build process:
- ✅ Reads the `.agent.yaml` source file
- ✅ Applies any customizations from `.customize.yaml` (if exists)
- ✅ Validates the YAML structure
- ✅ Generates XML-formatted agent definition
- ✅ Saves as `.md` file with build metadata
- ✅ Adds hash for change detection

---

## Step-by-Step: Recompiling Agents

### Step 1: Navigate to Your Project

```bash
cd /path/to/your/project
```

Your project should contain either:
- A `.claude` directory (for Cursor/Cline)
- A `bmad` directory (for standalone installations)

### Step 2: Check Build Status

Before rebuilding, check what needs updating:

```bash
npx bmad-method build
```

**Output Examples**:

```
✓ All agents are up to date
```

Or if changes detected:

```
3 agent(s) need rebuilding:
  - pm (bmm)
  - architect (bmm)
  - atlas (bmm)

Run "bmad build --all" to rebuild all agents
```

### Step 3: Compile Agents

#### Option A: Compile Specific Agent

If you modified one agent:

```bash
npx bmad-method build pm
```

**Output**:
```
🔨 Building Agent Files

  Building pm...
  ✓ pm built successfully
```

#### Option B: Compile All Agents

If you modified multiple agents or want to ensure everything is up to date:

```bash
npx bmad-method build --all
```

**Output**:
```
🔨 Building Agent Files

Building standalone agents...
  custom-helper: up to date

Building module agents...
  Building pm...
  ✓ pm (bmm)
  Building architect...
  ✓ architect (bmm)
  Building dev...
  ✓ dev (bmm)
  atlas: up to date

✓ Built 3 agent(s)
  Skipped 2 (already up to date)
```

#### Option C: Force Rebuild Everything

To rebuild all agents regardless of change detection:

```bash
npx bmad-method build --all --force
```

This ignores hash checks and rebuilds everything from scratch.

### Step 4: Verify Compilation

Check that the `.md` files were updated:

```bash
# For module agents
ls -l .claude/commands/bmad/{module}/agents/*.md

# For standalone agents
ls -l bmad/agents/*/\*.md
```

Look for recent timestamps to confirm files were rebuilt.

---

## Common Scenarios

### Scenario 1: Modified Agent Persona or Menu

You changed the `persona` section or `menu` items in an agent YAML file.

**Steps**:
```bash
# 1. Check status
npx bmad-method build

# 2. Rebuild the modified agent
npx bmad-method build pm

# 3. Reload your IDE
# In Cursor: Cmd/Ctrl+Shift+P → "Developer: Reload Window"
# In Cline: Restart the extension
```

### Scenario 2: Updated Multiple Agents

You updated several agents across different modules.

**Steps**:
```bash
# Rebuild all agents
npx bmad-method build --all

# Reload IDE to pick up changes
```

### Scenario 3: Created Customization File

You created or modified a `.customize.yaml` file.

**Steps**:
```bash
# The customize file is automatically detected
# Just rebuild the corresponding agent
npx bmad-method build atlas

# The build process will merge the customization
```

### Scenario 4: Updated Agent in Source (src/)

You modified an agent in the BMAD source directory (`src/modules/bmm/agents/`).

**Steps**:
```bash
# 1. The source files need to be installed first
npx bmad-method install

# 2. This will copy updated agents to your project
# 3. Then rebuild
npx bmad-method build --all
```

### Scenario 5: Pulling Updates from Git

You pulled latest changes from the BMAD repository.

**Steps**:
```bash
# 1. Pull changes
git pull origin v6-alpha

# 2. Update npm dependencies
npm install

# 3. Reinstall/update BMAD in your project
npx bmad-method update

# 4. Rebuild all agents
npx bmad-method build --all --force
```

---

## IDE Integration

### Cursor IDE

After recompiling agents:

1. **Reload Window**: `Cmd/Ctrl+Shift+P` → "Developer: Reload Window"
2. Or restart Cursor completely
3. Test agent with custom commands: `@agent-name`

### Cline Extension (VS Code)

After recompiling agents:

1. **Restart Extension**: Click Cline icon → Settings → Restart
2. Or reload VS Code: `Cmd/Ctrl+Shift+P` → "Developer: Reload Window"
3. Test agent in Cline interface

### Claude Desktop / ChatGPT (Web Bundles)

For web bundles, agents need to be bundled separately:

```bash
# Bundle all modules for web
npm run bundle

# Or bundle specific module
node tools/cli/bundlers/bundle-web.js bmm
```

Then upload the generated bundle from `bundles/` directory.

---

## Troubleshooting

### Issue: "No .claude directory found"

**Problem**: Build command can't find your project.

**Solution**: Run from project directory or specify path:
```bash
npx bmad-method build --directory /path/to/project
```

### Issue: "Agent not found"

**Problem**: Agent name doesn't match any YAML files.

**Solution**: List available agents:
```bash
npx bmad-method build
```

Check the "Available agents" section at the bottom.

### Issue: Agent changes not reflected in IDE

**Problem**: IDE hasn't reloaded the agent definitions.

**Solutions**:
1. Verify `.md` file was updated: `ls -l .claude/commands/bmad/*/agents/*.md`
2. Force rebuild: `npx bmad-method build <agent> --force`
3. Completely reload IDE (not just window refresh)
4. Check IDE console for errors loading agents

### Issue: "Build succeeded but agent behaves oddly"

**Problem**: Customization file may have conflicting settings.

**Solution**: Check customization file:
```bash
# Module agent
cat .claude/_cfg/agents/<agent-name>.customize.yaml

# Standalone agent
cat bmad/_cfg/agents/<agent-name>.customize.yaml
```

Remove customization file temporarily to test:
```bash
mv .claude/_cfg/agents/<agent-name>.customize.yaml \
   .claude/_cfg/agents/<agent-name>.customize.yaml.bak

npx bmad-method build <agent-name>
```

### Issue: Build errors or validation failures

**Problem**: YAML syntax error in agent source.

**Solution**: 
1. Check YAML syntax with a linter
2. Review error message for specific line/issue
3. Compare with working agent YAML structure
4. See [Agent Architecture Overview](./agent-architecture-overview.md) for proper format

---

## Advanced: Build Process Details

### Change Detection

The build system uses hash-based change detection:

```bash
# Agent .md file contains metadata like:
<!-- BUILD-META
  source: pm.agent.yaml (hash: a1b2c3d4...)
  customize: pm.customize.yaml (hash: e5f6g7h8...)
-->
```

If hashes match, the build is skipped (unless `--force` is used).

### Customization Merging

When a `.customize.yaml` file exists:

1. Base agent YAML is loaded
2. Customization values are merged (overwrites matching keys)
3. Merged result is compiled to XML
4. Both hashes stored in output for future change detection

### Build Output Structure

Generated `.md` files contain:

```markdown
# {Agent Title}

<!-- BUILD-META -->

<agent id="..." name="..." title="..." icon="...">
  <persona>
    <role>...</role>
    <identity>...</identity>
    ...
  </persona>
  
  <menu>
    <item cmd="*command">Description</item>
    ...
  </menu>
  
  <prompts>
    ...
  </prompts>
</agent>
```

---

## Best Practices

### 1. Always Check Status First

Before rebuilding, check what needs updating:
```bash
npx bmad-method build
```

This saves time by only rebuilding what changed.

### 2. Test After Compilation

After rebuilding:
1. Reload your IDE
2. Test the agent with a simple command
3. Verify behavior matches your changes

### 3. Use Customization Files

Instead of modifying agents directly:
1. Create `.customize.yaml` file
2. Override only what you need
3. Original agent updates won't conflict with your changes

### 4. Version Control

Commit both YAML and compiled MD files:
```bash
git add bmad/agents/*/\*.agent.yaml
git add bmad/agents/*/\*.md
git commit -m "Update agent persona and menu"
```

### 5. Batch Rebuilds

If updating multiple agents, rebuild all at once:
```bash
npx bmad-method build --all
```

More efficient than rebuilding one at a time.

---

## Quick Command Reference

| Task | Command |
|------|---------|
| **Check status** | `npx bmad-method build` |
| **Build one agent** | `npx bmad-method build <agent-name>` |
| **Build all agents** | `npx bmad-method build --all` |
| **Force rebuild** | `npx bmad-method build --all --force` |
| **Specify project** | `npx bmad-method build --directory /path` |
| **Update & rebuild** | `npx bmad-method update && npx bmad-method build --all` |
| **Bundle for web** | `npm run bundle` |

---

## Related Documentation

- **[Agent Architecture Overview](./agent-architecture-overview.md)** - Understanding agent structure
- **[BMad Builder (BMB) README](../src/modules/bmb/README.md)** - Creating new agents
- **[Main README](../README.md)** - Installation and setup

---

## Summary

**Workflow Summary**:
1. Modify `.agent.yaml` source file
2. Run `npx bmad-method build <agent-name>`
3. Verify compilation succeeded
4. Reload IDE
5. Test agent

**Key Points**:
- ✅ YAML source files are compiled to MD/XML format
- ✅ Build process detects changes via hash comparison
- ✅ Customization files are automatically merged
- ✅ IDE must be reloaded to pick up changes
- ✅ Use `--force` to rebuild regardless of changes

---

*This guide is part of BMAD-CORE v6-alpha documentation.*