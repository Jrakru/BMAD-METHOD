#!/usr/bin/env node

/**
 * Rebuild Agents for DeepAgents Project
 *
 * This script rebuilds all BMAD agents with correct DeepAgents paths
 * instead of hardcoded wanELF paths.
 */

const fs = require('fs-extra');
const path = require('path');
const { YamlXmlBuilder } = require('./tools/cli/lib/yaml-xml-builder');

const builder = new YamlXmlBuilder();

// Configuration
const DEEP_AGENTS_ROOT = '/home/jpw/git/DeepAgents';
const BMAD_METHOD_ROOT = __dirname;
const SOURCE_AGENTS_DIR = path.join(BMAD_METHOD_ROOT, 'src/modules/bmm/agents');
const TARGET_AGENTS_DIR = path.join(DEEP_AGENTS_ROOT, '.claude/commands/bmad/bmm/agents');
const CONFIG_PATH = path.join(DEEP_AGENTS_ROOT, 'bmad/bmm/config.yaml');

async function main() {
  console.log('🔨 Rebuilding Agents for DeepAgents Project\n');

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

  // Verify source agents exist
  if (!await fs.pathExists(SOURCE_AGENTS_DIR)) {
    console.error('❌ Error: Source agents directory not found at:', SOURCE_AGENTS_DIR);
    process.exit(1);
  }

  // Ensure target directory exists
  await fs.ensureDir(TARGET_AGENTS_DIR);

  console.log('📂 Source agents:', SOURCE_AGENTS_DIR);
  console.log('📂 Target directory:', TARGET_AGENTS_DIR);
  console.log('📄 Config file:', CONFIG_PATH);
  console.log();

  // Get all agent YAML files
  const agentFiles = await fs.readdir(SOURCE_AGENTS_DIR);
  const yamlFiles = agentFiles.filter(f => f.endsWith('.agent.yaml'));

  if (yamlFiles.length === 0) {
    console.error('❌ No agent YAML files found in source directory');
    process.exit(1);
  }

  console.log(`Found ${yamlFiles.length} agent(s) to rebuild:\n`);

  let successCount = 0;
  let errorCount = 0;

  for (const yamlFile of yamlFiles) {
    const agentName = path.basename(yamlFile, '.agent.yaml');
    const sourcePath = path.join(SOURCE_AGENTS_DIR, yamlFile);
    const targetPath = path.join(TARGET_AGENTS_DIR, agentName + '.md');

    try {
      console.log(`  Building ${agentName}...`);

      // Check for customization file in DeepAgents
      const customizePath = path.join(DEEP_AGENTS_ROOT, '.claude/_cfg/agents', `${agentName}.customize.yaml`);
      const customizeExists = await fs.pathExists(customizePath);

      if (customizeExists) {
        console.log(`    ℹ️  Using customization file: ${agentName}.customize.yaml`);
      }

      // Build the agent with DeepAgents as project root
      await builder.buildAgent(
        sourcePath,
        customizeExists ? customizePath : null,
        targetPath,
        {
          includeMetadata: true,
          projectRoot: DEEP_AGENTS_ROOT
        }
      );

      console.log(`    ✓ ${agentName} built successfully`);
      successCount++;

    } catch (error) {
      console.error(`    ❌ Error building ${agentName}:`, error.message);
      errorCount++;
    }
  }

  console.log();
  console.log('═════════════════════════════════════════');
  console.log(`✓ Successfully built: ${successCount} agent(s)`);

  if (errorCount > 0) {
    console.log(`❌ Failed to build: ${errorCount} agent(s)`);
  }

  // Verify no wanELF paths remain
  console.log();
  console.log('🔍 Verifying paths...');

  let foundWanELF = false;
  const builtAgents = await fs.readdir(TARGET_AGENTS_DIR);

  for (const file of builtAgents) {
    if (!file.endsWith('.md')) continue;

    const filePath = path.join(TARGET_AGENTS_DIR, file);
    const content = await fs.readFile(filePath, 'utf8');

    if (content.includes('wanELF')) {
      console.error(`   ⚠️  Warning: ${file} still contains wanELF references`);
      foundWanELF = true;
    }
  }

  if (!foundWanELF) {
    console.log('   ✓ All agents have correct DeepAgents paths');
  }

  console.log();
  console.log('Done! Your agents are now ready for DeepAgents project.');
  console.log();
  console.log('Next steps:');
  console.log('1. Restart your IDE (Cursor/Cline)');
  console.log('2. Test the dev agent: @dev *help');
  console.log('3. Verify it shows "Project: DeepAgents"');
  console.log();

  process.exit(errorCount > 0 ? 1 : 0);
}

// Run the script
main().catch(error => {
  console.error('❌ Fatal error:', error);
  process.exit(1);
});
