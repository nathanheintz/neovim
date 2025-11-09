---
allowed-tools: Read, Write, Edit, Grep, Glob, Task
description: Update global README and CHEATSHEET to reflect current configuration state
---

# Document Command

Update global documentation (README.md and CHEATSHEET.md) to reflect the current state of the nvim configuration after implementing features.

## Usage

```
/document [implementation-summary-path]
```

**Examples**:
```
/document .claude/specs/002_which_key_menus/summaries/001_implementation_summary.md
/document
```

**Auto-detect**: If no path provided, finds most recent implementation summary.

## Your Role

You are the documentation orchestrator. Your job is to:
1. Identify what was implemented (from summary)
2. Invoke doc-writer agent to update global documentation
3. Verify documentation accuracy
4. Report what was updated

**You do NOT write documentation yourself** - you delegate to the doc-writer agent.

## Workflow

### Step 1: Identify What Changed

**If summary path provided**:
- Read the implementation summary
- Extract: new features, plugins, keybindings, workflows

**If no path (auto-detect)**:
```bash
# Find most recent implementation summary
find .claude/specs -name "*_implementation_summary.md" -type f \
  -exec stat -f "%m %N" {} \; | sort -rn | head -1 | cut -d' ' -f2-
```

**Parse Summary for**:
- New plugins installed
- New keybindings added
- New workflows created
- Modified functionality
- Configuration changes

### Step 2: Examine Current Code

Use Read/Grep to verify what actually exists:

```lua
-- Check which-key for new keybindings
Read({ file_path = "lua/plugins/which-key.lua" })

-- Check plugin list
Glob({ pattern = "lua/plugins/*.lua" })

-- Verify specific functionality
Grep({ pattern = "pattern from summary", path = "lua/" })
```

**IMPORTANT**: Only document features that ACTUALLY EXIST in the code. Don't document plans or intentions.

### Step 3: Invoke Documentation Writer

Use Task tool to invoke doc-writer agent:

```lua
Task({
  description = "Update documentation",
  prompt = [[
You are the doc-writer agent. Update global documentation to reflect recent changes.

**Implementation Summary**: [path to summary]

**Changes to Document**:
- New features: [list from summary]
- New keybindings: [list from summary]
- New workflows: [list from summary]

**Files to Update**:
- README.md (at ~/.config/nvim/README.md)
- CHEATSHEET.md (at ~/.config/nvim/CHEATSHEET.md)

**Instructions**:
1. Read the implementation summary
2. Examine current code to verify features exist
3. Update README.md Features section
4. Update README.md Plugin List (if new plugins)
5. Update CHEATSHEET.md with new keybindings
6. Add workflow instructions if needed
7. Ensure accuracy (document CURRENT STATE only, not plans)

Follow `.claude/agents/doc-writer.md` for documentation guidelines.
Reference `.claude/NVIM_STANDARDS.md` for style standards.

Return list of files updated and changes made.
]],
  subagent_type = "general-purpose"
})
```

### Step 4: Verify Documentation

After agent completes:

1. Read updated README.md - verify accuracy
2. Read updated CHEATSHEET.md - verify keybindings match which-key
3. Check for broken links
4. Ensure no references to unimplemented features

### Step 5: Commit Documentation

Create git commit for documentation updates:

```bash
cd ~/.config/nvim

git add README.md CHEATSHEET.md

git commit -m "$(cat <<'EOF'
docs: update README and cheatsheet for [feature name]

Document new features:
- [Feature 1]
- [Feature 2]

Add keybinding documentation:
- <leader>xy commands
- [Workflow name] workflow

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Step 6: Report Completion

Report to user:

```
Documentation updated:
- README.md: Added [features]
- CHEATSHEET.md: Added [keybindings/workflows]
- Git commit: [hash]

Files verified for accuracy.
```

## Examples

### Example 1: Document After Implementation

**Command**: `/document .claude/specs/002_which_key_menus/summaries/001_implementation_summary.md`

**Execution**:
1. Read summary - extract:
   - Reorganized which-key menus
   - New <leader>w group for writing
   - Added zen mode, word count commands
2. Examine code:
   - Verify which-key.lua has new structure
   - Verify Snacks.zen() is configured
3. Invoke doc-writer with changes list
4. Verify updates:
   - README features section has "Writing Workflow"
   - CHEATSHEET has <leader>w table
5. Commit documentation
6. Report: "README and CHEATSHEET updated for which-key reorganization"

### Example 2: Auto-detect Recent Changes

**Command**: `/document`

**Execution**:
1. Find most recent summary: `.claude/specs/003_obsidian_autoload/summaries/001_implementation_summary.md`
2. Read summary - extract Obsidian auto-loading feature
3. Verify code has auto-loading
4. Invoke doc-writer
5. Update docs
6. Commit

### Example 3: Multiple Features

**Command**: `/document` (after implementing multiple features)

**Execution**:
1. Find recent summaries (maybe 2-3 recent implementations)
2. Read all summaries
3. Combine changes list
4. Invoke doc-writer with complete changes
5. Update docs comprehensively
6. Commit with detailed message

## Error Handling

### No Implementation Summary Found

**If no summary exists**:
```
No implementation summary found.

The /document command requires an implementation summary to know what to document.

Options:
1. Provide path: /document .claude/specs/NNN_topic/summaries/001_summary.md
2. Complete an implementation first: /implement [plan-file]
3. Document manually by editing README.md and CHEATSHEET.md
```

### Feature Not Actually Implemented

**If summary describes features not in code**:
```
Warning: Some features in summary don't exist in code:
- [Feature X]: Not found in expected location

Recommend:
1. Verify implementation was completed
2. Check if feature was removed
3. Update summary if it's inaccurate
4. Only document features that actually exist
```

### Documentation Already Current

**If docs already reflect changes**:
```
Documentation appears current. No updates needed.

Checked:
- README.md has [feature] documented
- CHEATSHEET.md has [keybindings] documented

If documentation is incorrect, manually edit or provide specific changes.
```

## Quality Standards

### README.md Updates

**Do Document**:
- New features and capabilities
- New plugins (with brief purpose)
- Significant configuration decisions
- Installation requirements (if changed)

**Don't Document**:
- Implementation details (that's for code comments)
- How to use features (that's for CHEATSHEET)
- Future plans (that's for plan files)
- Change history (that's for git log)

### CHEATSHEET.md Updates

**Do Document**:
- All new custom keybindings
- New workflows with step-by-step instructions
- Non-obvious features
- Common tasks

**Don't Document**:
- Built-in vim commands
- Every possible keybinding (focus on custom)
- Implementation internals

### Style Requirements

**From NVIM_STANDARDS.md**:
- Present tense ("provides", not "will provide")
- No temporal markers ("now supports" → "supports")
- No emojis
- UTF-8 encoding only
- Keep tables formatted
- Test keybindings before documenting

## Safety Guidelines

### Accuracy is Critical

- Only document features that EXIST
- Verify keybindings in actual config
- Test complex workflows
- Check plugin names/versions
- Validate file paths in examples

### Non-Destructive Updates

- Preserve existing valid documentation
- Don't delete entire sections unnecessarily
- Improve clarity without changing meaning
- Maintain consistent formatting

### Synchronization

- README and CHEATSHEET must match reality
- Remove documentation for removed features
- Update when keybindings change
- Keep plugin list current

## Completion Criteria

Documentation is complete when:
- [ ] Doc-writer agent invoked successfully
- [ ] README.md updated with new features
- [ ] CHEATSHEET.md updated with new keybindings/workflows
- [ ] Documentation verified for accuracy
- [ ] No broken links or incorrect paths
- [ ] No references to unimplemented features
- [ ] Git commit created
- [ ] User notified of updates

## Reference

**Agent Documentation**: `.claude/agents/doc-writer.md`

**Standards**: `.claude/NVIM_STANDARDS.md`

**Current Docs**:
- `~/.config/nvim/README.md`
- `~/.config/nvim/CHEATSHEET.md`
