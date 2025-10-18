#!/usr/bin/env node

/**
 * Rebuild All IDEs Script for DeepAgents
 *
 * This script rebuilds agents for ALL configured IDEs:
 * - Claude Code (Cursor) - .claude/commands/
 * - Codex - .codex/
 * - GitHub Copilot - .github/copilot/
 * - Windsurf - .windsurf/
 * - And any other IDE directories found
 */

const fs = require('fs-extra');
const path = require('path');
const { YamlXmlBuilder } = require('./tools/cli/lib/yaml-xml-builder');

const builder = new YamlXmlBuilder();

// Configuration
const DEEP_AGENTS_ROOT = '/home/jpw/git/DeepAgents';
const BMAD_METHOD_ROOT = __dirname;
const SOURCE_DIR = path.join(BMAD_METHOD_ROOT, 'src');
const CONFIG_PATH = path.join(DEEP_AGENTS_ROOT, 'bmad/bmm/config.yaml');

// IDE directory patterns
const IDE_PATTERNS = [
  { name: 'Claude Code (Cursor)', path: '.claude/commands' },
  { name: 'Codex', path: '.codex/commands' },
  { name: 'GitHub Copilot', path: '.github/copilot' },
  { name: 'Windsurf', path: '.windsurf/commands' },
  { name: 'Cline', path: '.cline/commands' },
  { name: 'Roo', path: '.roo/commands' },
];

async function main() {
  console.log('━'.repeat(80));
  console.log('🔨 REBUILD ALL IDEs - DeepAgents Project');
  console.log('━'.repeat(80));
  console.log();

  // Verify DeepAgents exists
  if (!await fs.pathExists(DEEP_AGENTS_ROOT)) {
    console.error('❌ Error: DeepAgents directory not found at:', DEEP_AGENTS_ROOT);
    process.exit(1);
  }

  // Verify config exists
  if (!await fs.pathExists(CONFIG_PATH)) {
    console.error('❌ Error: Config file not found at:', CONFIG_PATH);
    console.error('   Please ensure BMAD is installed in DeepAgents');
    process.exit(1);
  }

  console.log('📂 Project root:', DEEP_AGENTS_ROOT);
  console.log('📂 BMAD source:', SOURCE_DIR);
  console.log('📄 Config file:', CONFIG_PATH);
  console.log();

  // Discover which IDEs are installed
  const installedIDEs = [];

  for (const ide of IDE_PATTERNS) {
    const idePath = path.join(DEEP_AGENTS_ROOT, ide.path);
    if (await fs.pathExists(idePath)) {
      installedIDEs.push({ ...ide, fullPath: idePath });
      console.log(`✓ Found ${ide.name} at ${ide.path}`);
    }
  }

  if (installedIDEs.length === 0) {
    console.log('⚠️  No IDE directories found. Looking for any command directories...');

    // Fallback: search for any .*/commands directories
    const entries = await fs.readdir(DEEP_AGENTS_ROOT);
    for (const entry of entries) {
      if (entry.startsWith('.') && entry !== '.' && entry !== '..') {
        const commandsPath = path.join(DEEP_AGENTS_ROOT, entry, 'commands');
        if (await fs.pathExists(commandsPath)) {
          installedIDEs.push({
            name: entry.replace('.', '').toUpperCase(),
            path: `${entry}/commands`,
            fullPath: commandsPath
          });
          console.log(`✓ Found ${entry}/commands`);
        }
      }
    }
  }

  if (installedIDEs.length === 0) {
    console.error('❌ No IDE directories found in DeepAgents project');
    console.error('   Please run BMAD install first');
    process.exit(1);
  }

  console.log();
  console.log(`Found ${installedIDEs.length} IDE(s) to rebuild`);
  console.log('━'.repeat(80));
  console.log();

  // Get all available modules
  const modulesDir = path.join(SOURCE_DIR, 'modules');
  const modules = await fs.readdir(modulesDir);

  console.log('📦 Available modules:', modules.join(', '));
  console.log();

  let totalRebuilt = 0;
  let totalErrors = 0;

  // Rebuild agents for each IDE
  for (const ide of installedIDEs) {
    console.log('━'.repeat(80));
    console.log(`🔧 Rebuilding ${ide.name}`);
    console.log('━'.repeat(80));
    console.log();

    // Find bmad directory in IDE path
    const bmadPath = path.join(ide.fullPath, 'bmad');

    if (!await fs.pathExists(bmadPath)) {
      console.log(`⚠️  No bmad directory found in ${ide.path}`);
      console.log(`   Skipping ${ide.name}`);
      console.log();
      continue;
    }

    // Process each module
    for (const module of modules) {
      const sourceAgentsDir = path.join(SOURCE_DIR, 'modules', module, 'agents');
      const targetAgentsDir = path.join(bmadPath, module, 'agents');

      // Skip if no agents in this module
      if (!await fs.pathExists(sourceAgentsDir)) {
        continue;
      }

      // Get agent YAML files
      const files = await fs.readdir(sourceAgentsDir);
      const yamlFiles = files.filter(f => f.endsWith('.agent.yaml'));

      if (yamlFiles.length === 0) {
        continue;
      }

      console.log(`  📁 Module: ${module} (${yamlFiles.length} agent(s))`);

      // Ensure target directory exists
      await fs.ensureDir(targetAgentsDir);

      // Rebuild each agent
      for (const yamlFile of yamlFiles) {
        const agentName = path.basename(yamlFile, '.agent.yaml');
        const sourcePath = path.join(sourceAgentsDir, yamlFile);
        const targetPath = path.join(targetAgentsDir, agentName + '.md');

        try {
          // Check for customization file
          const customizePath = path.join(
            DEEP_AGENTS_ROOT,
            ide.path.replace('/commands', '/_cfg/agents'),
            `${agentName}.customize.yaml`
          );

          // Also check in bmad/_cfg/agents (common location)
          const altCustomizePath = path.join(
            DEEP_AGENTS_ROOT,
            'bmad/_cfg/agents',
            `${agentName}.customize.yaml`
          );

          let finalCustomizePath = null;
          if (await fs.pathExists(customizePath)) {
            finalCustomizePath = customizePath;
          } else if (await fs.pathExists(altCustomizePath)) {
            finalCustomizePath = altCustomizePath;
          }

          // Build the agent
          await builder.buildAgent(
            sourcePath,
            finalCustomizePath,
            targetPath,
            {
              includeMetadata: true,
              projectRoot: DEEP_AGENTS_ROOT
            }
          );

          console.log(`     ✓ ${agentName}`);
          totalRebuilt++;

        } catch (error) {
          console.error(`     ❌ ${agentName}: ${error.message}`);
          totalErrors++;
        }
      }
    }

    console.log();
  }

  // Also rebuild core agents (bmad-master, etc.)
  console.log('━'.repeat(80));
  console.log('🔧 Rebuilding Core Agents');
  console.log('━'.repeat(80));
  console.log();

  const coreAgentsDir = path.join(SOURCE_DIR, 'core/agents');
  if (await fs.pathExists(coreAgentsDir)) {
    const coreFiles = await fs.readdir(coreAgentsDir);
    const coreYamlFiles = coreFiles.filter(f => f.endsWith('.agent.yaml'));

    for (const ide of installedIDEs) {
      const coreTargetDir = path.join(ide.fullPath, 'bmad/core/agents');
      await fs.ensureDir(coreTargetDir);

      for (const yamlFile of coreYamlFiles) {
        const agentName = path.basename(yamlFile, '.agent.yaml');
        const sourcePath = path.join(coreAgentsDir, yamlFile);
        const targetPath = path.join(coreTargetDir, agentName + '.md');

        try {
          await builder.buildAgent(
            sourcePath,
            null,
            targetPath,
            {
              includeMetadata: true,
              projectRoot: DEEP_AGENTS_ROOT
            }
          );

          console.log(`  ✓ ${agentName} → ${ide.name}`);
          totalRebuilt++;

        } catch (error) {
          console.error(`  ❌ ${agentName} → ${ide.name}: ${error.message}`);
          totalErrors++;
        }
      }
    }
  }

  console.log();
  console.log('━'.repeat(80));
  console.log('🔍 Verification');
  console.log('━'.repeat(80));
  console.log();

  // Verify no wanELF paths remain
  let foundWanELF = false;

  for (const ide of installedIDEs) {
    const bmadPath = path.join(ide.fullPath, 'bmad');

    if (!await fs.pathExists(bmadPath)) {
      continue;
    }

    const agentFiles = [];

    // Recursively find all .md files
    async function findMdFiles(dir) {
      const entries = await fs.readdir(dir, { withFileTypes: true });

      for (const entry of entries) {
        const fullPath = path.join(dir, entry.name);

        if (entry.isDirectory()) {
          await findMdFiles(fullPath);
        } else if (entry.name.endsWith('.md')) {
          agentFiles.push(fullPath);
        }
      }
    }

    await findMdFiles(bmadPath);

    for (const agentPath of agentFiles) {
      const content = await fs.readFile(agentPath, 'utf8');

      if (content.includes('wanELF')) {
        const relativePath = path.relative(DEEP_AGENTS_ROOT, agentPath);
        console.log(`   ⚠️  ${relativePath} still contains wanELF references`);
        foundWanELF = true;
      }
    }
  }

  if (!foundWanELF) {
    console.log('   ✓ All agents have correct DeepAgents paths');
  }

  console.log();
  console.log('━'.repeat(80));
  console.log('📊 Summary');
  console.log('━'.repeat(80));
  console.log();
  console.log(`✓ Successfully rebuilt: ${totalRebuilt} agent file(s)`);

  if (totalErrors > 0) {
    console.log(`❌ Failed to rebuild: ${totalErrors} agent file(s)`);
  }

  console.log();
  console.log('━'.repeat(80));
  console.log('✨ Next Steps');
  console.log('━'.repeat(80));
  console.log();
  console.log('1. Restart ALL your IDEs completely (not just reload)');
  console.log('2. For each IDE:');
  console.log('   - Cursor: Quit and reopen from DeepAgents directory');
  console.log('   - Codex: Restart the extension/application');
  console.log('   - Copilot: Reload VS Code window');
  console.log('3. Test an agent: @dev *help');
  console.log('4. Verify it shows "Project: DeepAgents"');
  console.log();

  process.exit(totalErrors > 0 ? 1 : 0);
}

// Run the script
main().catch(error => {
  console.error('❌ Fatal error:', error);
  console.error(error.stack);
  process.exit(1);
});
