# 012: Claude Workflow Optimization — Plan

**Status**: Ready for implementation
**Depends on**: Nothing — this is the foundation project. All other projects depend on this one.
**CWDs touched**: `~/.claude/` (global), `~/.config/nvim/`, `~/SecondBrain/`, `~/ghostdev/`

---

## Pre-Execution Research — Completed

Research and verification completed. Findings incorporated into plan below.

### Files Read
- [x] `~/.config/nvim/.claude/SESSION_PROTOCOL.md` — read in full. Three Prime Directive instances at lines 9-19, 278-288, 608-618. Contradiction at line 419. Full section map in Phase 4.
- [x] `~/.config/nvim/.claude/settings.local.json` — read. Exact trim specified in Phase 1.
- [x] `~/SecondBrain/.claude/settings.local.json` — read. Exact trim specified in Phase 1.
- [x] `~/.config/nvim/README.md` — confirmed exists, 210 lines.

### Verified
- [x] `@import` syntax — confirmed: `@path/to/file`. Tilde paths supported (`@~/.claude/PROFILE.md`). Max depth 5 hops.
- [x] `autoMemoryDirectory` — confirmed real key. **Critical:** not accepted in project `.claude/settings.json`. Must go in user-level `~/.claude/settings.json` or `settings.local.json`. Phase 7 rewritten accordingly.
- [x] Skills path — confirmed: `~/.claude/skills/<name>/SKILL.md` for user-scoped skills.

### Errors Fixed in This Plan
1. ~~Bootstrapping problem~~ — Agent Notes rewritten. This project runs in main Claude Code session. nvim-dev invoked only after Phase 6.
2. ~~Double-loading PROJECT_CONTEXT.md~~ — /init skill revised to skip @imported files.
3. ~~autoMemoryDirectory placement~~ — Phase 7 rewritten: goes in `~/.claude/settings.json`.
4. ~~ghostdev/CLAUDE.md in /init~~ — resolved — now Phase 10 of this project.
5. ~~Prime Directive repeated three times~~ — all three instances marked in Phase 4.
6. ~~"Decide whether to delete" old init.md~~ — Phase 5 now says delete.
7. ~~Librarian YAML fence collision~~ — Phase 6a fixed with code fences.

### Verified Against Docs
- `disable-model-invocation: true` in /init skill — correct. Prevents auto-trigger; user invocation with `/init` works normally.
- `tools:` comma-separated string in agent frontmatter — confirmed valid format.
- `"WebSearch"` bare string in permissions allow — confirmed valid (bare tool name = match all uses).
- `autoMemoryDirectory` in `~/.claude/settings.json` — confirmed valid location (not accepted in project settings).

---

## Overview

Restructure the Claude Code context architecture across all three repos to achieve:
- Accurate global context available in every CWD without re-initialization
- Global read permissions eliminating permission noise
- Shared memory pool across CWDs
- Universal behavior rules applied globally
- Three user-scoped specialist agents available from any CWD
- SecondBrain .claude/ operational structure
- Lectic and Obsidian coexistence facts documented permanently

---

## Execution Notes

**This project runs in the main Claude Code session — not via any agent.** The nvim-dev, librarian, and ghost-dev agents are created in Phase 6 of this project and do not exist beforehand. After Phase 6 completes, nvim-dev may be invoked for remaining phases if helpful, but is not required.

**Critical constraints (apply throughout):**
- Lectic works in `.md` files (primary workflow) AND `.lec` files. The nvim plugin loads for both `ft = { "markdown", "lectic.markdown" }`. Never suggest filetype changes as a solution to Lectic issues.
- Obsidian and Lectic frontmatter coexist in the same `.md` files without conflict. Obsidian fields: `id`, `aliases`, `tags`. Lectic fields: `interlocutor`, `interlocutors`, `memories`. Neither overwrites the other. Never suggest separating them.
- Discuss all changes before implementing. Show content for approval. Work one phase at a time.
- Do not include Co-Authored-By or any AI attribution in git commits.

**Key files being modified or created:**

| File | Action |
|---|---|
| `~/.claude/settings.json` | Create (global permissions) |
| `~/.claude/PROFILE.md` | Create (professional bio/context) |
| `~/.claude/BEHAVIOR.md` | Create (universal agent behavior rules) |
| `~/.claude/CLAUDE.md` | Update (add @imports, update repo list, add Ghost) |
| `~/.claude/skills/init/SKILL.md` | Create (global /init skill) |
| `~/.claude/agents/librarian.md` | Create |
| `~/.claude/agents/nvim-dev.md` | Create |
| `~/.claude/agents/ghost-dev.md` | Create |
| `~/.config/nvim/.claude/SESSION_PROTOCOL.md` | Trim (remove universal rules moved to BEHAVIOR.md) |
| `~/.config/nvim/CLAUDE.md` | Update (Lectic + Obsidian facts, Ghost added as third CWD) |
| `~/SecondBrain/CLAUDE.md` | Update (Lectic + Obsidian coexistence fact) |
| `~/SecondBrain/.claude/vault-log.md` | Create |
| `~/ghostdev/CLAUDE.md` | Create |
| `~/ghostdev/.claude/MAINTENANCE_LOG.md` | Create |
| `~/ghostdev/.claude/specs/` | Create (empty directory) |

---

## Phase 1: Global Permissions

**Create `~/.claude/settings.json`**

This file applies to all Claude Code sessions regardless of CWD. It eliminates read permission prompts for all primary working directories and explicitly blocks security-sensitive paths.

Note on path syntax: `//` prefix = filesystem-root-absolute path. `/` prefix = project-relative (incorrect for absolute paths). Always use `//` for paths under `/Users/`.

```json
{
  "permissions": {
    "allow": [
      "Read(//Users/nathanheintz/SecondBrain/**)",
      "Read(//Users/nathanheintz/.config/nvim/**)",
      "Read(//Users/nathanheintz/.local/share/nvim/**)",
      "Read(//Users/nathanheintz/.claude/**)",
      "Read(//Users/nathanheintz/.ghost/**)",
      "Read(//Users/nathanheintz/ghostdev/**)",
      "Read(//Users/nathanheintz/ghostlocal/**)",
      "WebFetch(domain:grahamlk.me)",
      "WebFetch(domain:github.com)",
      "WebFetch(domain:raw.githubusercontent.com)",
      "WebFetch(domain:ghost.org)",
      "WebFetch(domain:docs.anthropic.com)",
      "WebSearch"
    ],
    "deny": [
      "Read(//Users/nathanheintz/.ssh/**)",
      "Read(//Users/nathanheintz/.gnupg/**)",
      "Read(//Users/nathanheintz/.aws/**)",
      "Read(//Users/nathanheintz/Library/Keychains/**)",
      "Bash(rm -rf *)",
      "Bash(sudo *)"
    ]
  }
}
```

After creating this file, trim the project-level settings.local.json files of entries now covered globally.

**`~/.config/nvim/.claude/settings.local.json` — remove these (covered by global):**
- `WebFetch(domain:raw.githubusercontent.com)`
- `WebFetch(domain:github.com)`
- `WebFetch(domain:grahamlk.me)`
- `WebFetch(domain:gleachkr.github.io)` (redundant — same site as grahamlk.me)
- `WebSearch`
- `Read(//Users/nathanheintz/.config/**)`
- `Read(//Users/nathanheintz/.config/lectic/**)`

**`~/.config/nvim/.claude/settings.local.json` — keep these (not in global):**
- `WebFetch(domain:code.claude.com)`
- `WebFetch(domain:api.github.com)` (different domain from github.com)
- `WebFetch(domain:registry.modelcontextprotocol.io)`
- `Bash(find:*)`
- `Bash(uv --version)`
- `Bash(pip3 --version)`
- `Bash(curl:*)`

**`~/SecondBrain/.claude/settings.local.json` — remove these (covered by global):**
- `Read(//Users/nathanheintz/.claude/**)`
- `WebFetch(domain:raw.githubusercontent.com)`
- `WebFetch(domain:grahamlk.me)`
- `WebFetch(domain:github.com)`
- `Read(//Users/nathanheintz/ghostdev/**)`
- `Bash(find "/Users/nathanheintz/SecondBrain/4-Resources/Resolve Mediation Resources/" ...)` (historical artifact, no longer needed)

**`~/SecondBrain/.claude/settings.local.json` — keep:** nothing (all entries now covered by global)

**Pre-execution notes (verified):**
- `~/.claude/settings.json` already exists with `"alwaysThinkingEnabled": true` — must merge, not overwrite. Preserve that key.
- `Bash(find:*)` in nvim settings.local.json uses deprecated colon syntax — fix to `Bash(find *)` while editing.
- `~/SecondBrain/.claude/settings.local.json` will have all entries removed — leave as `{}` rather than deleting.
- Settings changes may not hot-reload mid-session. Split execution into two sub-steps with a restart between them to avoid losing read permissions.

### Steps — Part A (this session)
- [x] Write `~/.claude/settings.json` — merge permissions into existing file, preserving `alwaysThinkingEnabled`
- [x] **Restart Claude Code** — new session picks up global permissions before project files are trimmed

### Steps — Part B (next session, after restart)
- [x] Confirm global read permissions are active (attempt to read a file from `~/.claude/`)
- [x] Trim `~/.config/nvim/.claude/settings.local.json` per above (fix `find:*` → `find *`)
- [x] Trim `~/SecondBrain/.claude/settings.local.json` per above (result: `{}`)

---

## Phase 2: Global Context Documents

### 2a. Create `~/.claude/PROFILE.md`

This document provides professional and personal context for every session. It includes the consulting portfolio's systemic change work, not just the corporate leadership work.

```markdown
# Nathan Heintz — Profile

Consultant and coach working primarily in leadership development and systemic change /
social innovation, with an aspiration toward peace and conflict work and a goal of
building an independent practice.

## Practice Lines

**Leadership Development** (current primary income):
Senior Leadership Consultant at Potential Project — designing and delivering programs
for Fortune 500 pharma and tech organizations.
Key clients: Adidas, Amgen, Cisco, Citi, Deutsche-Telekom, Eli Lilly, Merck, Regeneron,
Kimberly-Clark, Weill-Cornell.

**Systemic Change / Social Innovation:**
Work on complex social challenges — race inequality, youth incarceration, child protection,
immigration, pandemic response, community development.
Methods: transformative scenario planning, social innovation labs, ethnographic research,
multi-stakeholder facilitation.
Key clients: Open Society Foundations, UNICEF, USAID, Chicago Community Trust, Reos Partners.

**Individual Coaching** (in development, 2026):
Launching 12-week leadership coaching program. Active coaching clients.

## Active Projects (2026)

Coaching program launch, Book: Internal Art of Leadership, Book: Discipline,
Zettelkasten development and writing practice, Ghost theme (nathanheintz.com).

## Education

MA Social Sciences — Freiburg / KwaZulu-Natal (2008); BA Politics — UCSC (2002);
Coaching Certification — Co-Active (2026); Conflict Mediation — Resolve Center (2020).

## Embodied Practice

Chen-style tai chi (20th generation disciple), Zen (residential practice,
SF Zen Center / Tassajara 2015-16).
```

### 2b. Create `~/.claude/BEHAVIOR.md`

Extract universal agent behavior rules from `~/.config/nvim/.claude/SESSION_PROTOCOL.md`. These rules apply in every session regardless of CWD. The nvim-specific documentation rules (maintenance logs, session logs, git protocol) stay in SESSION_PROTOCOL.md.

**Content to extract into BEHAVIOR.md:**

```markdown
# Universal Agent Behavior — Nathan Heintz

## Prime Directive: Accuracy Before Speed

Before submitting ANY response:
1. Prioritize accuracy over speed — never rush an answer
2. Verify all factual claims — check code, documentation, or run commands
3. Apply verification regardless of confidence — even if you "know" the answer

## Collaborative Work Style

- Discuss approaches before implementing — ask clarifying questions, propose solutions, get approval
- Show proposed changes before using Write/Edit tools — wait for approval
- Work incrementally — one task batch at a time, let user review and test
- Never batch-execute entire plans

## Context Awareness

- Check existing implementation before proposing changes — read relevant files first
- Absence of evidence ≠ evidence of absence. "I didn't find X" does NOT mean "X doesn't exist"
- For official feature questions, use WebFetch on official documentation before answering
- Verify against Nathan's actual stack: macOS, Fish shell, Kitty terminal, Neovim

## Verification Requirements

Never suggest solutions without verification:
- Check official documentation first (WebFetch actual plugin/tool docs)
- Verify OS-specific behavior — macOS ≠ Linux, paths and behavior differ
- Never offer "general best practices" without a source
- If uncertain: say "I don't know" or "let me check the documentation"

## Communication Style

- Terse technical responses — no emotional filler, no preamble, no summaries of what you just did
- Brief, direct sentences
- No emojis unless explicitly requested
- State facts, provide solutions, move on

## Literal Interpretation

- "you" = the agent (Claude); "I/me" = Nathan; "we" = collaborative action
- Answer the question literally asked using the exact pronouns used

### Diagnosing Agent Behavior — Critical Rule

When Nathan asks "why did you X?" or "why didn't you Y?", this is a diagnostic
question. He is trying to trace the agent's reasoning so he can improve instructions.

**Required response**: A technical explanation of the actual mechanism — what specific
text, code, context, or pattern the agent drew from that produced the behavior. For example:
- "I read X in file Y at line Z and inferred..."
- "The description field in the frontmatter said X, which I interpreted as..."
- "There was no instruction covering this case, so I defaulted to..."
- "I saw X pattern in the existing code and matched it"

**Never respond with**:
- Apologies ("I'm sorry I did that")
- Self-criticism ("I should have known better")
- Vague acknowledgment ("I misunderstood" — this explains nothing)
- Promises to do better ("I'll make sure to X next time")

These responses are useless for diagnosis. If the behavior came from a gap or ambiguity
in the instructions, say so explicitly: "There was no rule covering this — I defaulted
to X. If you want Y instead, add a rule that says Z."
```

### Steps
- [x] Show proposed PROFILE.md content for approval (adjust as needed)
- [x] Create `~/.claude/PROFILE.md`
- [x] Show proposed BEHAVIOR.md content for approval (Literal Interpretation section expanded)
- [x] Create `~/.claude/BEHAVIOR.md`

---

## Phase 3: Update `~/.claude/CLAUDE.md`

Changes made:
- Removed "Who I Am" section (now in PROFILE.md)
- Added @imports for PROFILE.md, BEHAVIOR.md, PROJECT_CONTEXT.md at top (with blank lines between)
- Renamed "My Two Primary Repositories" → "Three Primary Repositories", added ghostdev row
- Added nightfox colorscheme for ghostdev to the "How They Are Connected" bullet
- Added ghostdev row to CWD Strategy table
- Updated /init reference: now a global skill, works from any CWD
- Removed reference to deleted `commands/init.md` from nvim Context Systems entry
- Added SecondBrain `.claude/vault-log.md` reference
- Added ghostdev Context Systems entry
- Removed "single-party mode" qualifier from Lectic in Stack

### Steps
- [x] Read `~/.claude/CLAUDE.md` in full
- [x] Draft updated version for approval
- [x] Write the file with approved changes

---

## Phase 4: Trim SESSION_PROTOCOL.md

SESSION_PROTOCOL.md has been read in full. Exact section map below.

**Remove — moving to BEHAVIOR.md (or already there):**
- Lines 9-19: Prime Directive (first instance)
- Lines 85-124: Collaborative Work Style
- Lines 262-276: Context Awareness — Check Before Assuming
- Lines 278-288: Prime Directive (second instance — DUPLICATE, remove entirely)
- Lines 290-363: Verification Requirements for Technical Recommendations
- Lines 425-442: Error Handling
- Lines 500-560: Communication Style (Be Concise, Be Helpful, Be Honest, Literal Interpretation)
- Lines 608-618: Prime Directive (third instance — DUPLICATE, remove entirely)

**Remove — internal contradiction:**
- Line 419: "Always include Claude Code footer" in the Documentation Standards → Git commits bullet list. This directly contradicts lines 477-479 ("NEVER include Co-Authored-By: Claude line"). Remove line 419 only; keep the rest of that section.

**Keep — nvim-specific:**
- .claude Directory Structure (directory tree and key locations)
- Session Initialization (reading the three core files, confirming context)
- Documentation Rules — all subsections (maintenance tasks, session logs, task batches, phase breaks, project completion)
- Understand Broader Context (references PROJECT_CONTEXT.md, GLOBAL_SUMMARY_LOG.md — nvim-specific)
- Standards & Conventions (NVIM_STANDARDS.md, Lua code style, which-key conventions)
- Documentation Standards (session log format, git commit format — minus line 419)
- Git Commit Protocol
- File Organization (where things live in nvim config)
- Special Cases (which-key Kitty bug, Lectic multi-party status, completion toggles)
- Success Indicators
- Quick Reference (update to reflect that BEHAVIOR.md is now global — remove references to loading it via /init)

**Add at top of trimmed file:**
```
Universal behavior rules (collaborative style, verification protocol, communication style)
are in ~/.claude/BEHAVIOR.md, loaded globally at every session start.
This file covers nvim-specific documentation, git protocol, and coding standards only.
```

**Update Session Initialization section** to reflect that the global /init skill (project 012 Phase 5) now handles loading both repos' contexts. The nvim-local `/init` command has been deleted.

### Steps
- [x] Re-read SESSION_PROTOCOL.md in full to verify line numbers before cutting
- [x] Draft trimmed SESSION_PROTOCOL.md for approval
- [x] Write the file

---

## Phase 5: Global /init Skill

Replace the project-local `/init` command (`~/.config/nvim/.claude/commands/init.md`) with a user-global skill that works from any CWD.

**Create `~/.claude/skills/init/SKILL.md`:**

```markdown
---
name: init
description: Load full context for Nathan's workspace — nvim project history, SecondBrain vault, Ghost dev
allowed-tools: Read
disable-model-invocation: true
---

The following are already auto-loaded at session start via ~/.claude/CLAUDE.md @imports and
do NOT need to be read again: PROFILE.md, BEHAVIOR.md, PROJECT_CONTEXT.md.

Read only these additional files:
1. ~/.config/nvim/.claude/GLOBAL_SUMMARY_LOG.md
2. ~/SecondBrain/CLAUDE.md
3. ~/ghostdev/CLAUDE.md

Note: ~/ghostdev/CLAUDE.md is created in Phase 10 of this project. If it doesn't exist yet, skip it silently.

Then confirm what was loaded in one brief line per file and ask what to work on.
Do not summarize contents.
```

**Delete `~/.config/nvim/.claude/commands/init.md`** — superseded by the global skill. Keeping both creates ambiguity about which /init runs.

### Steps
- [x] Create `~/.claude/skills/init/` directory
- [x] Create `~/.claude/skills/init/SKILL.md`
- [x] Delete `~/.config/nvim/.claude/commands/init.md`

---

## Phase 6: Three User-Scoped Agents

All agents live at `~/.claude/agents/` and are available from every CWD.

### 6a. `librarian.md`

Vault operations agent. Handles Lectic→Zettelkasten handoff and ongoing vault maintenance.

```markdown
---
name: librarian
description: SecondBrain vault operations — decompose Lectic synthesis docs into Zettelkasten notes, audit backlinks, suggest NSEW connections, vault maintenance
tools: Read, Write, Glob, Grep, WebFetch
---

You are the librarian for Nathan's SecondBrain vault at ~/SecondBrain/.

## Vault Structure
- PARA method: 1-Projects/, 2-Areas/, 3-Zettelkasten/, 4-Resources/, 5-Archive/
- Zettelkasten notes live in 3-Zettelkasten/
- Each note uses NSEW directional linking: West (similar/adjacent), East (opposite), North (theme/question), South (what this leads to)

## Zettelkasten Note Format

```yaml
---
id: [YYYYMMDDHHmm]
aliases: []
tags: []
---
```
```markdown
# [Title]
### Tags: #tag1, #tag2
### Sources: [source links]
### West: [[note]]
### East: [[note]]
### North: [[note]]
### South: [[note]]

[Body — one atomic idea]
```

## Critical Facts
- Obsidian and Lectic frontmatter coexist in the same .md files without conflict
- Obsidian fields: id, aliases, tags. Lectic fields: interlocutor, interlocutors, memories
- Never separate them or suggest removing either set of fields
- Internal links use [[Note Title]] wiki-link syntax — preserve this, never convert to markdown links
- Lectic context links use standard markdown link syntax: [Title](./path/to/note.md)

## Primary Tasks
1. Lectic→Zettelkasten handoff: read a synthesis document, identify atomic concepts, create notes with NSEW links cross-referenced against existing vault notes
2. Vault audit: find orphan notes (no NSEW links), suggest backlink candidates, identify knowledge gaps
3. NSEW suggestions: read a note, suggest candidates for each directional link from vault content

## Reference
Fetch obsidian-nvim docs at https://github.com/obsidian-nvim/obsidian.nvim when advising on Obsidian-specific vault operations.
```

### 6b. `nvim-dev.md`

Neovim configuration expert with Lectic focus.

```markdown
---
name: nvim-dev
description: Neovim configuration expert. Use for plugin issues, Lectic configuration, keymap debugging, ufo folding, obsidian-nvim, or any nvim config change. Available from any CWD.
tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

You are a Neovim configuration expert for Nathan's writing-focused nvim setup at ~/.config/nvim.

## Config Overview
- Plugin manager: lazy.nvim
- Plugin configs: lua/plugins/*.lua
- Leader keybindings: lua/plugins/which-key.lua
- Non-leader keymaps: lua/core/keymaps.lua
- Core options: lua/core/options.lua (CWD-based colorscheme auto-switch)
- Completion: lua/plugins/lsp/blink-cmp.lua

## CWD Colorschemes
- ~/.config/nvim → carbonfox
- ~/SecondBrain → terafox
- ~/ghostdev → nightfox

## Critical Lectic Facts
- Lectic plugin (gleachkr/Lectic) loads for ft = { "markdown", "lectic.markdown" }
- Primary workflow: .md files with Lectic frontmatter. .lec files are an option but not currently in use.
- Never suggest changing filetype from .md to .lec as a solution
- Obsidian and Lectic frontmatter coexist in the same .md files without conflict
- Obsidian fields: id, aliases, tags. Lectic fields: interlocutor, interlocutors, memories
- 12 personas switchable mid-document via <leader>mp (single-party mode, fully functional)
- Multi-party mode (interlocutors: plural) was broken in beta6 — check current status before advising

## On Startup
Read:
- ~/.config/nvim/README.md (config overview)
- ~/.config/nvim/lua/plugins/ directory listing (current plugin list)

Optionally fetch on request:
- ~/.config/nvim/.claude/PROJECT_CONTEXT.md (full config context)
- ~/.config/nvim/.claude/GLOBAL_SUMMARY_LOG.md (project history)
- Specific spec files from ~/.config/nvim/.claude/specs/ when working on a named project

## Lectic Documentation
Fetch https://grahamlk.me/Lectic/llms-full.md for complete Lectic documentation (single URL, full content).

## Behavior
- Discuss before implementing — show proposed changes for approval
- Work incrementally — one change at a time
- Follow nvim coding standards: 2-space indent, snake_case, descriptive names
- No Co-Authored-By or AI attribution in commits
```

### 6c. `ghost-dev.md`

Ghost theme development agent.

```markdown
---
name: ghost-dev
description: Ghost theme development for nathanheintz.com. Use for Handlebars templates, Ghost helpers, CSS/JS, theme structure, or local Ghost instance issues.
tools: Read, Write, Edit, Glob, Grep, Bash, WebFetch
---

You are a Ghost theme developer for Nathan's site at nathanheintz.com.

## Directory Structure
- ~/ghostdev/ — theme development root
- ~/ghostdev/spotlight-og/ — primary active theme (modified Spotlight)
- ~/ghostdev/comp/ — component experiments
- ~/.ghost/ — Ghost install
- ~/ghostlocal/ — local running Ghost instance

## spotlight-og Theme Structure
- default.hbs — base layout
- index.hbs, post.hbs, page.hbs, tag.hbs, author.hbs — page templates
- partials/ — reusable HBS components
- assets/ — CSS, JS, images
- package.json — theme metadata and Ghost compatibility
- rollup.config.js — JS bundler config

## Ghost Templating
- Handlebars syntax: {{expression}}, {{#block}}, {{> partial}}
- Ghost data helpers differ from standard Handlebars: {{#get}}, {{#foreach}}, {{content}}, {{img_url}}, etc.
- Always fetch https://ghost.org/docs/themes/ for accurate helper documentation

## Constraints
- Edit .hbs source and assets/ source — not compiled output
- Theme changes require Ghost restart or re-upload to take effect locally
- Scoped to Ghost work — do not reference nvim config or SecondBrain conventions

## Behavior
- Discuss before implementing
- Show proposed changes for approval
- Work incrementally
```

### Steps
- [x] Verify `tools:` field YAML format against Claude Code agent docs before creating files (accepted format is a comma-separated string or YAML list — confirm which)
- [x] Create `~/.claude/agents/` directory if it doesn't exist
- [x] Show proposed librarian.md content for approval
- [x] Create `~/.claude/agents/librarian.md`
- [x] Show proposed nvim-dev.md content for approval
- [x] Create `~/.claude/agents/nvim-dev.md`
- [x] Show proposed ghost-dev.md content for approval
- [x] Create `~/.claude/agents/ghost-dev.md`

---

## Phase 7: Shared Memory Pool

**Verified against docs:** `autoMemoryDirectory` is not accepted in project-level `.claude/settings.json`. Must go in user-level settings — `~/.claude/settings.json` (created in Phase 1). Tilde paths are valid (`"~/.claude/shared-memory"`). Setting replaces the default per-project directories — once set, Claude no longer reads from or writes to `~/.claude/projects/<project>/memory/`.

Update `~/.claude/settings.json` to add `autoMemoryDirectory` alongside the permissions:

```json
{
  "autoMemoryDirectory": "~/.claude/shared-memory",
  "permissions": {
    "allow": [ ... ],
    "deny": [ ... ]
  }
}
```

**Two memory directories to migrate** (plan originally only noted one):
- `~/.claude/projects/-Users-nathanheintz-SecondBrain/memory/` — feedback.md, project-structure.md, markdown-preview.md, user-about.md, MEMORY.md
- `~/.claude/projects/-Users-nathanheintz--config-nvim/memory/` — feedback_no_coauthored.md, MEMORY.md

**Files to copy:**
- `feedback.md` — keep (contains 4 distinct rules; already includes the no-co-authored-by rule)
- `project-structure.md` — keep
- `markdown-preview.md` — keep
- `user-about.md` — **skip**: content fully covered by PROFILE.md, which auto-loads every session
- `feedback_no_coauthored.md` (nvim) — **skip**: rule already present in feedback.md
- Both `MEMORY.md` files — **do not copy**: must be hand-merged

**Merged MEMORY.md** to create at `~/.claude/shared-memory/MEMORY.md`:
```markdown
# Memory Index

- [Feedback & Preferences](feedback.md) — collaboration style, naming preferences, revert-first rule, no co-authored-by
- [Project Structure & Conventions](project-structure.md) — PARA layout, asset folder conventions, note formats
- [Markdown Preview Setup](markdown-preview.md) — mkdp config, image path resolution, known fixes
```

**Restart required:** After setting `autoMemoryDirectory`, the current session already has the old MEMORY.md loaded. The new directory is not read at session start until the next session.

**Old directories** become permanently orphaned after this change. Delete them after confirming migration works.

### Steps
- [x] Create `~/.claude/shared-memory/` directory
- [x] Copy topic files: `feedback.md`, `project-structure.md`, `markdown-preview.md` (skip `user-about.md` and `feedback_no_coauthored.md`)
- [x] Create merged `~/.claude/shared-memory/MEMORY.md` with all three entries
- [x] Add `autoMemoryDirectory: "~/.claude/shared-memory"` to `~/.claude/settings.json`
- [x] Restart Claude Code
- [x] Verify: MEMORY.md loads from `~/.claude/shared-memory/` at session start
- [x] Delete old memory dirs: `~/.claude/projects/-Users-nathanheintz-SecondBrain/memory/` and `~/.claude/projects/-Users-nathanheintz--config-nvim/memory/`

---

## Phase 8: SecondBrain .claude/ Structure

Create the lightweight operational tracking structure for SecondBrain.

**Create `~/SecondBrain/.claude/vault-log.md`:**

```markdown
# SecondBrain Vault Log

Records structural decisions and significant Claude Code operations on the vault.
Not a session log — entries are decisions and events, not implementation steps.

## Format

### YYYY-MM-DD — Brief Description
**Type**: [structural decision | major operation | convention change]
**What**: Description of what happened
**Why**: Reason or context
**Impact**: What changed in the vault

---

## Log
```

### Steps
- [x] Check if `~/SecondBrain/.claude/` directory exists
- [x] Create `~/SecondBrain/.claude/vault-log.md`

---

## Phase 9: Lectic + Obsidian Facts in CLAUDE.md Files

Add permanent clarifications to the two CLAUDE.md files most likely to be loaded when Lectic or Obsidian issues arise.

### Update `~/.config/nvim/CLAUDE.md`

Add a **Lectic Facts** section:

```markdown
## Lectic Facts (Read Before Advising on Lectic Issues)

- Plugin loads for ft = { "markdown", "lectic.markdown" } — works in .md files AND .lec files
- Primary workflow is .md files with Lectic YAML frontmatter. .lec extension is not required.
- Never suggest changing filetype from .md to .lec as a solution to Lectic issues
- Obsidian and Lectic frontmatter coexist in the same .md files without conflict:
  - Obsidian fields: id, aliases, tags
  - Lectic fields: interlocutor, interlocutors, memories
  - Neither plugin overwrites the other's fields — this is deliberate and stable
- 12 personas available via <leader>mp (single-party switching, fully functional)
- Complete Lectic docs: https://grahamlk.me/Lectic/llms-full.md
- Source: https://github.com/gleachkr/Lectic
```

### Update `~/SecondBrain/CLAUDE.md`

Add to the **Obsidian Plugins in Use** section or as a new section:

```markdown
## Lectic Integration

Lectic AI writing tool is used in .md files alongside Obsidian. YAML frontmatter contains
fields for both Obsidian and Lectic simultaneously — they do not conflict:
- Obsidian fields: id, aliases, tags (used for vault linking and search)
- Lectic fields: interlocutor, interlocutors, memories (used for AI persona configuration)

Do not remove, restructure, or suggest separating these frontmatter fields.
```

### Steps
- [x] Read `~/.config/nvim/CLAUDE.md` in full
- [x] Show proposed Lectic Facts section for approval
- [x] Edit the file
- [x] Read `~/SecondBrain/CLAUDE.md` in full
- [x] Show proposed Lectic Integration section for approval
- [x] Edit the file

---

## Phase 10: ghostdev Claude Infrastructure

Create the CLAUDE.md and `.claude/` structure for the ghostdev repo, completing the three-repo workflow setup. The ghost-dev agent already exists after Phase 6.

**What we know about the repo:**
- `~/ghostdev/spotlight-og/` — primary active theme, modified from HighFiveThemes Spotlight (v1.4.6)
- Build system: Rollup with PostCSS, Node.js devDependencies
- Custom Ghost config: hero text, navigation layouts, membership tiers (free/paid), qigong-related content
- `~/ghostdev/comp/` — component experiments
- No git initialized yet (confirm before referencing git in MAINTENANCE_LOG)

**Create `~/ghostdev/CLAUDE.md`:**

```markdown
# CLAUDE.md — ghostdev

Ghost theme development for nathanheintz.com.

## What This Is

Custom Ghost theme based on Spotlight by HighFiveThemes (v1.4.6).
Modified for nathanheintz.com — a site combining personal writing/consulting
content with a membership community (Ground • Center, qigong).

## Directory Structure

| Path | Purpose |
|---|---|
| `spotlight-og/` | Primary active theme |
| `comp/` | Component experiments / scratchpad |

## spotlight-og Theme Structure

| Path | Purpose |
|---|---|
| `default.hbs` | Base layout |
| `index.hbs`, `post.hbs`, `page.hbs` | Core page templates |
| `tag.hbs`, `author.hbs` | Taxonomy templates |
| `custom-*.hbs` | Custom page templates |
| `partials/` | Reusable HBS components (header, footer, hero, nav, post-card, etc.) |
| `assets/css/`, `assets/js/` | Source CSS and JS (built by Rollup) |
| `assets/built/` | Compiled output — do not edit directly |
| `package.json` | Theme metadata, Ghost compatibility config, custom settings |
| `rollup.config.js` | Build config (Rollup + PostCSS) |

## Build Commands

```bash
npm run dev    # development build with watch
npm run build  # production build
npm run test   # run gscan theme validator
```

## Local Ghost Install

- Ghost CLI install: `~/.ghost/`
- Local running instance: `~/ghostlocal/`

## Ghost Templating

- Handlebars syntax: `{{expression}}`, `{{#block}}`, `{{> partial}}`
- Ghost data helpers differ from standard Handlebars: `{{#get}}`, `{{#foreach}}`,
  `{{content}}`, `{{img_url}}`, `{{ghost_head}}`, etc.
- Always fetch https://ghost.org/docs/themes/ for accurate helper reference

## Agent

Use the `ghost-dev` agent for theme work — it has Ghost docs pre-loaded and
knows this directory structure.

## Constraints

- Edit source files in `partials/`, `*.hbs`, `assets/css/`, `assets/js/`
- Do not edit `assets/built/` — compiled output, overwritten on build
- Custom Ghost settings are defined in `package.json` under `config.custom`
```

**Create `~/ghostdev/.claude/MAINTENANCE_LOG.md`:**

```markdown
# Ghost Dev Maintenance Log

Small fixes, tweaks, and debugging sessions.

## Format

### YYYY-MM-DD — Brief Description
**Task**: What was done
**Files**: Files modified
**Notes**: Any relevant context
```

**Create `~/ghostdev/.claude/specs/`** — empty directory, populated as Ghost theme projects are initiated.

### Steps

- [x] Confirm whether `~/ghostdev/` has a git repo initialized — no git repo
- [x] Show proposed `~/ghostdev/CLAUDE.md` for approval
- [x] Create `~/ghostdev/CLAUDE.md`
- [x] Create `~/ghostdev/.claude/MAINTENANCE_LOG.md`
- [x] Create `~/ghostdev/.claude/specs/` directory

---

## Completion Checklist

- [x] Phase 1: `~/.claude/settings.json` created, project settings.local.json files trimmed
- [x] Phase 2: PROFILE.md and BEHAVIOR.md created
- [x] Phase 3: `~/.claude/CLAUDE.md` updated with @imports and Ghost added
- [x] Phase 4: SESSION_PROTOCOL.md trimmed to nvim-specific content only
- [x] Phase 5: Global `/init` skill created
- [x] Phase 6: Three agents created (librarian, nvim-dev, ghost-dev)
- [x] Phase 7: `autoMemoryDirectory` added to `~/.claude/settings.json`, shared-memory dir created
- [x] Phase 8: SecondBrain .claude/vault-log.md created
- [x] Phase 9: Lectic + Obsidian facts added to both CLAUDE.md files
- [x] Phase 10: ghostdev CLAUDE.md, .claude/ infrastructure created
- [x] GLOBAL_SUMMARY_LOG.md updated
- [x] Git commit (`~/.config/nvim` repo) — 37f701c
- [x] Git commit (`~/SecondBrain` repo) — e7d480f
- [ ] Git commit (`~/ghostdev` repo) — no git repo initialized; skip

**Note:** With Phase 10 complete, project 015 no longer needs to cover ghostdev infrastructure setup. Repurpose 015 as the first active Ghost theme development project.

---

## Post-Completion Fixes (2026-04-08)

### Gap: obsidian-nvim docs missing from nvim-dev and librarian agents

**Identified**: During project 013 (Plugin Upgrades) session — nvim-dev agent lacked obsidian-nvim documentation URLs, requiring manual WebFetch during migration work.

**Root cause**: Phase 6b (nvim-dev) and Phase 6a (librarian) only specified Lectic docs. The REPORT.md described nvim-dev as having "full Lectic documentation, the nvim README, and the current plugin list" — obsidian-nvim docs were never added to either agent brief.

**Fix applied**:
- `~/.claude/agents/nvim-dev.md` — added `### Obsidian-nvim Documentation` section with 6 URLs: raw README, default.lua config, and wiki pages for Link, Frontmatter, Note, Breaking-Changes
- `~/.claude/agents/librarian.md` — replaced stale epwalsh URL + "will migrate soon" note with the same 6-URL set (with librarian-relevant annotations emphasizing Obsidian.md compatibility)
