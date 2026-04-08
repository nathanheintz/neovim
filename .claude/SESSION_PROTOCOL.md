# Session Protocol

**Purpose**: Define how Claude Code agent should document work in the nvim config repo

**Last Updated**: 2026-04-07

> Universal behavior rules (collaborative style, verification protocol, communication style)
> are in ~/.claude/BEHAVIOR.md, loaded globally at every session start.
> This file covers nvim-specific documentation, git protocol, and coding standards only.

---

## .claude Directory Structure

```
.claude/
├── PROJECT_CONTEXT.md         # Config overview, tools, preferences
├── SESSION_PROTOCOL.md         # This file - nvim-specific documentation rules
├── GLOBAL_SUMMARY_LOG.md       # All completed projects history
├── NVIM_STANDARDS.md           # Shared coding/doc standards
├── settings.local.json         # Claude Code settings
│
├── agents/                     # Specialized agent behavioral files
│   └── research-specialist.md  # Research agent
│
└── specs/                      # Project documentation
    ├── 000_maintenance_debug/  # Ongoing maintenance & small fixes
    │   ├── MAINTENANCE_LOG.md  # Log of small tasks (no PLAN needed)
    │   └── bug-reports/        # All bug documentation goes here
    │       └── YYYYMMDD_bug_name.md
    │
    ├── NNN_project_name/       # Numbered project directories
    │   ├── PLAN.md             # Implementation plan with phases
    │   ├── SESSION_LOG.md      # Detailed work history
    │   └── SUMMARY.md          # Final retrospective (when complete)
    │
    └── ...                     # Additional projects (001, 002, etc.)
```

**Key Locations**:
- Bug reports: `specs/000_maintenance_debug/bug-reports/`
- Small fixes: `specs/000_maintenance_debug/MAINTENANCE_LOG.md`
- Major features: Their own numbered project (001, 002, etc.)

---

## Session Initialization

### At Start of Every New Session

Run `/init` (global skill — works from any CWD) to load full workspace context.

For nvim-specific sessions, also read:

1. **Core context files**:
   - `.claude/PROJECT_CONTEXT.md` — Understand the config
   - `.claude/GLOBAL_SUMMARY_LOG.md` — See all completed projects

2. **If project specified, also read**:
   - `.claude/specs/NNN_project/PLAN.md` — Current implementation plan
   - `.claude/specs/NNN_project/SESSION_LOG.md` — Detailed work history

3. **Confirm context loaded**:
   - Tell user what you read
   - Summarize current project state if working on one
   - Ask how to proceed

**Token cost**: ~15-30KB total (very reasonable for full context)

---

## Documentation Rules

### Small Maintenance Tasks

**When user requests small fixes, tweaks, or debugging**:

1. **Suggest documenting in maintenance log**:
   - "This looks like a maintenance task. Should I document this in the maintenance log after we're done?"

2. **After completing the work**, update `specs/000_maintenance_debug/MAINTENANCE_LOG.md`:
   ```markdown
   ### YYYY-MM-DD - Brief Task Description

   **Task**: What was done

   **Changes**:
   - File modified (line numbers if relevant)
   - What changed and why

   **Commit**: [hash if applicable]
   ```

3. **For bugs**, also create a bug report in `specs/000_maintenance_debug/bug-reports/YYYYMMDD_bug_name.md`

**Examples of maintenance tasks**:
- Fixing a keybinding
- Adjusting a color or style
- Debugging an error
- Small config tweaks
- Cleanup tasks

**NOT maintenance tasks** (need full project):
- New features
- Major refactors
- Multi-file changes

---

### After Each Approved Task Batch

**For major features**, automatically update `.claude/specs/NNN_project/SESSION_LOG.md`:

**Format**:
```markdown
### Task Batch N: Descriptive Name
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
```

**Rules**:
- User doesn't have to ask — it's automatic
- Update immediately after approval
- Capture "why" not just "what"
- Include enough detail to resume work after weeks away

### What Constitutes a Task Batch

A task batch is approved changes that form a logical unit:

**Boundaries**:
- User approves a set of changes → Log as one batch
- Typically 1-5 file changes that work together
- 10-30 minutes of focused work
- One feature/fix in working state

**Special case**: 5+ rapid approvals for same feature → Group as one batch

**Examples**:
- ✅ "Added persona switching function + updated which-key menu"
- ❌ "Fixed typo" (too small — group with larger work)
- ❌ "Implemented entire Phase 2" (too large — split into multiple batches)

### At Phase Breaks

When completing a phase of the plan:

1. **Update** `.claude/specs/NNN_project/PLAN.md`:
   - Mark checkboxes complete: `- [ ]` → `- [x]`
   - Mark phase status: `## Phase N [COMPLETED]`
   - NEVER delete checkboxes (preserves full plan history)

2. **Update** `.claude/specs/NNN_project/SESSION_LOG.md`:
   - Add session end state
   - List completed items
   - Note what's next

3. **Create git commit**:
   - Meaningful commit message
   - Reference phase completed

**Commit format**:
```
feat: brief description of phase work

Detailed description if needed:
- Change 1
- Change 2
```

### When Project Completes

After all phases done:

1. **Update** `.claude/GLOBAL_SUMMARY_LOG.md`:
   - Add project entry with medium detail
   - Include problem, solution, key files, impact, commits

2. **Create** `.claude/specs/NNN_project/SUMMARY.md`:
   - Final retrospective
   - Overview, key decisions, files modified, lessons learned

3. **Update** main config documentation:
   - `README.md` — Add new features to appropriate sections
   - `CHEATSHEET.md` — Add new keybindings/commands

4. **Final git commit** for documentation updates

---

## Understand Broader Context

**Before making changes**:
- How does this fit into the overall config?
- Are there related features that might be affected?
- Is there a better place for this code?
- Does this follow existing patterns?

**Reference documentation**:
- PROJECT_CONTEXT.md for config overview
- NVIM_STANDARDS.md for coding conventions
- GLOBAL_SUMMARY_LOG.md for past work
- which-key.lua for keybinding organization

---

## Standards & Conventions

### Follow NVIM_STANDARDS.md

**Code style**:
- 2-space indentation (tabs converted to spaces)
- Descriptive variable/function names
- Comments for complex logic
- Local functions when possible

**File organization**:
- Plugins in `lua/plugins/`
- Core config in `lua/core/`
- Filetype-specific in `after/ftplugin/`

**Which-key conventions**:
- Group names in CAPS: "WINDOW", "CODE", "MARKDOWN & WRITING"
- Descriptive keybinding descriptions (lowercase)
- Icons where appropriate
- Logical menu organization

### Documentation Standards

**Code comments**:
- Explain why, not what
- Document non-obvious behavior
- Add comments for keybindings

**Session logs**:
- Use markdown headers and lists
- Include code blocks with language tags
- Keep entries chronological
- Be specific about file locations and line numbers

**Git commits**:
- Start with type: feat, fix, chore, docs, refactor
- Brief (50 char) summary line
- Detailed body if needed

---

## Git Commit Protocol

### Frequency

**Create commits**:
- ✅ At phase breaks (when completing a phase)
- ❌ NOT after every single edit
- ❌ NOT automatically without phase completion

### Before Committing

**ALWAYS**:
1. Run `git status` to see what's staged
2. Run `git diff` to see changes
3. Review changes match what was implemented
4. Check commit message accurately describes work

**NEVER**:
- Commit files with secrets (.env, credentials)
- Use `--amend` (unless user explicitly requests)
- Force push to main/master
- Skip hooks (--no-verify)

### Commit Message Quality

**Good commit messages**:
- Start with type (feat, fix, chore, docs)
- Summarize the "why" not just "what"
- Include bullet points for multi-part changes
- Reference phase completed

**NEVER include**:
- Co-Authored-By: Claude line (user retains full authorship)
- Claude Code footer or attribution
- Any AI assistant credits or references

---

## File Organization

### Where Things Live

**Keybindings**: `lua/plugins/which-key.lua` (ALL leader-key bindings)
**Non-leader keys**: `lua/core/keymaps.lua`
**Plugin configs**: `lua/plugins/*.lua` (one file per plugin usually)
**LSP configs**: `lua/plugins/lsp/`
**Core settings**: `lua/core/options.lua`
**Functions**: `lua/core/functions.lua`
**Snippets**: `snippets/*.snippets`
**Templates**: `templates/`

**Don't create files in wrong locations** — check existing structure first.

---

## Special Cases

### Which-Key Kitty Terminal Bug

**Known issue**: Space in which-key submenus triggers bug (see `.claude/bug-reports/`)
**Fix applied**: Auto-patch in `lua/plugins/which-key.lua` treats Space as Escape
**Remember**: This patch exists when debugging which-key issues

### Lectic Multi-Party

**Status**: Broken in beta6, disabled in config
**Mode**: Single-party only with manual persona switching
**Don't suggest**: Multi-party features or `:ask[Name]` directives

### Completion Toggles

**Buffer completion**: OFF by default in markdown files
**Reason**: Reduces noise while writing
**Toggles exist**: User can enable/disable as needed

---

## Success Indicators

You're following protocol well when:
- ✅ User doesn't have to remind you to document
- ✅ You never ask questions answered in PROJECT_CONTEXT.md
- ✅ Session logs have enough detail to resume work
- ✅ Git commits happen at appropriate times
- ✅ User trusts you to handle documentation automatically
- ✅ Work progresses collaboratively without friction

---

## Quick Reference

**Every session start**: Run `/init`, then read PROJECT_CONTEXT.md and GLOBAL_SUMMARY_LOG.md
**After each approved batch**: Update SESSION_LOG.md
**At phase breaks**: Update PLAN.md, git commit, update SESSION_LOG.md
**When project completes**: Update GLOBAL_SUMMARY_LOG.md, create SUMMARY.md, update README/CHEATSHEET
**Always**: Discuss before implementing, show changes for approval, be context-aware
