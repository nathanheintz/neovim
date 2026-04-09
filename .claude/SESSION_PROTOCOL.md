# Session Protocol

**Purpose**: Define how Claude Code agent should document work in the nvim config repo

**Last Updated**: 2026-04-08

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
    ├── NNN_project_name/       # One folder per project
    │   ├── PLAN.md             # Primary file: phases, checkboxes, status, decisions
    │   └── [additional files as needed — e.g. REPORT.md, research notes, bug docs]
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
   - `.claude/specs/NNN_project/PLAN.md` — Current plan, status, and decisions

3. **Confirm context loaded**:
   - Tell user what you read
   - Summarize current project state if working on one
   - Ask how to proceed

**Token cost**: ~15-30KB total (very reasonable for full context)

---

## Documentation Rules

### Task Complexity Assessment

Before starting any new request, assess whether it warrants a project or is a maintenance task:

**Maintenance task** — small, self-contained, low coordination overhead:
- Bug fixes, config tweaks, keybinding adjustments, small doc updates
- Single-file or small multi-file changes completable in one session
→ Do it. Log in `specs/000_maintenance_debug/MAINTENANCE_LOG.md` when done.

**Project** — significant scope, benefits from planning and phased execution:
- New features, plugin migrations, major refactors, multi-phase work
- Multiple files, architectural decisions, or unclear upfront scope
→ Suggest creating a numbered project folder with a PLAN.md before starting. Do not begin without an agreed plan.

When the complexity is ambiguous, name it: "This could be a quick maintenance task or warrant a project — I'm leaning [X] because [reason]."

---

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

### During Active Project Work

As work progresses, keep PLAN.md updated — it is the single source of truth for the project.

**Check off completed steps** as they're done: `- [ ]` → `- [x]`

**Add a `Notes:` block under each phase** to capture (1-2 sentences each):
- Key decisions and rationale — "chose X over Y because Z"
- Pivots and blockers — "attempted X, hit Y, switched to Z"
- Non-obvious gotchas discovered mid-work

Only add notes when something non-obvious happened. Skip if a phase goes cleanly.

**Log git commits** under the relevant phase as they're made.

**Example:**
```markdown
## Phase 1: obsidian-nvim Migration [COMPLETED]
- [x] Step one
- [x] Step two

**Notes:**
- Removing blink.compat cascaded to cmp-nvim-lsp and cmp-vimtex — both relied on the
  compat layer. Deleted vimtex-cmp.lua (unused), replaced cmp-nvim-lsp with
  blink.cmp.get_lsp_capabilities().
- toggle_obsidian_completion: `x and nil or false` always returns false in Lua. Use
  explicit if/else.

**Commits:** abc1234
```

### At Phase Breaks

When completing a phase of the plan:

1. **Update** `.claude/specs/NNN_project/PLAN.md`:
   - Mark checkboxes complete: `- [ ]` → `- [x]`
   - Mark phase status: `## Phase N [COMPLETED]`
   - Add Notes block and commit hash if not already done
   - NEVER delete checkboxes (preserves full plan history)

2. **Create git commit**:
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
   - This is the canonical record of all completed projects — every project must have an entry
   - Include: problem, solution, key files, impact, commits

2. **Update** main config documentation:
   - `README.md` — Add new features to appropriate sections
   - `CHEATSHEET.md` — Add new keybindings/commands

3. **Final git commit** for documentation updates

---

## Creating a Project Plan

When a task warrants a project, create `specs/NNN_project_name/PLAN.md` before starting work.

**A good plan includes:**
- **Overview** — what problem this solves and why
- **Phases** — logical units of work, each with a checklist of steps
- **Background per phase** — constraints, key files, risks worth flagging upfront
- **Completion checklist** — high-level milestones (phases done, docs updated, committed)

**Keep it honest:** only plan what you know. Phases can be added as scope becomes clearer. A plan that gets updated is better than one that's abandoned.

**What to put in a phase:**
- Steps specific enough to act on without re-reading background material
- Risks or constraints discovered during planning (not discovered during doing — those go in Notes)
- File locations relevant to that phase

**What not to put in a plan:**
- Code snippets (write the code, not a preview of it)
- Exhaustive step-by-step that duplicates reading the files
- "Future considerations" that aren't part of the current scope

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

**Every session start**: Run `/init`, read PROJECT_CONTEXT.md and GLOBAL_SUMMARY_LOG.md
**New request**: Assess complexity — maintenance task or project? Name it if ambiguous.
**During project work**: Check off steps, add Notes to PLAN.md for decisions/pivots/gotchas, log commits
**At phase breaks**: Mark phase [COMPLETED] in PLAN.md, git commit
**When project completes**: Update GLOBAL_SUMMARY_LOG.md (canonical record), update README/CHEATSHEET
**Maintenance tasks**: Do it, log in MAINTENANCE_LOG.md
**GLOBAL_SUMMARY_LOG.md** = canonical record of completed projects | **MAINTENANCE_LOG.md** = small tasks only
**Always**: Discuss before implementing, show changes for approval, be context-aware
