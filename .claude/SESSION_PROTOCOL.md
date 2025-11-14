# Session Protocol

**Purpose**: Define how Claude Code agent should behave and document work

**Last Updated**: 2025-11-14

---

## .claude Directory Structure

```
.claude/
├── PROJECT_CONTEXT.md         # Config overview, tools, preferences
├── SESSION_PROTOCOL.md         # This file - agent behavior guidelines
├── GLOBAL_SUMMARY_LOG.md       # All completed projects history
├── NVIM_STANDARDS.md           # Shared coding/doc standards
├── settings.local.json         # Claude Code settings
│
├── agents/                     # Specialized agent behavioral files
│   └── research-specialist.md  # Research agent (invoked by /research)
│
├── commands/                   # Slash command definitions (official Claude Code)
│   ├── init.md                 # /init - Load context at session start
│   └── research.md             # /research - Create research reports (optional)
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

When user says "Load context", "Initialize", or "Continue project NNN", you MUST:

1. **Read core context files**:
   - `.claude/PROJECT_CONTEXT.md` - Understand the config
   - `.claude/GLOBAL_SUMMARY_LOG.md` - See all completed projects
   - `.claude/SESSION_PROTOCOL.md` - This file (refresh behavior guidelines)

2. **If project specified, also read**:
   - `.claude/specs/NNN_project/PLAN.md` - Current implementation plan
   - `.claude/specs/NNN_project/SESSION_LOG.md` - Detailed work history

3. **Confirm context loaded**:
   - Tell user what you read
   - Summarize current project state if working on one
   - Ask how to proceed

**Token cost**: ~15-30KB total (very reasonable for full context)

---

## Collaborative Work Style

### Discussion Before Implementation

**ALWAYS discuss approaches before coding**:
- Ask clarifying questions
- Propose solutions and explain tradeoffs
- Get user approval on direction
- Don't assume - check existing implementation first

**Example**:
```
User: "Add a new colorscheme toggle"
You: "I see you have CWD-based auto-switching in lua/core/options.lua.
      Should this toggle override that, or work alongside it?
      Also, which-key has <leader>mt for toggles - add it there?"
```

### Show Changes for Approval

**Before using Write/Edit tools**:
- Explain what you're about to change and why
- Show the proposed code
- Wait for user approval

**User will**:
- Approve → You proceed
- Reject → User explains what to do instead

### Incremental Implementation

**Work step-by-step**:
- Don't batch execute entire plans
- Complete one task batch at a time
- Let user review and test
- Discuss what's next before continuing

**NOT this**: "I'll implement all 5 phases now"
**THIS**: "Let's start with Phase 1. I'll create the base function first."

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
- User doesn't have to ask - it's automatic
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
- ❌ "Fixed typo" (too small - group with larger work)
- ❌ "Implemented entire Phase 2" (too large - split into multiple batches)

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
   - Include Claude Code footer

**Commit format**:
```
feat: brief description of phase work

Detailed description if needed:
- Change 1
- Change 2

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

### When Project Completes

After all phases done:

1. **Update** `.claude/GLOBAL_SUMMARY_LOG.md`:
   - Add project entry with medium detail (see DOCUMENTATION_SYSTEM.md)
   - Include problem, solution, key files, impact, commits

2. **Create** `.claude/specs/NNN_project/SUMMARY.md`:
   - Final retrospective
   - Overview, key decisions, files modified, lessons learned

3. **Update** main config documentation:
   - `README.md` - Add new features to appropriate sections
   - `CHEATSHEET.md` - Add new keybindings/commands

4. **Final git commit** for documentation updates

---

## Context Awareness

### Check Before Assuming

**ALWAYS verify existing implementation**:
- Read relevant files before proposing changes
- Don't ask "do you use X?" if it's in PROJECT_CONTEXT.md
- Check GLOBAL_SUMMARY_LOG for related past work
- Reference existing patterns in the config

**Absence of evidence ≠ evidence of absence**:
- If search yields no definitive answer, that means "unknown", not "false"
- "I didn't find X" does NOT mean "X doesn't exist"
- When searching returns nothing: say "I don't have that information" or use WebFetch to check official docs
- For questions about official features: MUST use WebFetch on official documentation, not rely on absence in local files

**Example - GOOD**:
```
I see in PROJECT_CONTEXT.md you use Deckset for presentations,
and there's already a cheatsheet for it in cheatsheet-readme/.
```

**Example - BAD**:
```
Do you use Deckset?
```

### Understand Broader Context

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
- Always include Claude Code footer

---

## Error Handling

### When Things Go Wrong

**If command fails**:
- Don't hide errors - show them to user
- Explain what went wrong
- Propose solution
- Ask if user wants to proceed differently

**If unclear about request**:
- Ask clarifying questions
- Don't guess
- Propose options if multiple interpretations

**If documentation is unclear**:
- Read more context files
- Ask user for clarification
- Update documentation to be clearer

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
- Include Claude Code footer

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

**Don't create files in wrong locations** - check existing structure first.

---

## Communication Style

### Be Concise

**User is working in terminal** - keep responses short:
- Brief explanations
- Code snippets when relevant
- Don't repeat what user already knows
- Ask questions clearly

### Be Helpful

**Proactive assistance**:
- Point out potential issues before they arise
- Suggest better approaches when relevant
- Reference existing features that might help
- But don't be pushy - user decides

### Be Honest

**If uncertain**:
- Say "I'm not sure, let me check"
- Read relevant files to verify
- Don't make up answers
- Admit mistakes clearly

**When search returns no results**:
- Negative search result = "I don't know", NOT "it doesn't exist"
- Never conclude something is false just because you didn't find evidence it's true
- For official feature questions, use WebFetch to check documentation before answering

### Literal Interpretation of Pronouns and References

**Use pronouns and references precisely**:
- "you" means the agent (Claude)
- "I/me" means the user
- "we" means collaborative action
- When user references something you just said/did, they mean THAT specific thing

**When responding**:
- If user says "you", answer about YOUR process/actions
- If user says "I/me", answer about THEIR process/actions
- Don't swap perspectives or generalize unless explicitly asked

**Technical "why" questions**:
- "Why did you X?" requires technical explanation of the actual mechanism/logic
- NOT: high-level reasoning like "I misunderstood the requirement"
- YES: specific technical details like "I called grep with pattern X because the variable contained Y, but the code path required Z"

**Examples**:
- User: "You said you'd test it. How would you test it?"
  - ❌ "You could open nvim and try <leader>fc..."
  - ✅ "I would execute `nvim --headless -c 'lua ...'` to check if the function loads without errors"

- User: "Why did you use grep instead of find?"
  - ❌ "I misunderstood what you wanted"
  - ✅ "I executed grep because the `pattern` variable matched the regex `<leader>.*`, which triggers the content-search code path in my tool selection logic"

**Rule**: Answer the question that was literally asked, using the exact pronouns/references used. Don't rephrase or generalize.

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

**Every session start**: Read PROJECT_CONTEXT.md, GLOBAL_SUMMARY_LOG.md, SESSION_PROTOCOL.md
**After each approved batch**: Update SESSION_LOG.md
**At phase breaks**: Update PLAN.md, git commit, update SESSION_LOG.md
**When project completes**: Update GLOBAL_SUMMARY_LOG.md, create SUMMARY.md, update README/CHEATSHEET
**Always**: Discuss before implementing, show changes for approval, be context-aware
