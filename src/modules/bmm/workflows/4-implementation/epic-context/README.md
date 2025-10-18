# Epic Context Workflow

## Purpose

Builds the reusable “epic spine” consumed by `story-context`. The workflow distills the key planning artifacts for a single epic—PRD, epics.md, tech-spec, architecture, standards, dependencies—into shared XML/Markdown outputs so every story inherits the same constraints and references.

## Outputs

- `epic-context-<epic>.xml` – machine-readable spine (doc index, constraints, tests, dependencies, coverage)
- `epic-context-<epic>.md` – human friendly summary with story coverage checklist

Both files live alongside story contexts (`{dev_story_location}`).

## Key Features

- **Auto Refresh** – Re-hashes source docs and blocks until the spine is rebuilt if anything changed.
- **Story Coverage** – Tracks whether each epic story has been “consulted” so nothing is missed.
- **Shared Baseline** – Captures constraints, testing standards, dependencies, and code baselines once per epic.
- **Locking** – Uses a lightweight lock file to prevent concurrent updates.

## Usage

```bash
# Build or refresh automatically (non-interactive)
workflow epic-context --epic_id 1 --run_mode auto

# Mark a specific story as consulted
workflow epic-context --epic_id 1 --run_mode consult --target_story_id 1.3

# Interactive checklist review
workflow epic-context --epic_id 1 --run_mode interactive --non_interactive false
```

When `story-context` runs it automatically builds/refreshes the epic spine and marks the story as consulted, blocking until the epic context is current.
