---
title: Multi-Project Quick Reference Card
version: 6.0-alpha
---

# 🔴 MULTI-PROJECT QUICK REFERENCE

## Critical: Know Your IDE Storage Model

| IDE | Storage | Rebuild When Switching? |
|-----|---------|------------------------|
| **Cursor** | Per-project (`.claude/`) | ❌ No |
| **Cline** | Per-project (`.cline/`) | ❌ No |
| **Windsurf** | Per-project (`.windsurf/`) | ❌ No |
| **Codex** | **Global** (`~/.codex/prompts/`) | ✅ **YES** |
| **GitHub Copilot** | **Global** (`~/.github/copilot/`) | ✅ **YES** |

---

## ⚠️ If You Use Codex or Copilot

### Every Time You Switch Projects:

```bash
# 1. Navigate to new project
cd /path/to/new-project

# 2. Verify you're in the right place
cat bmad/bmm/config.yaml | grep project_name

# 3. Rebuild global IDE agents
node -e "
const { CodexSetup } = require('./research_material/BMAD-METHOD/tools/cli/installers/lib/ide/codex.js');
const setup = new CodexSetup();
(async () => {
  await setup.setup(
    process.cwd(),
    process.cwd() + '/bmad',
    { codexMode: 'cli', selectedModules: ['bmm', 'bmb', 'cis'] }
  );
})();
"

# 4. Restart your IDE
```

---

## 🚨 Symptoms of Wrong-Project Issue

- Agent says "Project: SomeOtherProject" when you're in YourProject
- Workflow status shows wrong project data
- Paths in errors reference different project
- Config loading from wrong directory

---

## 🔍 Quick Diagnostic (30 seconds)

```bash
# Check what project config thinks it is
cat bmad/bmm/config.yaml | grep project_name

# Check what Codex agents think (if using Codex)
grep -m1 "/home/.*/git/" ~/.codex/prompts/bmad-bmm-agents-dev.md

# Should match! If not, rebuild Codex agents.
```

---

## 🛠️ Emergency Fix

```bash
# For Codex users - Run from your CURRENT project:
cd /your/current/project

node -e "
const { CodexSetup } = require('./research_material/BMAD-METHOD/tools/cli/installers/lib/ide/codex.js');
const setup = new CodexSetup();
(async () => {
  await setup.setup(process.cwd(), process.cwd() + '/bmad', 
    { codexMode: 'cli', selectedModules: ['bmm', 'bmb', 'cis'] });
})();
"

# Restart IDE, test with: @dev *help
```

---

## ✅ Prevention Checklist

- [ ] I know which IDE I'm using
- [ ] I know if my IDE uses global or per-project storage
- [ ] I have a shell alias for project switching (if using global IDE)
- [ ] I verify project name before running workflows
- [ ] I restart IDE after rebuilding agents

---

## 📚 Full Documentation

See: [Multi-Project Setup Guide](./multi-project-setup-guide.md)

---

**Remember**: Global IDEs (Codex, Copilot) = Manual rebuild when switching projects!