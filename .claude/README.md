# Claude Code Documentation System

This directory contains a structured workflow system for Claude Code that prevents work loss through incremental documentation and proper separation of concerns.

## Quick Start

### Running Commands

Use slash commands to invoke workflows:

- `/research <topic>` - Create research reports before planning
- `/plan <feature>` - Create structured implementation plans
- `/implement [plan-file]` - Execute plans with incremental documentation
- `/document` - Update global README and cheatsheet

### Directory Structure

```
.claude/
├── commands/          # Slash command definitions
│   ├── research.md
│   ├── plan.md
│   ├── implement.md
│   └── document.md
├── agents/            # Specialized AI behavioral files
│   ├── research-specialist.md
│   ├── plan-architect.md
│   ├── code-writer.md
│   └── doc-writer.md
├── specs/             # Project documentation
│   └── NNN_topic_name/
│       ├── plans/         # Implementation plans
│       ├── research/      # Research reports (optional)
│       └── summaries/     # Implementation summaries
├── docs/              # System documentation
└── NVIM_STANDARDS.md  # Shared coding/doc standards
```

## Core Concepts

### Specs Numbering Convention

Each project gets a numbered directory:
- `001_claude_system_setup/`
- `002_which_key_menus/`
- `003_lectic_personas/`

This creates a chronological, searchable record of all work.

### Incremental Documentation

Unlike conversation-based work that gets lost when context summarizes:

1. **Research Phase**: Creates reports in `specs/NNN_topic/research/`
2. **Planning Phase**: Creates plan with checkboxes in `specs/NNN_topic/plans/`
3. **Implementation Phase**: Updates `specs/NNN_topic/summaries/NNN_partial.md` after EACH phase
4. **Documentation Phase**: Updates global `README.md` and `CHEATSHEET.md`

### Agent Separation via Tool Restrictions

**Research & Planning Agents** (NO Edit, NO Bash):
- Can only READ code and WRITE documentation
- Cannot modify existing code
- Cannot execute commands

**Implementation Agents** (Full Access):
- Can Edit, Write, Execute
- Follows plans created by planning agents

This prevents research/planning from accidentally implementing code.

## Workflow Example

### 1. Research (Optional)
```
/research "How should which-key menus be organized?"
```

Creates: `specs/002_which_key_menus/research/001_report.md`

### 2. Plan
```
/plan "Reorganize which-key menus for writing workflow"
```

Creates: `specs/002_which_key_menus/plans/001_which_key_plan.md`

### 3. Implement
```
/implement specs/002_which_key_menus/plans/001_which_key_plan.md
```

- Executes Phase 1 → Git commit → Updates partial summary
- Executes Phase 2 → Git commit → Updates partial summary
- ...continues until complete
- Renames `001_partial.md` to `001_implementation_summary.md`

### 4. Document
```
/document
```

Updates:
- `~/.config/nvim/README.md` (adds new features)
- `~/.config/nvim/CHEATSHEET.md` (adds new keybindings)

## Key Files

### In Each Project

**Plan File** (`specs/NNN_topic/plans/NNN_plan.md`):
- Phases with checkboxes: `- [ ]` becomes `- [x]`
- Checkboxes never deleted (shows full plan)
- Phases marked: `### Phase 1: Setup [COMPLETED]`

**Partial Summary** (`specs/NNN_topic/summaries/NNN_partial.md`):
- Updated after EACH phase completes
- Contains: last completed phase, git commit, resume instructions
- Prevents work loss if context summarizes mid-implementation

**Implementation Summary** (`specs/NNN_topic/summaries/NNN_summary.md`):
- Final retrospective when all phases complete
- Includes: metadata, architecture, decisions, lessons learned
- Created by renaming and expanding partial summary

### Global Files

**README.md** (project root):
- Current state of the nvim config
- What plugins/features exist NOW
- Updated by `/document` command

**CHEATSHEET.md** (project root):
- How to use the features
- Keybindings, commands, workflows
- Updated by `/document` command

**NVIM_STANDARDS.md** (.claude directory):
- Shared coding standards
- Documentation conventions
- Referenced by all commands

## Safety Features

1. **Tool Restrictions**: Research/plan agents can't modify code
2. **Incremental Saves**: Partial summaries prevent work loss
3. **Git Commits**: Each phase creates a commit (rollback points)
4. **Checkboxes Preserved**: Plans never delete completed work
5. **Current State Docs**: README reflects reality, not future plans

## Differences from Ben's System

**What We Kept**:
- Incremental documentation (partial summaries)
- Agent tool restrictions
- Reference-based standards (NVIM_STANDARDS.md)
- Numbered spec directories

**What We Simplified**:
- 4 agents instead of 19
- 4 commands instead of 15+
- No hooks/metrics/TTS
- No template system (yet)
- No orchestration complexity

**Why**: Start minimal, expand only as needed for our writing/publishing workflow.

## Getting Help

- See `docs/getting-started.md` for detailed command usage
- See `NVIM_STANDARDS.md` for coding conventions
- Check existing specs for examples of plans/summaries
