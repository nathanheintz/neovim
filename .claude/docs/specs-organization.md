# Specs Directory Organization

## Numbering Convention

Each project gets a numbered directory following the pattern:

```
NNN_descriptive_topic_name/
```

Where:
- `NNN` = Three-digit sequential number (001, 002, 003, ...)
- `descriptive_topic_name` = Brief, snake_case description

## Examples

```
specs/
├── 001_claude_system_setup/
├── 002_which_key_menus/
├── 003_obsidian_integration/
├── 004_lectic_personas/
└── 005_ghost_theme_workflow/
```

## Project Structure

Each numbered directory contains:

```
NNN_topic_name/
├── plans/
│   ├── 001_initial_plan.md
│   └── 002_revised_plan.md (if needed)
├── research/ (optional)
│   └── 001_research_report.md
└── summaries/
    ├── 001_partial.md (during implementation)
    └── 001_implementation_summary.md (when complete)
```

## File Naming Within Projects

**Plans**: `NNN_descriptive_plan_name.md`
- `001_which_key_reorganization.md`
- `002_add_obsidian_commands.md`

**Research**: `NNN_descriptive_research_name.md`
- `001_which_key_best_practices.md`
- `002_obsidian_completion_investigation.md`

**Summaries**: `NNN_partial.md` during work, renamed to `NNN_implementation_summary.md` when complete
- `001_partial.md` → `001_implementation_summary.md`

## Finding Projects

**Current Work**:
```bash
find .claude/specs -name "*partial.md"
```

**Completed Work**:
```bash
find .claude/specs -name "*implementation_summary.md"
```

**All Plans**:
```bash
find .claude/specs -path "*/plans/*.md"
```

## Chronological Record

The numbering creates a searchable timeline:
- `001_*` = First project
- `002_*` = Second project
- etc.

This makes it easy to:
- Find work by topic (grep the names)
- See project order (sort by number)
- Understand project evolution (read summaries in sequence)

## When to Create New Numbers

**Create a new NNN directory when**:
- Starting a distinct feature or improvement
- Research leads to a new implementation direction
- Revising a previous project significantly

**Reuse existing NNN directory when**:
- Adding phases to existing plan
- Creating revised plan for same feature
- Adding supplemental research for ongoing work

## Archive (Future)

When the specs directory gets large, completed projects can be moved to:
```
specs/archive/YYYY/NNN_topic_name/
```

But keep the numbering for reference purposes.
