# Documentation System Design

**Date**: 2025-11-13
**Status**: APPROVED - Implementation in progress

---

## Overview

A hybrid documentation system that balances:
- **Collaborative workflow** - Work in dialogue, not batch automation
- **Persistent context** - Agent remembers config and project state across sessions
- **Incremental documentation** - Capture work as we go, not just at end
- **Token efficiency** - Don't load unnecessary context

---

## File Structure

```
.claude/
├── PROJECT_CONTEXT.md           # Config overview and user preferences
├── SESSION_PROTOCOL.md          # Agent behavior guidelines
├── GLOBAL_SUMMARY_LOG.md        # Summary of all completed projects
├── DOCUMENTATION_SYSTEM.md      # This document (when finalized)
└── specs/
    ├── 001_neovim_second_brain/
    │   ├── PLAN.md              # Implementation plan with checkboxes
    │   ├── SESSION_LOG.md       # Detailed session-by-session work log
    │   └── SUMMARY.md           # Final summary when project complete
    ├── 002_lectic_single_party/
    │   ├── PLAN.md
    │   ├── SESSION_LOG.md
    │   └── SUMMARY.md
    └── NNN_project_name/
        ├── PLAN.md
        ├── SESSION_LOG.md
        └── SUMMARY.md (created when done)
```

---

## Core Files Explained

### `.claude/PROJECT_CONTEXT.md`
**Purpose**: Give agent complete understanding of your neovim config

**Contents**:
- What your config is (writing/publishing focused, not academic LaTeX)
- Tools you USE: Lectic (not Avante), Deckset, LazyGit, Obsidian, etc.
- Tools you DON'T use: VimTeX, Avante, NixOS, etc.
- Directory structure overview (where plugins live, etc.)
- Your workflow preferences (collaborative, incremental, review-before-action)

**Size**: ~1-2KB

**Updated**: Rarely - only when fundamental things change

---

### `.claude/SESSION_PROTOCOL.md`
**Purpose**: Define how agent should behave and document

**Contents**:
- Initialization: Always read PROJECT_CONTEXT.md and GLOBAL_SUMMARY_LOG.md first
- Collaboration style: Discuss before implementing, show changes for approval
- Documentation rules: When to update which files
- Commit protocol: When to create git commits
- Standards reference: Link to NVIM_STANDARDS.md

**Size**: ~2-3KB

**Updated**: When workflow preferences change

---

### `.claude/GLOBAL_SUMMARY_LOG.md`
**Purpose**: High-level view of all completed projects

**Detail Level**: Medium - 1-2 paragraphs per project

**Entry Format**:
```markdown
## NNN: Project Name
**Status**: Completed (YYYY-MM-DD) | In Progress | Blocked
**Problem**: What issue we were solving
**Solution**: What we built (1-2 sentences)
**Key Files**:
- file/path.lua - What changed
- another/file.lua - What changed
**Impact**: How this affects workflow/usage
**Git Commits**: commit-hash, commit-hash
```

**Example**:
```markdown
## 002: Lectic Single-Party System
**Status**: Completed (2025-11-11)
**Problem**: Multi-party Lectic conversations broken in beta6 - `:ask[PersonaName]` directive produces undefined errors.
**Solution**: Converted to single-party mode with manual persona switching via `<leader>mp` submenu. Added context link insertion with `<leader>mc`. All 12 personas accessible, frontmatter preserved.
**Key Files**:
- lua/plugins/lectic.lua - Added SwitchLecticPersona(), InsertContextLink()
- lua/plugins/which-key.lua - Added persona switching submenu
**Impact**: Can now use Lectic reliably. Workflow: create file with Homie, switch personas as needed, add context via markdown links.
**Git Commits**: 065c7c6, 1d36eeb
```

**Size**: ~5-10KB (grows as projects complete)

**Updated**: When a project completes

---

### Per-Project `PLAN.md`
**Purpose**: Implementation plan with phases and checkboxes

**Format**:
```markdown
# Project Name - Implementation Plan

**Created**: YYYY-MM-DD
**Status**: Phase N of M

## Overview
Brief description of what we're building and why.

## Phase 1: Phase Name [COMPLETED]
- [x] Task description
- [x] Another task
- [x] Final task

## Phase 2: Phase Name [IN PROGRESS]
- [x] Completed task
- [ ] Current task
- [ ] Upcoming task

## Phase 3: Phase Name
- [ ] Future task
- [ ] Another future task
```

**Rules**:
- Checkboxes NEVER deleted (shows full plan history)
- Phases marked with status: [IN PROGRESS], [COMPLETED], [BLOCKED]
- Updated at phase breaks (when completing a phase)

**Size**: ~2-5KB per project

---

### Per-Project `SESSION_LOG.md`
**Purpose**: Detailed chronological log of work sessions

**Detail Level**: High - Enough to resume work after context summarization

**Entry Format**:
```markdown
## Session N: YYYY-MM-DD - Brief Description

### Context
Why we're doing this work, what led to it, current state before starting.

### Task Batch 1: Descriptive Name
**Discussion**:
- Key decisions made
- User preferences/requirements
- Alternatives considered

**Implementation**:
- What was built (function names, file locations, line numbers if relevant)
- How it works (brief technical description)
- Key design choices

**Files Modified**:
- path/to/file.lua (lines XXX-YYY) - What changed

**Testing**: How we verified it works

**Decisions**: Important choices that affect future work

**Git Commit**: commit-hash (if committed) | [not yet]

### Task Batch 2: Next Batch
[Same format]

### Session End State
**Completed**:
- ✅ What got done this session

**Not Done**:
- ❌ What's left (if session interrupted)

**Next Session**:
- What to tackle next
- Any blockers or open questions
```

**Example** (see previous message for full example)

**Rules**:
- Updated after each approved task batch
- Captures discussions and decisions, not just code changes
- Includes "why" not just "what"
- Enough detail that agent + user can resume after weeks away

**Size**: ~10-20KB per project (grows with sessions)

---

### Per-Project `SUMMARY.md`
**Purpose**: Final retrospective when project completes

**Created**: When all phases of project are done

**Format**:
```markdown
# Project Name - Final Summary

**Completed**: YYYY-MM-DD
**Duration**: X sessions over Y days

## Overview
What was built and why (2-3 paragraphs)

## Key Decisions
Important architectural or design choices made:
- Decision 1 and rationale
- Decision 2 and rationale

## Files Modified
Complete list with brief descriptions:
- lua/plugins/xyz.lua - Added feature X
- lua/core/options.lua - Configured Y

## Implementation Highlights
Interesting technical details worth preserving:
- How we solved X problem
- Why we chose Y approach

## Testing & Verification
How we confirmed it works

## Lessons Learned
- What worked well
- What we'd do differently
- Gotchas to remember

## Git Commits
commit-hash - Message
commit-hash - Message

## References
Links to docs, issues, external resources used
```

**Size**: ~5-10KB per project

---

## Session Workflow

### 1. Session Initialization

**User says**: "Load context" or "Initialize" or "Continue project NNN"

**Agent does**:
1. Read `.claude/PROJECT_CONTEXT.md`
2. Read `.claude/GLOBAL_SUMMARY_LOG.md`
3. Read `.claude/SESSION_PROTOCOL.md`
4. If project specified: Read `specs/NNN_project/PLAN.md` and `SESSION_LOG.md`
5. Confirm what context was loaded

**Token cost**: ~15-30KB (very reasonable)

---

### 2. Collaborative Work

**User and agent**:
- Discuss approaches, brainstorm solutions
- Refine ideas together
- User approves implementation direction

**Agent behavior** (defined in SESSION_PROTOCOL.md):
- Ask questions before implementing
- Show proposed changes for approval
- Don't batch execute - work incrementally
- Check existing implementation before assuming

---

### 3. Documentation Updates

**After each approved task batch**:
- Agent updates `specs/NNN_project/SESSION_LOG.md`
- Adds new task batch entry with discussion, implementation, files modified
- User doesn't have to ask - it's automatic

**At phase breaks** (when completing a phase):
- Agent updates `specs/NNN_project/PLAN.md` (mark checkboxes)
- Agent creates git commit
- Agent updates session log with phase completion

**When project completes**:
- Agent updates `.claude/GLOBAL_SUMMARY_LOG.md` (add project entry)
- Agent creates `specs/NNN_project/SUMMARY.md` (final retrospective)
- Agent updates main `README.md` and `CHEATSHEET.md` (user-facing docs)

---

### 4. Context After Summarization

**Problem**: Conversation gets too long, Claude Code auto-summarizes, loses detail

**Solution**: Documentation persists

**Recovery**:
1. User says "Load context for project NNN"
2. Agent reads the same files as initialization
3. Agent is fully caught up from documentation

**Why this works**: High-detail SESSION_LOG.md captures everything needed to resume

---

## Token Optimization

### What Loads Automatically (Every Session)
- PROJECT_CONTEXT.md (~1-2KB)
- GLOBAL_SUMMARY_LOG.md (~5-10KB)
- SESSION_PROTOCOL.md (~2-3KB)

**Total**: ~10-15KB - Always worth it for full context

### What Loads On-Demand (When Working on Project)
- specs/NNN_project/PLAN.md (~2-5KB)
- specs/NNN_project/SESSION_LOG.md (~10-20KB per project)

**Total**: ~15-30KB for active project context

### What Doesn't Load Unless Asked
- Other projects' session logs
- Completed project summaries (unless relevant to current work)

### Why This Is Efficient
- ~30KB total context is very reasonable
- Only loads what's needed for current work
- Prevents reading all 10+ project histories every session

---

## Agent Initialization

### Manual Initialization (Chosen Approach)

**Method**: User says "init" or "load context" at session start

**Why**:
- Simple and explicit
- No hook errors or custom instruction limitations
- User has full control over when to load context
- Most reliable approach

**Custom Instructions Not Supported**: Claude Code doesn't support a `customInstructions` field in settings.json

**SessionStart Hooks Unreliable**: Attempted but caused "startup hook error" - removed from settings

---

## Simplified Commands

**Keep**:
- `/research` - Invoke research-specialist agent for deep investigation
- `/document` - Invoke doc-writer agent to update README/CHEATSHEET

**Remove** (do collaboratively instead):
- `/plan` - We write plans together in dialogue
- `/implement` - We implement together incrementally

---

## Migration Plan

### Step 1: Create Core Files
1. `.claude/PROJECT_CONTEXT.md` - Document your config
2. `.claude/SESSION_PROTOCOL.md` - Define agent behavior
3. `.claude/GLOBAL_SUMMARY_LOG.md` - Backfill completed projects
4. Update `.claude/settings.local.json` with custom instructions

### Step 2: Standardize Existing Projects
For each project in `specs/`:
- Rename/consolidate to standard structure (PLAN.md, SESSION_LOG.md, SUMMARY.md)
- Backfill missing files where possible

### Step 3: Test
- Start new session, verify context loads correctly
- Work on small project, verify documentation updates as expected
- Verify recovery after context summarization

### Step 4: Refine
- Adjust detail levels in session logs based on what's actually useful
- Tune SESSION_PROTOCOL.md based on what works

---

## Decisions Made

1. **Session log detail level**: ✅ Approved - Use format shown in examples
2. **Git commit frequency**: ✅ Every phase completion
3. **Task batch definition**: ✅ Use approval points as boundary - when user approves a set of changes, log as one batch. Special case: 5+ rapid approvals for same feature get grouped.
4. **Backfilling**: ✅ Document all existing .claude projects according to this method, purge obsolete files
5. **Initialization method**: ✅ Manual - User says "init" at session start (hooks unreliable, custom instructions not supported)

---

## Success Criteria

System is working when:
- ✅ Agent never asks "do you use X?" when it's documented in PROJECT_CONTEXT.md
- ✅ User doesn't have to say "document this" - it happens automatically
- ✅ After context summarization, agent can resume work seamlessly
- ✅ Documentation is consistent across all projects
- ✅ User trusts the system (no worry about losing work)

---

## Next Steps

1. User reviews and approves/modifies this draft
2. Create the core files (PROJECT_CONTEXT, SESSION_PROTOCOL, GLOBAL_SUMMARY_LOG)
3. Set up initialization (custom instructions or hook)
4. Test with next project
5. Refine based on what works
