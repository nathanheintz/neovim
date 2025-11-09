# Getting Started with the Claude Code Documentation System

This guide walks you through using the `.claude/` documentation system to plan, implement, and document nvim configuration changes.

## Quick Overview

The system prevents work loss through incremental documentation:

1. **Research** (optional): Investigate approaches → creates report
2. **Plan**: Design implementation → creates plan with phases
3. **Implement**: Execute plan → updates partial summary after EACH phase
4. **Document**: Update global docs → reflects current reality

## The Four Commands

### /research

**Purpose**: Investigate topics before planning

**When to use**:
- Comparing multiple approaches (which plugin, which pattern)
- Understanding best practices
- Exploring unfamiliar territory

**Example**:
```
/research "How should which-key menus be organized for writing workflows?"
```

**Output**: `.claude/specs/NNN_topic/research/001_report.md`

**What it does**:
1. Invokes research-specialist agent
2. Agent uses Read/Grep/WebSearch (NO code modification)
3. Creates structured report with findings, pros/cons, recommendations
4. Returns report path

### /plan

**Purpose**: Create detailed implementation plan

**When to use**:
- Before implementing any feature
- To break complex work into testable phases
- To get time/complexity estimates

**Example**:
```
/plan "Reorganize which-key menus based on research findings"
```

**Output**: `.claude/specs/NNN_topic/plans/001_plan.md`

**What it does**:
1. Checks for related research reports
2. Invokes plan-architect agent
3. Agent creates plan with:
   - 3-6 sequential phases
   - Checkbox tasks per phase
   - Testing requirements
   - Complexity estimate (1-10)
4. Returns plan metadata

### /implement

**Purpose**: Execute plan with incremental documentation

**When to use**:
- After creating a plan
- To resume interrupted implementation

**Example**:
```
/implement .claude/specs/002_which_key_menus/plans/001_reorganize.md
```

**Output**:
- Updated plan file (checkboxes [x], phases [COMPLETED])
- Git commits (one per phase)
- `.claude/specs/NNN_topic/summaries/NNN_partial.md` (updated after EACH phase)

**What it does**:
1. Loads plan file
2. For each phase:
   - Executes tasks (directly or via code-writer agent)
   - Runs tests
   - Updates plan checkboxes
   - Creates git commit
   - **Updates partial summary** (this is key!)
3. After all phases: renames partial → implementation_summary

**Why this matters**: If context summarizes mid-implementation, the partial summary preserves all progress (commit hashes, decisions, challenges).

### /document

**Purpose**: Update global README and CHEATSHEET

**When to use**:
- After implementation completes
- To reflect new features in user-facing docs

**Example**:
```
/document .claude/specs/002_which_key_menus/summaries/001_implementation_summary.md
```

**Output**:
- Updated `~/.config/nvim/README.md`
- Updated `~/.config/nvim/CHEATSHEET.md`
- Git commit for documentation

**What it does**:
1. Reads implementation summary
2. Invokes doc-writer agent
3. Agent updates:
   - README: Features section, plugin list
   - CHEATSHEET: Keybinding tables, workflows
4. Verifies accuracy (only documents what EXISTS)
5. Creates git commit

## Complete Workflow Example

Let's walk through reorganizing which-key menus from start to finish.

### Step 1: Research (Optional)

```
/research "Best practices for organizing which-key menus in writing-focused nvim configs"
```

**Result**: `.claude/specs/002_which_key_organization/research/001_best_practices.md`

The report might show:
- Group by workflow (writing, coding, navigation)
- Use descriptive names (WRITING vs W)
- Separate frequent from infrequent commands

### Step 2: Plan

```
/plan "Reorganize which-key menus for writing workflow based on research"
```

**Result**: `.claude/specs/002_which_key_organization/plans/001_reorganize_menus.md`

The plan might have phases:
1. Back up current which-key.lua
2. Create new menu structure skeleton
3. Migrate writing commands to <leader>w
4. Test all keybindings
5. Update documentation comments

### Step 3: Implement

```
/implement .claude/specs/002_which_key_organization/plans/001_reorganize_menus.md
```

**What happens**:

**Phase 1 completes**:
- Code changes made
- Tests pass
- Git commit: "feat: implement Phase 1 - Back up current config"
- Partial summary created:
  ```markdown
  ## Metadata
  - **Phases Completed**: 1/5

  ### Last Completed Phase
  - **Phase**: Phase 1 - Backup
  - **Commit**: abc1234

  ## Resume Instructions
  /implement .claude/specs/002_which_key_organization/plans/001_reorganize_menus.md 2
  ```

**Phase 2 completes**:
- More code changes
- Tests pass
- Git commit: "feat: implement Phase 2 - Create menu skeleton"
- Partial summary **updated**:
  ```markdown
  ## Metadata
  - **Phases Completed**: 2/5

  ### Last Completed Phase
  - **Phase**: Phase 2 - Menu skeleton
  - **Commit**: def5678
  ```

**...continues until Phase 5**

**After Phase 5**:
- All phases complete (5/5)
- Partial summary renamed to `001_implementation_summary.md`
- Final details added (architecture, lessons learned)

### Step 4: Document

```
/document .claude/specs/002_which_key_organization/summaries/001_implementation_summary.md
```

**Result**:
- README.md updated with new menu structure
- CHEATSHEET.md updated with <leader>w keybindings
- Git commit: "docs: update README and cheatsheet for which-key reorganization"

### Step 5: Verify

Open nvim and test:
- Check that keybindings work
- Verify documentation is accurate
- Confirm zen mode, Lectic, etc. still work

## Key Concepts

### Incremental Documentation

**The Problem**: Long implementations lose work when context summarizes.

**The Solution**: Partial summaries updated after EACH phase.

**How it works**:
```
Phase 1 → commit → update partial (1/5) ✅ Saved!
Phase 2 → commit → update partial (2/5) ✅ Saved!
[Context summarizes here - no work lost!]
Phase 3 → commit → update partial (3/5) ✅ Saved!
```

Each phase completion is immediately documented with git hash, so progress is never lost.

### Agent Separation

**Research/Plan Agents** (NO Edit, NO Bash):
- Can READ code
- Can WRITE new docs
- CANNOT modify existing code
- CANNOT execute commands

**Implementation Agents** (Full Access):
- Can Edit, Write, Bash
- Actually change the codebase
- Only invoked by /implement

This prevents research/planning from accidentally implementing code.

### Plans Never Delete Work

Plans track what's done with checkboxes:
```markdown
- [x] Completed task (stays visible)
- [x] Another completed task (stays visible)
- [ ] Upcoming task
```

Phases are marked:
```markdown
### Phase 1: Setup [COMPLETED]
### Phase 2: Implementation [COMPLETED]
### Phase 3: Testing
```

Only deleted if we're removing planned features (not because they're done).

## Directory Structure Reference

```
.claude/
├── commands/              # Slash commands
│   ├── research.md       # /research
│   ├── plan.md          # /plan
│   ├── implement.md     # /implement
│   └── document.md      # /document
├── agents/               # Agent behaviors
│   ├── research-specialist.md
│   ├── plan-architect.md
│   ├── code-writer.md
│   └── doc-writer.md
├── specs/               # All project documentation
│   ├── 001_topic_name/
│   │   ├── research/        # Research reports
│   │   ├── plans/           # Implementation plans
│   │   └── summaries/       # Partial & final summaries
│   └── 002_another_topic/
│       └── ...
├── docs/                # System documentation
│   ├── getting-started.md (this file)
│   ├── partial-summary-template.md
│   └── specs-organization.md
├── NVIM_STANDARDS.md    # Shared coding standards
└── README.md            # System overview
```

## Common Patterns

### Research → Plan → Implement

For complex features where you're unsure of the approach:
```bash
/research "topic"
# Review report
/plan "feature based on research"
# Review plan
/implement .claude/specs/NNN/plans/001_plan.md
# After completion
/document
```

### Plan → Implement (Skip Research)

For straightforward features with clear approach:
```bash
/plan "add feature X"
# Review plan
/implement .claude/specs/NNN/plans/001_plan.md
/document
```

### Resume Interrupted Implementation

If implementation was interrupted:
```bash
# Find where you left off
cat .claude/specs/NNN_topic/summaries/001_partial.md

# Resume from next phase
/implement .claude/specs/NNN_topic/plans/001_plan.md 3
```

The partial summary tells you exactly where to resume.

## Troubleshooting

### "No plan found"

**Problem**: Trying to implement without creating a plan.

**Solution**: Run `/plan` first to create an implementation plan.

### "Phase tests failed"

**Problem**: Code changes broke something.

**Solution**:
- Read error messages in `:messages`
- Fix the issue
- Re-run tests
- Implementation won't proceed until tests pass

### "Documentation out of sync"

**Problem**: README/CHEATSHEET don't match actual config.

**Solution**: Run `/document` to update based on latest implementation summary.

### "Lost work mid-implementation"

**Problem**: Context summarized before implementation finished.

**Solution**:
- Check partial summary: `.claude/specs/NNN_topic/summaries/001_partial.md`
- It has all progress (commit hashes, completed phases)
- Resume: `/implement [plan-path] [next-phase-number]`

## Tips

1. **Plan before coding**: Always create a plan first. It saves time and prevents mistakes.

2. **Test thoroughly**: Each phase requires testing. Don't skip it.

3. **Small phases**: 3-6 phases per plan. Each should be 30-60 minutes of work.

4. **Document as you go**: The system does this automatically via partial summaries.

5. **Review before implementing**: Read the plan carefully. If something seems wrong, revise it first.

6. **Keep standards updated**: As patterns emerge, add them to `NVIM_STANDARDS.md`.

## Next Steps

Now that you understand the system:

1. Try a simple workflow: `/plan "add a new keybinding"`
2. Review the generated plan
3. Execute it: `/implement [plan-path]`
4. Watch the partial summary update after each phase
5. Update docs: `/document`

The system is designed to prevent the frustration of losing work mid-implementation. Use it for any non-trivial changes to your nvim config!
