#!/bin/bash

################################################################################
# Codex Project Switcher - Shell Aliases
#
# Add these aliases to your ~/.bashrc or ~/.zshrc for easy project switching
#
# Installation:
#   1. Source this file in your shell config:
#      echo "source /path/to/codex-project-aliases.sh" >> ~/.bashrc
#
#   2. Or copy the aliases directly into your ~/.bashrc
#
#   3. Reload your shell:
#      source ~/.bashrc
#
# Usage:
#   bmad-switch /path/to/project    # Switch to any project
#   bmad-wanelf                     # Quick switch to wanELF
#   bmad-deepagents                 # Quick switch to DeepAgents
#   bmad-current                    # Show current project info
#   bmad-verify                     # Verify Codex agents match project
################################################################################

# Set this to your BMAD-METHOD location
export BMAD_METHOD_PATH="${BMAD_METHOD_PATH:-$HOME/git/DeepAgents/research_material/BMAD-METHOD}"

# Color codes for output
export BMAD_COLOR_RED='\033[0;31m'
export BMAD_COLOR_GREEN='\033[0;32m'
export BMAD_COLOR_YELLOW='\033[1;33m'
export BMAD_COLOR_BLUE='\033[0;34m'
export BMAD_COLOR_CYAN='\033[0;36m'
export BMAD_COLOR_NC='\033[0m'

################################################################################
# Main project switcher function
################################################################################
bmad-switch() {
  local project_path="$1"

  if [ -z "$project_path" ]; then
    echo -e "${BMAD_COLOR_RED}❌ Error: No project path provided${BMAD_COLOR_NC}"
    echo ""
    echo "Usage: bmad-switch /path/to/project"
    echo ""
    echo "Quick aliases available:"
    echo "  bmad-wanelf       → Switch to wanELF"
    echo "  bmad-deepagents   → Switch to DeepAgents"
    return 1
  fi

  # Expand tilde
  project_path="${project_path/#\~/$HOME}"

  # Check if project exists
  if [ ! -d "$project_path" ]; then
    echo -e "${BMAD_COLOR_RED}❌ Error: Directory not found: $project_path${BMAD_COLOR_NC}"
    return 1
  fi

  # Check if it's a BMAD project
  if [ ! -f "$project_path/bmad/bmm/config.yaml" ]; then
    echo -e "${BMAD_COLOR_RED}❌ Error: Not a BMAD project (no config found)${BMAD_COLOR_NC}"
    return 1
  fi

  # Check if using Codex
  if [ ! -d "$HOME/.codex" ]; then
    echo -e "${BMAD_COLOR_YELLOW}⚠️  Codex not detected - switching directory only${BMAD_COLOR_NC}"
    cd "$project_path"
    bmad-current
    return 0
  fi

  # Run the switcher script
  if [ -f "$BMAD_METHOD_PATH/switch-codex-project.sh" ]; then
    bash "$BMAD_METHOD_PATH/switch-codex-project.sh" "$project_path"
  else
    echo -e "${BMAD_COLOR_YELLOW}⚠️  Switcher script not found, using manual method...${BMAD_COLOR_NC}"
    echo ""

    cd "$project_path"

    # Manual rebuild
    echo -e "${BMAD_COLOR_CYAN}🔨 Rebuilding Codex agents...${BMAD_COLOR_NC}"

    node -e "
    const { CodexSetup } = require('$BMAD_METHOD_PATH/tools/cli/installers/lib/ide/codex.js');
    const setup = new CodexSetup();
    (async () => {
      try {
        await setup.setup(
          process.cwd(),
          process.cwd() + '/bmad',
          { codexMode: 'cli', selectedModules: ['bmm', 'bmb', 'cis'] }
        );
        console.log('✅ Codex agents rebuilt');
      } catch (error) {
        console.error('❌ Error:', error.message);
      }
    })();
    "

    echo ""
    bmad-current
  fi
}

################################################################################
# Show current project info
################################################################################
bmad-current() {
  echo ""
  echo -e "${BMAD_COLOR_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${BMAD_COLOR_NC}"
  echo -e "${BMAD_COLOR_CYAN}📊 Current BMAD Project${BMAD_COLOR_NC}"
  echo -e "${BMAD_COLOR_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${BMAD_COLOR_NC}"
  echo ""

  # Current directory
  echo -e "${BMAD_COLOR_BLUE}📂 Directory:${BMAD_COLOR_NC} $(pwd)"

  # Check if BMAD project
  if [ ! -f "bmad/bmm/config.yaml" ]; then
    echo -e "${BMAD_COLOR_YELLOW}⚠️  Not in a BMAD project directory${BMAD_COLOR_NC}"
    echo ""
    return 1
  fi

  # Project name
  local project_name=$(grep "project_name:" bmad/bmm/config.yaml | sed 's/project_name: *//' | tr -d '\r')
  echo -e "${BMAD_COLOR_BLUE}📊 Project:${BMAD_COLOR_NC} ${BMAD_COLOR_GREEN}$project_name${BMAD_COLOR_NC}"

  # Output folder
  local output_folder=$(grep "output_folder:" bmad/bmm/config.yaml | sed 's/output_folder: *//' | tr -d '\r')
  echo -e "${BMAD_COLOR_BLUE}📁 Output:${BMAD_COLOR_NC} $output_folder"

  # Installed modules
  if [ -f "bmad/_cfg/manifest.yaml" ]; then
    local modules=$(grep -A 10 "^modules:" bmad/_cfg/manifest.yaml | grep "^  - " | sed 's/^  - //' | tr '\n' ', ' | sed 's/,$//')
    echo -e "${BMAD_COLOR_BLUE}📦 Modules:${BMAD_COLOR_NC} $modules"
  fi

  # Check workflow status
  if [ -f "bmad/bmm-workflow-status.md" ]; then
    local status_project=$(grep "^\*\*Project:\*\*" bmad/bmm-workflow-status.md | sed 's/\*\*Project:\*\* *//' | tr -d '\r')
    if [ -n "$status_project" ]; then
      echo -e "${BMAD_COLOR_BLUE}📋 Status:${BMAD_COLOR_NC} $status_project"

      if [ "$project_name" != "$status_project" ]; then
        echo -e "   ${BMAD_COLOR_YELLOW}⚠️  Mismatch: Status file shows different project!${BMAD_COLOR_NC}"
      fi
    fi
  fi

  echo ""
}

################################################################################
# Verify Codex agents match current project
################################################################################
bmad-verify() {
  echo ""
  echo -e "${BMAD_COLOR_CYAN}🔍 Verifying Codex Configuration${BMAD_COLOR_NC}"
  echo ""

  # Check if in BMAD project
  if [ ! -f "bmad/bmm/config.yaml" ]; then
    echo -e "${BMAD_COLOR_RED}❌ Not in a BMAD project directory${BMAD_COLOR_NC}"
    return 1
  fi

  # Check if Codex installed
  if [ ! -d "$HOME/.codex" ]; then
    echo -e "${BMAD_COLOR_YELLOW}⚠️  Codex not installed${BMAD_COLOR_NC}"
    return 0
  fi

  # Get current project info
  local current_dir=$(pwd)
  local project_name=$(grep "project_name:" bmad/bmm/config.yaml | sed 's/project_name: *//' | tr -d '\r')

  echo -e "${BMAD_COLOR_BLUE}Current project:${BMAD_COLOR_NC} $project_name"
  echo -e "${BMAD_COLOR_BLUE}Directory:${BMAD_COLOR_NC} $current_dir"
  echo ""

  # Check Codex agent paths
  if [ -f "$HOME/.codex/prompts/bmad-bmm-agents-dev.md" ]; then
    local agent_path=$(grep -m1 "/home/.*/git/" "$HOME/.codex/prompts/bmad-bmm-agents-dev.md" 2>/dev/null | sed 's/.*\(\/home\/[^/]*\/git\/[^/]*\).*/\1/')

    if [ -n "$agent_path" ]; then
      echo -e "${BMAD_COLOR_BLUE}Codex agents point to:${BMAD_COLOR_NC} $agent_path"
      echo ""

      if [[ "$current_dir" == *"$(basename "$agent_path")"* ]]; then
        echo -e "${BMAD_COLOR_GREEN}✅ Codex agents match current project${BMAD_COLOR_NC}"
        return 0
      else
        echo -e "${BMAD_COLOR_RED}❌ MISMATCH: Codex agents point to wrong project!${BMAD_COLOR_NC}"
        echo ""
        echo -e "${BMAD_COLOR_YELLOW}Fix this by running:${BMAD_COLOR_NC}"
        echo -e "  ${BMAD_COLOR_CYAN}bmad-switch $current_dir${BMAD_COLOR_NC}"
        return 1
      fi
    else
      echo -e "${BMAD_COLOR_YELLOW}⚠️  Could not determine Codex agent paths${BMAD_COLOR_NC}"
    fi
  else
    echo -e "${BMAD_COLOR_YELLOW}⚠️  No Codex agents found${BMAD_COLOR_NC}"
  fi

  echo ""
}

################################################################################
# Quick project aliases - Customize these for your projects!
################################################################################

# Example: Switch to wanELF project
bmad-wanelf() {
  bmad-switch "$HOME/git/wanELF"
}

# Example: Switch to DeepAgents project
bmad-deepagents() {
  bmad-switch "$HOME/git/DeepAgents"
}

################################################################################
# Add your own projects here:
################################################################################

# bmad-myproject() {
#   bmad-switch "$HOME/git/MyProject"
# }

# bmad-clientwork() {
#   bmad-switch "$HOME/clients/ProjectName"
# }

################################################################################
# Help function
################################################################################
bmad-help() {
  echo ""
  echo -e "${BMAD_COLOR_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${BMAD_COLOR_NC}"
  echo -e "${BMAD_COLOR_CYAN}🔧 BMAD Codex Project Switcher - Help${BMAD_COLOR_NC}"
  echo -e "${BMAD_COLOR_CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${BMAD_COLOR_NC}"
  echo ""
  echo "Available commands:"
  echo ""
  echo -e "  ${BMAD_COLOR_GREEN}bmad-switch <path>${BMAD_COLOR_NC}"
  echo "    Switch to a BMAD project and rebuild Codex agents"
  echo ""
  echo -e "  ${BMAD_COLOR_GREEN}bmad-current${BMAD_COLOR_NC}"
  echo "    Show current project information"
  echo ""
  echo -e "  ${BMAD_COLOR_GREEN}bmad-verify${BMAD_COLOR_NC}"
  echo "    Verify Codex agents match current project"
  echo ""
  echo -e "  ${BMAD_COLOR_GREEN}bmad-wanelf${BMAD_COLOR_NC}"
  echo "    Quick switch to wanELF project"
  echo ""
  echo -e "  ${BMAD_COLOR_GREEN}bmad-deepagents${BMAD_COLOR_NC}"
  echo "    Quick switch to DeepAgents project"
  echo ""
  echo -e "  ${BMAD_COLOR_GREEN}bmad-help${BMAD_COLOR_NC}"
  echo "    Show this help message"
  echo ""
  echo "Configuration:"
  echo "  BMAD_METHOD_PATH = $BMAD_METHOD_PATH"
  echo ""
}

################################################################################
# Auto-verify on directory change (optional - uncomment to enable)
################################################################################

# Automatically verify when changing to a directory with BMAD
# _bmad_auto_verify() {
#   if [ -f "bmad/bmm/config.yaml" ] && [ -d "$HOME/.codex" ]; then
#     bmad-verify 2>/dev/null
#   fi
# }

# Hook into directory change (bash)
# if [ -n "$BASH_VERSION" ]; then
#   PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }_bmad_auto_verify"
# fi

# Hook into directory change (zsh)
# if [ -n "$ZSH_VERSION" ]; then
#   chpwd_functions+=(_bmad_auto_verify)
# fi

################################################################################
# Startup message
################################################################################
echo ""
echo -e "${BMAD_COLOR_CYAN}✓ BMAD Codex project switcher loaded${BMAD_COLOR_NC}"
echo -e "  Type ${BMAD_COLOR_GREEN}bmad-help${BMAD_COLOR_NC} for available commands"
echo ""
