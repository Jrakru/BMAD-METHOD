# 🔄 Codex Project Switcher - Quick Start Guide

## What This Solves

**Problem**: Codex stores agents globally in `~/.codex/prompts/` (shared across ALL projects). When you switch projects, Codex still uses the old project's paths, causing agents to read/write to the wrong project.

**Solution**: This script automatically rebuilds Codex agents with the correct project paths whenever you switch projects.

---

## Installation (One-Time Setup)

The script is already installed at:
```
/home/jpw/git/DeepAgents/research_material/BMAD-METHOD/bmad-switch
```

### Optional: Create a Global Alias

Add this to your `~/.bashrc` or `~/.zshrc`:

```bash
# BMAD Codex Project Switcher
alias bmad-switch='/home/jpw/git/DeepAgents/research_material/BMAD-METHOD/bmad-switch'

# Quick aliases for your projects
alias bmad-wanelf='bmad-switch ~/git/wanELF'
alias bmad-deepagents='bmad-switch ~/git/DeepAgents'
```

Then reload your shell:
```bash
source ~/.bashrc
```

---

## Usage

### Switch to Any Project

```bash
/home/jpw/git/DeepAgents/research_material/BMAD-METHOD/bmad-switch /path/to/project
```

### Examples

```bash
# Switch to wanELF
~/git/DeepAgents/research_material/BMAD-METHOD/bmad-switch ~/git/wanELF

# Switch to DeepAgents
~/git/DeepAgents/research_material/BMAD-METHOD/bmad-switch ~/git/DeepAgents

# With alias (after setup above)
bmad-switch ~/git/wanELF
bmad-wanelf
```

---

## What the Script Does

1. ✅ **Validates** target project is a BMAD project
2. ✅ **Detects** installed modules from manifest
3. ✅ **Rebuilds** all Codex agents with correct project paths
4. ✅ **Verifies** agents point to the correct project
5. ✅ **Reports** success and shows next steps

---

## After Running the Script

**IMPORTANT**: You MUST restart Codex completely for changes to take effect!

1. **Quit Codex** (not just close window)
2. **Reopen Codex** in your project
3. **Test an agent**:
   ```
   @dev *workflow-status
   ```
4. **Verify** it shows the correct project name

---

## When to Use This Script

🔴 **EVERY TIME** you switch between projects!

### Example Workflow

```bash
# Currently working on DeepAgents
# Now need to switch to wanELF:

1. Run: bmad-switch ~/git/wanELF
2. Restart Codex
3. Open wanELF in Codex
4. Test: @dev *workflow-status
5. Verify: Shows "Project: wanELF"
```

---

## Verification

Check if Codex agents match your current project:

```bash
# What project are Codex agents pointing to?
grep -m1 "/home/.*/git/" ~/.codex/prompts/bmad-bmm-agents-dev.md

# Should match your current project directory
```

---

## Troubleshooting

### "Not a BMAD project"
- Make sure the project has `bmad/bmm/config.yaml`
- Run `npx bmad-method install` if needed

### "Codex not installed"
- Script will skip rebuild (only switches directory)
- This is normal if you don't use Codex

### Agents still show wrong project
- Make sure you **restarted Codex** (quit and reopen)
- Not just "reload window" - completely quit the application
- Run the script again to verify

### Script not found
- Use full path: `/home/jpw/git/DeepAgents/research_material/BMAD-METHOD/bmad-switch`
- Or set up the alias (see Installation section)

---

## Quick Reference

| Command | Action |
|---------|--------|
| `bmad-switch /path/to/project` | Switch to project |
| `grep project_name bmad/bmm/config.yaml` | Check current project |
| `grep "/home/.*/git/" ~/.codex/prompts/bmad-bmm-agents-dev.md` | Check Codex agent paths |

---

## ⚠️ Important Notes

1. **Codex uses global storage** - This is why you need to rebuild when switching
2. **Other IDEs are different**:
   - Cursor/Claude: Per-project storage (`.claude/`) - NO rebuild needed
   - Cline: Per-project storage (`.cline/`) - NO rebuild needed
   - Windsurf: Per-project storage (`.windsurf/`) - NO rebuild needed
3. **Don't skip the rebuild** - Working in the wrong project can cause data corruption
4. **Always verify** after switching - Check the project name agents report

---

## Full Documentation

For complete details, see:
- [Multi-Project Setup Guide](./docs/multi-project-setup-guide.md)
- [Recompiling Agents Guide](./docs/recompiling-agents-guide.md)

---

## Summary

```bash
# 1. Switch project (rebuilds agents)
bmad-switch ~/git/YourProject

# 2. Restart Codex (quit and reopen)

# 3. Test
@dev *workflow-status

# 4. Should show: Project: YourProject
```

**Remember**: 🔴 Use this script EVERY TIME you switch projects! 🔴