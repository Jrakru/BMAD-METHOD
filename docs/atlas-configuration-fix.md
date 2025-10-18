---
title: Atlas Configuration Fix - Clarifying Workspace vs Reference Library
version: 6.0-alpha
date: 2025-01-XX
status: Proposed Fix
---

# Atlas Configuration Fix Proposal

## Problem Statement

The Atlas agent workflows have confusing and inconsistent variable naming for directory paths. Specifically:

### Current Issues

1. **Confusing naming**: `architecture_starter_pack_dir` implies temporary/bootstrap usage, but it's actually a permanent reference library
2. **Inconsistent usage**: Some workflows use `c4d5_root` pointing to starter pack, others use `project_docs_root` pointing to workspace
3. **Mixed purposes**: Variables conflate two distinct concepts:
   - **Reference Library**: Templates, guidelines, documentation ABOUT how to use C4/D5 (readonly, shared)
   - **Project Workspace**: Actual project's C4/D5 documentation (read/write, project-specific)

### Current Variable Usage

```yaml
# In workflows - CURRENT (PROBLEMATIC):
variables:
  c4d5_root: "{config_source}:architecture_starter_pack_dir"  # WRONG - should be project docs
  likec4_model_dir: "{c4d5_root}/likec4/model"                # WRONG - reads from starter pack
  
# In other workflows - CURRENT (CORRECT):
variables:
  project_docs_root: "{config_source}:architecture_workspace_root"  # CORRECT
  starter_pack_root: "{config_source}:architecture_starter_pack_dir"  # CORRECT
  likec4_model_dir: "{project_docs_root}/likec4/model"               # CORRECT
  templates_dir: "{starter_pack_root}/templates"                     # CORRECT
```

## Proposed Solution

### 1. Rename Configuration Variables

**In `bmad/bmm/config.yaml`**:

```yaml
# OLD (confusing):
architecture_workspace_root: "./docs/architecture"
architecture_starter_pack_dir: "./docs/architecture/1C4D5-Starter-Pack"

# NEW (clear):
architecture_workspace: "./docs/architecture"           # Where project C4/D5 docs live
c4d5_reference_library: "./bmad/bmm/c4d5-reference"    # Templates & guidelines (part of BMAD)
```

### 2. Standardize Workflow Variables

**All workflows should use**:

```yaml
variables:
  # Project-specific documentation workspace (read/write)
  architecture_workspace: "{config_source}:architecture_workspace"
  
  # Reference library for templates and guidelines (readonly)
  c4d5_reference: "{config_source}:c4d5_reference_library"
  
  # Derived paths - PROJECT workspace
  likec4_model_dir: "{architecture_workspace}/likec4/model"
  likec4_views_file: "{architecture_workspace}/likec4/views/views.c4"
  docs_dir: "{architecture_workspace}/docs"
  journal_dir: "{docs_dir}/journal"
  specification_file: "{architecture_workspace}/likec4/specification.c4"
  
  # Derived paths - REFERENCE library
  templates_dir: "{c4d5_reference}/templates"
  guidelines_dir: "{c4d5_reference}/docs"
  modeling_guidelines: "{guidelines_dir}/Modeling-Guidelines.md"
  view_catalog: "{guidelines_dir}/View-Catalog.md"
```

## Detailed Changes Required

### Configuration File

**File**: `bmad/bmm/config.yaml`

```yaml
# Architecture Documentation Settings
architecture_workspace: "./docs/architecture"
c4d5_reference_library: "./bmad/bmm/c4d5-reference"

# Alternative if reference library is external:
# c4d5_reference_library: "/path/to/shared/c4d5-reference"
```

### Workflow Files to Update

#### 1. init-diagram/workflow.yaml

```yaml
variables:
  architecture_workspace: "{config_source}:architecture_workspace"
  c4d5_reference: "{config_source}:c4d5_reference_library"
  
  # Project workspace paths
  likec4_model_dir: "{architecture_workspace}/likec4/model"
  likec4_views_file: "{architecture_workspace}/likec4/views/views.c4"
  docs_dir: "{architecture_workspace}/docs"
  change_log_file: "{docs_dir}/Change-Log.md"
  specification_file: "{architecture_workspace}/likec4/specification.c4"
  init_output_dir: "{docs_dir}/journal"
  
  # Reference library paths
  templates_dir: "{c4d5_reference}/templates"
  overview_template: "{templates_dir}/docs/overview.md.tmpl"
  journal_template: "{templates_dir}/docs/journal-entry.md.tmpl"
  change_log_template: "{templates_dir}/docs/change-log-entry.md.tmpl"
  modeling_guidelines: "{c4d5_reference}/docs/Modeling-Guidelines.md"
  view_catalog: "{c4d5_reference}/docs/View-Catalog.md"
  troubleshooting: "{c4d5_reference}/docs/Troubleshooting.md"
  
  # Other
  code_tools_script: "{project-root}/scripts/run_code_tools_summary.py"
  runtime_dir: "{config_source}:runtime_dir"
  tests_dir: "{config_source}:tests_dir"

recommended_inputs:
  - "{modeling_guidelines}"
  - "{view_catalog}"
  - "{troubleshooting}"
```

#### 2. update-diagram/workflow.yaml

```yaml
variables:
  architecture_workspace: "{config_source}:architecture_workspace"
  c4d5_reference: "{config_source}:c4d5_reference_library"
  
  # Project workspace paths
  likec4_model_dir: "{architecture_workspace}/likec4/model"
  likec4_views_file: "{architecture_workspace}/likec4/views/views.c4"
  docs_dir: "{architecture_workspace}/docs"
  change_log_file: "{docs_dir}/Change-Log.md"
  journal_dir: "{docs_dir}/journal"
  specification_file: "{architecture_workspace}/likec4/specification.c4"
  
  # Reference library paths
  templates_dir: "{c4d5_reference}/templates"
  journal_template: "{templates_dir}/docs/journal-entry.md.tmpl"
  modeling_guidelines: "{c4d5_reference}/docs/Modeling-Guidelines.md"
  view_catalog: "{c4d5_reference}/docs/View-Catalog.md"
  
  # Other
  code_tools_script: "{project-root}/scripts/run_code_tools_summary.py"

recommended_inputs:
  - "{modeling_guidelines}"
  - "{view_catalog}"
```

#### 3. audit-data-flow/workflow.yaml

**BEFORE (INCORRECT)**:
```yaml
variables:
  c4d5_root: "{config_source}:architecture_starter_pack_dir"  # WRONG!
  likec4_model_dir: "{c4d5_root}/likec4/model"                # Reads from reference library!
  likec4_templates: "{c4d5_root}/templates"
```

**AFTER (CORRECT)**:
```yaml
variables:
  architecture_workspace: "{config_source}:architecture_workspace"
  c4d5_reference: "{config_source}:c4d5_reference_library"
  
  # Project workspace paths - where actual project docs are
  likec4_model_dir: "{architecture_workspace}/likec4/model"
  
  # Reference library paths - templates only
  templates_dir: "{c4d5_reference}/templates"
  
  # Output
  audit_output_dir: "{output_folder}/1c4d5"
  code_tools_script: "{project-root}/scripts/run_code_tools_summary.py"
```

#### 4. impact-summary/workflow.yaml

**BEFORE (INCORRECT)**:
```yaml
variables:
  c4d5_root: "{config_source}:architecture_starter_pack_dir"  # WRONG!
  likec4_model_dir: "{c4d5_root}/likec4/model"
  docs_dir: "{c4d5_root}/docs"
```

**AFTER (CORRECT)**:
```yaml
variables:
  architecture_workspace: "{config_source}:architecture_workspace"
  c4d5_reference: "{config_source}:c4d5_reference_library"
  
  # Project workspace paths
  likec4_model_dir: "{architecture_workspace}/likec4/model"
  docs_dir: "{architecture_workspace}/docs"
  
  # Output
  summary_output_dir: "{output_folder}/1c4d5"
  code_tools_script: "{project-root}/scripts/run_code_tools_summary.py"
```

#### 5. consistency-scan/workflow.yaml

**BEFORE (INCORRECT)**:
```yaml
variables:
  c4d5_root: "{config_source}:architecture_starter_pack_dir"  # WRONG!
  likec4_model_dir: "{c4d5_root}/likec4/model"
```

**AFTER (CORRECT)**:
```yaml
variables:
  architecture_workspace: "{config_source}:architecture_workspace"
  c4d5_reference: "{config_source}:c4d5_reference_library"
  
  # Project workspace paths
  likec4_model_dir: "{architecture_workspace}/likec4/model"
  docs_dir: "{architecture_workspace}/docs"
  
  # Reference library
  modeling_guidelines: "{c4d5_reference}/docs/Modeling-Guidelines.md"
  
  # Output
  scan_output_dir: "{output_folder}/1c4d5"
  code_tools_script: "{project-root}/scripts/run_code_tools_summary.py"
```

#### 6. validate-likec4/workflow.yaml

**BEFORE (INCORRECT)**:
```yaml
variables:
  c4d5_root: "{config_source}:architecture_starter_pack_dir"  # WRONG!
  likec4_model_dir: "{c4d5_root}/likec4/model"
```

**AFTER (CORRECT)**:
```yaml
variables:
  architecture_workspace: "{config_source}:architecture_workspace"
  c4d5_reference: "{config_source}:c4d5_reference_library"
  
  # Project workspace paths
  likec4_model_dir: "{architecture_workspace}/likec4/model"
  likec4_views_file: "{architecture_workspace}/likec4/views/views.c4"
  
  # Output
  validation_output_dir: "{output_folder}/1c4d5"
  validation_script: "{project-root}/scripts/run_likec4_validation.sh"
```

### Atlas Agent Critical Actions

**File**: `atlas.agent.yaml`

```yaml
critical_actions:
  - "Load into memory {project-root}/bmad/bmm/config.yaml and set variable project_name, output_folder, user_name, communication_language, architecture_workspace"
  - "Remember the users name is {user_name}"
  - "ALWAYS communicate in {communication_language}"
  - "Resolve architecture workspace from architecture_workspace and keep file operations scoped there unless user explicitly authorizes other paths"
  - "Prefer code_tools MCP for repository mapping; read source files directly only when code_tools cannot supply required detail"
  - "Capture change rationale and return review-ready summary to architect before completing any request"
```

## Directory Structure After Fix

```
project/
├── bmad/
│   ├── bmm/
│   │   ├── config.yaml                        # Contains architecture_workspace path
│   │   └── c4d5-reference/                    # Reference library (part of BMAD installation)
│   │       ├── templates/
│   │       │   ├── docs/
│   │       │   │   ├── overview.md.tmpl
│   │       │   │   ├── journal-entry.md.tmpl
│   │       │   │   └── change-log-entry.md.tmpl
│   │       │   └── likec4/
│   │       │       └── (various .c4 templates)
│   │       ├── docs/
│   │       │   ├── Modeling-Guidelines.md
│   │       │   ├── View-Catalog.md
│   │       │   └── Troubleshooting.md
│   │       └── likec4/
│   │           └── views/
│   │               └── views.c4.tmpl
│   └── ...
├── docs/
│   └── architecture/                          # Project's architecture workspace
│       ├── likec4/
│       │   ├── model/                         # Project's .c4 files (CREATED BY ATLAS)
│       │   │   ├── system-a.c4
│       │   │   └── system-b.c4
│       │   └── views/
│       │       └── views.c4                   # Project's views (CREATED BY ATLAS)
│       └── docs/
│           ├── journal/                       # Project's journal entries
│           ├── Change-Log.md                  # Project's change log
│           └── system-a-overview.md           # Project's overviews
└── ...
```

## Benefits of This Fix

### 1. Clear Separation of Concerns

- **Reference Library** (`c4d5_reference_library`): Templates and guidelines (readonly, shared, part of BMAD)
- **Project Workspace** (`architecture_workspace`): Actual project documentation (read/write, project-specific)

### 2. Intuitive Naming

- `architecture_workspace` - Clear that this is where work happens
- `c4d5_reference_library` - Clear that this is reference material, not a "starter pack"

### 3. Correct Behavior

- Workflows read project docs from project workspace
- Workflows read templates/guidelines from reference library
- No confusion about where files should be read from or written to

### 4. Scalability

- Reference library can be shared across multiple projects
- Reference library can be versioned with BMAD releases
- Projects can have independent architecture documentation

## Migration Path

### For Existing Users

1. **Update config.yaml**:
   ```yaml
   # Add new variables
   architecture_workspace: "./docs/architecture"
   c4d5_reference_library: "./bmad/bmm/c4d5-reference"
   
   # Optionally keep old variables for backward compatibility (deprecated)
   # architecture_workspace_root: "./docs/architecture"  # DEPRECATED
   # architecture_starter_pack_dir: "./bmad/bmm/c4d5-reference"  # DEPRECATED
   ```

2. **Move reference materials** (if needed):
   ```bash
   # If you have a local "starter pack" in your docs folder
   mv docs/architecture/1C4D5-Starter-Pack bmad/bmm/c4d5-reference
   ```

3. **Update workflows** (BMAD will ship with updated workflows)

4. **No changes needed to existing project documentation**

### For New Users

Simply use the new configuration variables - everything will work correctly from the start.

## Testing Checklist

After implementing this fix:

- [ ] `*init-diagram` creates files in `{architecture_workspace}`, not reference library
- [ ] `*init-diagram` reads templates from `{c4d5_reference_library}`
- [ ] `*update-diagram` updates files in `{architecture_workspace}`
- [ ] `*audit-data-flow` reads models from `{architecture_workspace}/likec4/model`
- [ ] `*impact-summary` reads models from `{architecture_workspace}/likec4/model`
- [ ] `*consistency-scan` scans `{architecture_workspace}`, uses guidelines from `{c4d5_reference_library}`
- [ ] `*validate-likec4` validates models in `{architecture_workspace}/likec4/model`
- [ ] All workflows respect workspace scoping
- [ ] Reference library can be shared across projects
- [ ] Configuration is clear and intuitive

## Summary

This fix resolves the confusion between:
- **What Atlas creates/maintains** (project workspace)
- **What Atlas references** (C4/D5 reference library)

The new naming clearly communicates purpose and prevents incorrect path usage in workflows.

---

**Status**: Ready for implementation  
**Impact**: Breaking change for existing Atlas users (requires config update)  
**Priority**: High (correctness issue)