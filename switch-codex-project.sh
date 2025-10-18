#!/bin/bash

################################################################################
# Codex Project Switcher for BMAD Multi-Project Environments
#
# This script automates switching between BMAD projects when using Codex IDE.
# It rebuilds Codex agents with correct project paths and verifies the switch.
#
# Usage:
#   ./switch-codex-project.sh /path/to/project
#   ./switch-codex-project.sh ~/git/wanELF
#   ./switch-codex-project.sh ~/git/DeepAgents
#
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🔄 CODEX PROJECT SWITCHER"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if project path provided
if [ -z "$1" ]; then
  echo -e "${RED}❌ Error: No project path provided${NC}"
  echo ""
  echo "Usage: $0 /path/to/project"
  echo ""
  echo "Examples:"
  echo "  $0 ~/git/wanELF"
  echo "  $0 ~/git/DeepAgents"
  echo ""
  exit 1
fi

TARGET_PROJECT="$1"

# Expand tilde and resolve absolute path
TARGET_PROJECT="${TARGET_PROJECT/#\~/$HOME}"
TARGET_PROJECT="$(cd "$TARGET_PROJECT" 2>/dev/null && pwd)" || {
  echo -e "${RED}❌ Error: Project directory does not exist: $1${NC}"
  exit 1
}

# Verify it's a BMAD project
if [ ! -f "$TARGET_PROJECT/bmad/bmm/config.yaml" ]; then
  echo -e "${RED}❌ Error: Not a BMAD project${NC}"
  echo "   No config found at: $TARGET_PROJECT/bmad/bmm/config.yaml"
  echo ""
  echo "   Please run BMAD installation first:"
  echo "   cd $TARGET_PROJECT"
  echo "   npx bmad-method install"
  echo ""
  exit 1
fi

# Check if Codex is installed
if [ ! -d "$HOME/.codex" ]; then
  echo -e "${YELLOW}⚠️  Warning: Codex directory not found at ~/.codex${NC}"
  echo "   This script is for Codex IDE users only."
  echo ""
  read -p "Continue anyway? (y/N): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
  fi
fi

# Get project name from config
PROJECT_NAME=$(grep "project_name:" "$TARGET_PROJECT/bmad/bmm/config.yaml" | sed 's/project_name: *//' | tr -d '\r')

if [ -z "$PROJECT_NAME" ]; then
  echo -e "${RED}❌ Error: Could not read project name from config${NC}"
  exit 1
fi

# Display current state
echo -e "${BLUE}📂 Current directory:${NC} $(pwd)"
echo -e "${BLUE}🎯 Target project:${NC} $TARGET_PROJECT"
echo -e "${BLUE}📊 Project name:${NC} $PROJECT_NAME"
echo ""

# Find BMAD-METHOD source
BMAD_SOURCE=""

# Check common locations
if [ -d "$TARGET_PROJECT/research_material/BMAD-METHOD" ]; then
  BMAD_SOURCE="$TARGET_PROJECT/research_material/BMAD-METHOD"
elif [ -d "$TARGET_PROJECT/../BMAD-METHOD" ]; then
  BMAD_SOURCE="$(cd "$TARGET_PROJECT/../BMAD-METHOD" && pwd)"
elif [ -d "$TARGET_PROJECT/BMAD-METHOD" ]; then
  BMAD_SOURCE="$TARGET_PROJECT/BMAD-METHOD"
else
  echo -e "${YELLOW}⚠️  Could not auto-detect BMAD-METHOD source${NC}"
  echo ""
  read -p "Enter path to BMAD-METHOD directory: " BMAD_SOURCE
  BMAD_SOURCE="${BMAD_SOURCE/#\~/$HOME}"

  if [ ! -d "$BMAD_SOURCE" ]; then
    echo -e "${RED}❌ Error: BMAD-METHOD source not found at: $BMAD_SOURCE${NC}"
    exit 1
  fi
fi

echo -e "${BLUE}🔧 BMAD Source:${NC} $BMAD_SOURCE"
echo ""

# Check if CodexSetup exists
if [ ! -f "$BMAD_SOURCE/tools/cli/installers/lib/ide/codex.js" ]; then
  echo -e "${RED}❌ Error: CodexSetup not found${NC}"
  echo "   Expected at: $BMAD_SOURCE/tools/cli/installers/lib/ide/codex.js"
  exit 1
fi

# Get installed modules from manifest
MODULES="['bmm', 'bmb', 'cis']"  # Default

if [ -f "$TARGET_PROJECT/bmad/_cfg/manifest.yaml" ]; then
  echo -e "${CYAN}📦 Reading installed modules from manifest...${NC}"
  # Extract modules from manifest (simple parsing)
  INSTALLED_MODULES=$(grep -A 10 "^modules:" "$TARGET_PROJECT/bmad/_cfg/manifest.yaml" | grep "^  - " | sed 's/^  - //' | tr '\n' ',' | sed 's/,$//')
  if [ -n "$INSTALLED_MODULES" ]; then
    # Convert to JavaScript array format
    MODULES="['$(echo "$INSTALLED_MODULES" | sed "s/,/', '/g")']"
    echo -e "   ${GREEN}✓${NC} Modules: $INSTALLED_MODULES"
  fi
fi

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}🔨 REBUILDING CODEX AGENTS${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Rebuild Codex agents
cd "$TARGET_PROJECT"

node -e "
const { CodexSetup } = require('$BMAD_SOURCE/tools/cli/installers/lib/ide/codex.js');
const setup = new CodexSetup();

(async () => {
  try {
    const result = await setup.setup(
      '$TARGET_PROJECT',
      '$TARGET_PROJECT/bmad',
      {
        codexMode: 'cli',
        selectedModules: $MODULES
      }
    );

    console.log('');
    console.log('✅ Codex agents rebuilt successfully!');
    console.log('   Agents exported:', result.counts.agents);
    console.log('   Workflows exported:', result.counts.workflows);
    console.log('');

  } catch (error) {
    console.error('❌ Error rebuilding Codex agents:', error.message);
    process.exit(1);
  }
})();
" || {
  echo -e "${RED}❌ Failed to rebuild Codex agents${NC}"
  exit 1
}

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}🔍 VERIFICATION${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Verify the switch
if [ -f "$HOME/.codex/prompts/bmad-bmm-agents-dev.md" ]; then
  echo -e "${BLUE}Checking agent paths...${NC}"

  # Extract path from dev agent
  AGENT_PATH=$(grep -m1 "/home/.*/git/" "$HOME/.codex/prompts/bmad-bmm-agents-dev.md" 2>/dev/null | sed 's/.*\(\/home\/[^/]*\/git\/[^/]*\).*/\1/')

  if [ -n "$AGENT_PATH" ]; then
    echo -e "   Agent path: ${YELLOW}$AGENT_PATH${NC}"

    if [[ "$TARGET_PROJECT" == *"$(basename "$AGENT_PATH")"* ]]; then
      echo -e "   ${GREEN}✓ Paths match target project${NC}"
    else
      echo -e "   ${RED}⚠️  Path mismatch detected${NC}"
      echo -e "   Target: $TARGET_PROJECT"
      echo -e "   Agent:  $AGENT_PATH"
    fi
  else
    echo -e "   ${YELLOW}⚠️  Could not extract path (may be using variables)${NC}"
  fi
else
  echo -e "${YELLOW}⚠️  Dev agent not found in Codex prompts${NC}"
fi

echo ""

# Check for wrong project references
if [ -f "$HOME/.codex/prompts/bmad-bmm-agents-dev.md" ]; then
  # Get all unique project paths from agent files
  FOUND_PROJECTS=$(grep -h "/home/.*/git/[^/]*" "$HOME/.codex/prompts/bmad-bmm-agents-"*.md 2>/dev/null | grep -o "/home/[^/]*/git/[^/]*" | sort -u)

  if [ -n "$FOUND_PROJECTS" ]; then
    FOUND_COUNT=$(echo "$FOUND_PROJECTS" | wc -l)

    if [ "$FOUND_COUNT" -eq 1 ]; then
      echo -e "${GREEN}✓ All agents reference a single project${NC}"
    else
      echo -e "${YELLOW}⚠️  Multiple project paths found in agents:${NC}"
      echo "$FOUND_PROJECTS" | while read -r proj; do
        echo "   - $proj"
      done
      echo ""
      echo -e "${YELLOW}   This may indicate incomplete rebuild. Consider re-running this script.${NC}"
    fi
  fi
fi

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}✨ NEXT STEPS${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}1.${NC} Change to the project directory:"
echo -e "   ${BLUE}cd $TARGET_PROJECT${NC}"
echo ""
echo -e "${GREEN}2.${NC} Restart Codex IDE completely (quit and reopen)"
echo ""
echo -e "${GREEN}3.${NC} Test an agent to verify:"
echo -e "   ${BLUE}@dev *workflow-status${NC}"
echo ""
echo -e "${GREEN}4.${NC} Verify it shows:"
echo -e "   ${BLUE}Project: $PROJECT_NAME${NC}"
echo ""
echo -e "${YELLOW}⚠️  Remember: Run this script EVERY TIME you switch projects!${NC}"
echo ""

# Offer to change directory
read -p "Change to project directory now? (Y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
  cd "$TARGET_PROJECT"
  echo ""
  echo -e "${GREEN}✓ Changed to: $(pwd)${NC}"
  echo ""
  echo "You can now work in $PROJECT_NAME"
  echo ""

  # If running in interactive shell, spawn a new shell in the project directory
  if [ -n "$PS1" ]; then
    echo "Starting new shell in project directory..."
    exec $SHELL
  fi
fi

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Project switch complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
