---
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, TodoWrite, Task
description: Execute implementation plans with incremental documentation and git commits
---

# Implement Command

Execute implementation plans phase by phase, with testing, git commits, and incremental documentation after each phase.

## Usage

```
/implement [plan-file] [starting-phase]
```

**Examples**:
```
/implement .claude/specs/002_which_key_menus/plans/001_reorganize.md
/implement .claude/specs/002_which_key_menus/plans/001_reorganize.md 3
```

**Auto-resume**: If no arguments provided, attempts to resume most recent incomplete plan.

## Your Role

You are the implementation manager. Your job is to:
1. Load and understand the plan
2. Execute phases sequentially (or invoke code-writer agent for complex phases)
3. Test after each phase
4. Update plan checkboxes
5. Create git commits
6. Update partial summary
7. Continue until all phases complete

**CRITICAL**: Follow the plan exactly. Do NOT skip phases, tests, commits, or documentation updates.

## Workflow

### Step 0: Load Plan

1. Read the plan file from provided path
2. Parse metadata, phases, and tasks
3. Determine starting phase (argument or first incomplete phase)
4. Check if partial summary exists, create if not

### Step 1: Execute Current Phase

**For Simple Phases** (your judgment: < 50 lines, single file):
- Execute implementation yourself using Read, Write, Edit
- Follow standards from `.claude/NVIM_STANDARDS.md`
- Complete all checkbox tasks

**For Complex Phases** (multiple files, complex logic):
- Invoke code-writer agent with Task tool
- Provide phase details and tasks
- Agent returns when phase complete

```lua
Task({
  description = "Implement Phase N",
  prompt = [[
You are the code-writer agent. Implement Phase N of the plan.

**Plan File**: [path]
**Phase Number**: N
**Phase Name**: [name]
**Tasks**:
- [ ] Task 1
- [ ] Task 2

**Files to Modify**: [from plan]

**Testing**: [from plan]

Follow `.claude/agents/code-writer.md` for implementation guidelines.
Reference `.claude/NVIM_STANDARDS.md` for coding standards.

Complete all tasks, test thoroughly, report when done.
]],
  subagent_type = "general-purpose"
})
```

### Step 2: Test the Phase

Follow testing instructions from the plan:
- Manual testing (open nvim, trigger functionality)
- Check for errors (`:messages`)
- Verify expected behavior
- Run `:checkhealth` if plugin-related

**If tests fail**:
1. Read error messages carefully
2. Fix the issue
3. Re-test
4. Only proceed when tests pass

**If you cannot fix**:
- Document issue in partial summary
- Do NOT mark phase complete
- Do NOT create git commit
- Stop and report to user

### Step 3: Update Plan File

Mark tasks complete using Edit tool:

```lua
-- Change unchecked tasks to checked
Edit({
  file_path = "[plan-file]",
  old_string = "- [ ] Task description",
  new_string = "- [x] Task description"
})

-- Mark phase complete
Edit({
  file_path = "[plan-file]",
  old_string = "### Phase N: Phase Name",
  new_string = "### Phase N: Phase Name [COMPLETED]"
})
```

### Step 4: Create Git Commit

**MANDATORY** after each successful phase:

```bash
cd ~/.config/nvim

git add [modified files]

git commit -m "$(cat <<'EOF'
feat: implement Phase N - Phase Name

- Brief description of what was implemented
- Key files changed
- Testing status: PASSED

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

Capture the git commit hash:
```bash
git log -1 --format=%h
```

### Step 5: Update Partial Summary

**Location**: `.claude/specs/NNN_topic/summaries/NNN_partial.md`

**If this is Phase 1** - Create the file using Write tool with template from `.claude/docs/partial-summary-template.md`

**For subsequent phases** - Update using Edit tool:

```lua
-- Update metadata
Edit({
  file_path = "[partial-summary-path]",
  old_string = "- **Phases Completed**: M/N",
  new_string = "- **Phases Completed**: M+1/N"
})

-- Update last completed phase
Edit({
  file_path = "[partial-summary-path]",
  old_string = [[
### Last Completed Phase
- **Phase**: Phase M - Previous Name
- **Date**: YYYY-MM-DD
- **Commit**: abc123
]],
  new_string = [[
### Last Completed Phase
- **Phase**: Phase M+1 - Current Name
- **Date**: YYYY-MM-DD
- **Commit**: [git-hash-from-step-4]
]]
})

-- Update checklist
Edit({
  file_path = "[partial-summary-path]",
  old_string = "- [ ] Phase M+1: Current Name",
  new_string = "- [x] Phase M+1: Current Name"
})

-- Update resume instructions
Edit({
  file_path = "[partial-summary-path]",
  old_string = "/implement [plan-path] M+1",
  new_string = "/implement [plan-path] M+2"
})
```

Add any implementation notes if there were challenges or decisions.

### Step 6: Continue to Next Phase

If more phases remain:
1. Load next phase details
2. Go to Step 1
3. Repeat until all phases complete

### Step 7: Finalize (After Last Phase)

When ALL phases are complete:

1. Verify all success criteria from plan are met
2. Run final integration test
3. Rename partial summary:
   ```bash
   mv .claude/specs/NNN_topic/summaries/NNN_partial.md \
      .claude/specs/NNN_topic/summaries/NNN_implementation_summary.md
   ```
4. Expand summary with final sections:
   - Architecture overview
   - Complete file changes list
   - Final testing results
   - Lessons learned
5. Report completion to user

## Phase Failure Handling

### What Happens When Phase Fails

**Do NOT**:
- Mark phase as complete
- Add [COMPLETED] to phase heading
- Create git commit
- Update partial summary with completion
- Move to next phase

**DO**:
- Document the failure in partial summary notes
- Leave phase marked as incomplete
- Save current state (checkpoint if possible)
- Report issue to user with:
  - What failed
  - Error messages
  - What was attempted
  - Recommendation (fix approach or revise plan)

### Recovery After Failure

User can:
1. Fix the issue manually, then resume: `/implement [plan] N`
2. Request plan revision: `/revise [plan] "reason for change"`
3. Review implementation notes to understand what went wrong

## Examples

### Example 1: Fresh Implementation

**Command**: `/implement .claude/specs/002_which_key_menus/plans/001_reorganize.md`

**Execution**:
1. Load plan (6 phases total)
2. Create partial summary
3. Execute Phase 1 → Test → Update plan → Commit → Update summary (1/6)
4. Execute Phase 2 → Test → Update plan → Commit → Update summary (2/6)
5. ...continue...
6. Execute Phase 6 → Test → Update plan → Commit → Update summary (6/6)
7. Finalize: rename summary, add final details
8. Report: "Implementation complete: 6/6 phases"

### Example 2: Resume After Interruption

**Command**: `/implement .claude/specs/002_which_key_menus/plans/001_reorganize.md 4`

**Execution**:
1. Load plan
2. Read partial summary (shows 3/6 phases complete)
3. Start at Phase 4
4. Execute Phase 4 → Test → Update plan → Commit → Update summary (4/6)
5. Continue with Phase 5, Phase 6
6. Finalize

### Example 3: Phase Failure

**During Phase 3**:
1. Execute Phase 3 tasks
2. Run tests → FAIL (error: module not found)
3. Attempt fix → Still failing
4. Document in partial summary:
   ```markdown
   ### Challenges Encountered
   - Phase 3: Module 'xyz' not found error
   - Attempted: verified plugin installed, checked require paths
   - Status: Blocked, needs investigation
   ```
5. Do NOT mark phase complete
6. Do NOT commit
7. Report to user: "Phase 3 failed: [error details]. Recommend reviewing plugin installation."

## Safety Guidelines

### Git Commit Discipline

- **ALWAYS** commit after each phase
- **NEVER** skip commits
- **NEVER** combine multiple phases in one commit
- **ALWAYS** use structured commit message format

### Plan Adherence

- **DO** follow phases in sequential order
- **DO** complete all tasks in a phase before proceeding
- **DON'T** skip ahead
- **DON'T** add features not in the plan

**If deviation needed**:
1. Stop implementation
2. Document why in partial summary
3. Recommend `/revise` to update plan
4. Wait for approval before continuing

### Partial Summary Discipline

- **MUST** update after EVERY phase
- **MUST** include git commit hash
- **MUST** update resume instructions
- **MUST** document any deviations or challenges

This is CRITICAL - if context gets summarized mid-implementation, the partial summary is the only record of progress.

## Completion Criteria

### Per-Phase Completion

- [ ] All checkbox tasks completed
- [ ] Phase testing passed
- [ ] Plan file updated ([x] and [COMPLETED])
- [ ] Git commit created with proper format
- [ ] Partial summary updated with commit hash
- [ ] Ready for next phase (or finalization if last phase)

### Full Implementation Completion

- [ ] All phases completed (N/N)
- [ ] All success criteria met (from plan)
- [ ] All git commits created
- [ ] Partial summary renamed to implementation_summary.md
- [ ] Final summary sections added (architecture, lessons learned)
- [ ] Ready for /document command

## Reference

**Agent Documentation**: `.claude/agents/code-writer.md`

**Standards**: `.claude/NVIM_STANDARDS.md`

**Template**: `.claude/docs/partial-summary-template.md`

**Examples**: See other summaries in `.claude/specs/*/summaries/`
