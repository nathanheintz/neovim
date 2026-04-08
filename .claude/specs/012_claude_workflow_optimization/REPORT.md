# 012: Claude Workflow Optimization — Research Report

**Date**: 2026-04-06
**Status**: Draft — for review before planning

---

## Executive Summary

This report covers five areas where the current Claude Code setup can be significantly improved:

1. **Centralized context** — fragmentary CLAUDE.md setup means switching CWDs loses context; a unified architecture solves this
2. **Permissions** — per-project permission noise can be eliminated with a global settings.json
3. **Cross-CWD continuity** — a `CwdChanged` hook and shared auto-memory pool can make nvim/SecondBrain feel like one workspace
4. **Claude Code capabilities** (April 2026) — several powerful features are currently unused: path-scoped rules, custom subagents, skills with dynamic context, `@import`, hooks
5. **Plugin and tooling gaps** — obsidian.nvim upgrade, folding mode switching, and a few writing-specific plugins

---

## 1. Context Architecture

### 1a. Current State

| File | Loaded when |
|---|---|
| `~/.claude/CLAUDE.md` | Always (global) |
| `~/.config/nvim/CLAUDE.md` | When CWD is nvim config |
| `~/.config/nvim/.claude/PROJECT_CONTEXT.md` | Only via `/init` in nvim CWD |
| `~/SecondBrain/CLAUDE.md` | When CWD is SecondBrain |

**Three active CWDs** (not two): `~/.config/nvim`, `~/SecondBrain`, and `~/ghostdev`. Ghost theme development is a third context that needs its own orientation layer and currently has no CLAUDE.md at all.

**The core problem:** When you're in the SecondBrain CWD and hit a Neovim issue, Claude has:
- Your vault structure and note conventions (from `SecondBrain/CLAUDE.md`)
- Your identity and cross-repo relationship overview (from `~/.claude/CLAUDE.md`)
- **Nothing** about plugin configurations, maintenance history, or behavior guidelines

Running `/init` only works in the nvim CWD. There's no mechanism to pull nvim context from SecondBrain.

### 1b. How CLAUDE.md Inheritance Actually Works (April 2026)

All CLAUDE.md files found while walking up the directory tree from CWD are loaded automatically at session start — in addition to `~/.claude/CLAUDE.md`. This is not "OR" behavior, it's cumulative.

But there is a key capability currently unused: **`@import` syntax**.

Any CLAUDE.md file can embed another file:
```markdown
@~/.config/nvim/.claude/PROJECT_CONTEXT.md
```
This resolves to an absolute path and loads the target file into context at session start — regardless of CWD.

### 1c. Recommended Architecture

**Step 1: Add `@import` cross-references to `~/.claude/CLAUDE.md`**

The global file should import the nvim PROJECT_CONTEXT.md and the SecondBrain CLAUDE.md, so all relevant context is available in every session regardless of CWD. The SESSION_PROTOCOL behavioral guidelines should also be imported so they apply everywhere, not just in nvim sessions.

Concern: token cost. PROJECT_CONTEXT.md is ~8KB, SESSION_PROTOCOL.md is ~19KB. The latter is too large to import globally — it would inflate every SecondBrain session. The solution is to split SESSION_PROTOCOL.md:

- `~/.claude/BEHAVIOR.md` — the universal agent behavior rules (collaborative style, verification protocol, pronoun handling, terse responses). Import this globally.
- `~/.config/nvim/.claude/SESSION_PROTOCOL.md` — the nvim-specific documentation rules, git protocol, and maintenance logging. Keep this nvim-local.

**Step 2: Add a `.claude/rules/` directory in SecondBrain**

Claude Code supports path-scoped rules files. Create `~/SecondBrain/.claude/rules/nvim-issues.md` with frontmatter:
```markdown
---
paths:
  - "**/*"
---
```
This file would contain a concise cross-reference: "For any issue involving Neovim rendering, keymaps, or plugin behavior, refer to ~/.config/nvim/.claude/PROJECT_CONTEXT.md and note that this configuration is documented at that path." This triggers on all SecondBrain files and gives Claude the pointer without importing the full file.

**Step 3: Create a profile document for Nathan**

Currently, Nathan's professional identity is scattered across:
- `~/.claude/CLAUDE.md` (terse overview)
- `~/SecondBrain/1-Projects/Job-Applications/bio-cv.md` (full CV)
- `~/SecondBrain/2-Areas/0-Strategic-Dashboard/0-Welcome Home.md` (purpose/values)
- Various coaching client files

The global CLAUDE.md should import a curated `PROFILE.md` file (around 400 words) that gives Claude the orientation it needs. This profile should span both the corporate leadership work and the earlier systemic change / social innovation work — the latter is an important part of Nathan's identity and expertise that he wants to return to.

A draft based on the CV and portfolio:

```markdown
# Nathan Heintz — Profile

Consultant and coach working primarily in leadership development and systemic change /
social innovation, with an aspiration toward peace and conflict work and a goal of
building an independent practice.

Currently living in a loft above a barbershop in Bushwick, Brooklyn NYC. Travels frequently internationally (Italy, Portugal, Germany, Mexico, South America). 

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

**Active projects (2026):** coaching program launch, Book: Internal Art of Leadership,
Book: Discipline, Zettelkasten development.

**Education:** MA Social Sciences — Freiburg / KwaZulu-Natal (2008); BA Politics — UCSC (2002);
Coaching Certification — Co-Active (2026); Conflict Mediation — Resolve Center (2020).

**Embodied practice:** Chen-style tai chi (20th generation disciple), Zen (residential practice,
SF Zen Center / Tassajara 2015-16).
```

This creates a stable orientation layer so Claude's basic assumptions about Nathan's work are accurate.

### 1d. Lectic Context Clarification

**A critical misunderstanding to fix permanently:** The Lectic neovim plugin (`gleachkr/Lectic`) is currently loaded for BOTH `ft = { "markdown", "lectic.markdown" }` in your config. This means all Lectic nvim commands and keybindings are available in `.md` files. There is no filetype conflict. The `.lec` extension just sets filetype to `lectic.markdown` — it is a convenience, not a requirement.

The Lectic *binary format* (YAML frontmatter + directives) works in any file the plugin can process. The primary workflow is `.md` files with Lectic frontmatter. `.lec` files are an option if separate folding behavior is ever needed (e.g., research vs. writing modes in different files), but are not currently in use.

**This fact needs to be in CLAUDE.md (nvim)** so it stops suggesting filetype changes as a solution. Claude should assume Lectic work is happening in `.md` files unless told otherwise.

**A second critical fact for CLAUDE.md (nvim) and SecondBrain CLAUDE.md:** Obsidian and Lectic frontmatter coexist in the same `.md` files without conflict. Obsidian fields (`id`, `aliases`, `tags`) and Lectic fields (`interlocutor`, `interlocutors`, `memories`) live in the same YAML block. Neither plugin overwrites the other's fields. This is a deliberate and stable part of the setup. Claude should never suggest separating them, removing one set of fields, or treating the combined frontmatter as a problem to fix.

**Lectic documentation reference URLs** (these should be in your nvim CLAUDE.md):
- Entry point: `https://grahamlk.me/Lectic/01_introduction.html`
- Getting started: `https://grahamlk.me/Lectic/02_getting_started.html`
- Complete docs (single page): `https://grahamlk.me/Lectic/llms-full.md`
- Source: `https://github.com/gleachkr/Lectic`

**For troubleshooting, always point Claude to `llms-full.md`** — it's a single URL that contains the complete documentation. This eliminates the "wrong page" problem entirely.

**Multi-party mode status:** Your config comments correctly note that multi-party is broken in beta6. As of April 2026 it is worth checking the Lectic repo for updates — this may have been fixed. If it has, your 12 disabled persona modes could be re-enabled, which would be a significant capability unlock.

---

## 2. Permissions Setup

### 2a. Current State

- nvim `.claude/settings.local.json`: allows some WebFetch domains and `Read(//Users/nathanheintz/.config/**)` — but uses `//` double-slash correctly
- SecondBrain `.claude/settings.local.json`: minimal, allows `.claude/**` reads and one specific Bash find command
- No global `~/.claude/settings.json` exists (only `~/.claude/settings.local.json` with `alwaysThinkingEnabled`)

**Note on path syntax:** The `//` prefix is critical. `Read(/Users/foo)` is project-relative (incorrect for absolute paths). `Read(//Users/foo)` is filesystem-root-relative. Your nvim settings already use `//` correctly.

Also note: `Read` permissions apply only to Claude's built-in Read tool. Bash commands can still read anything — a separate Bash deny rule would be required to restrict shell-level file reads.

### 2b. Recommended Global Permissions (`~/.claude/settings.json`)

Create this file. It applies to all projects and sessions:

```json
{
  "permissions": {
    "allow": [
      "Read(//Users/nathanheintz/SecondBrain/**)",
      "Read(//Users/nathanheintz/.config/nvim/**)",
      "Read(//Users/nathanheintz/.config/nvim/.claude/**)",
      "Read(//Users/nathanheintz/.local/share/nvim/**)",
      "Read(//Users/nathanheintz/.claude/**)",
      "Read(//Users/nathanheintz/.ghost/**)",
      "Read(//Users/nathanheintz/ghostdev/**)",
      "Read(//Users/nathanheintz/ghostlocal/**)",
      "WebFetch(domain:grahamlk.me)",
      "WebFetch(domain:github.com)",
      "WebFetch(domain:raw.githubusercontent.com)",
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

**What this achieves:**
- No more permission prompts for reading SecondBrain, nvim config, or installed nvim plugins
- Security-sensitive paths explicitly blocked before the allow rules can match
- Edit/Write/Bash permissions remain prompt-based (unchanged — you still approve all modifications)

**What to remove from project-level settings.local.json files:** Once global allows are set, remove the duplicated Read permissions from each project's local settings. Keep only project-specific overrides.

**What stays gitignored:** `settings.local.json` (the project-level file) should stay gitignored for anything containing personal paths. `settings.json` (the shareable project file) can be committed but is not needed here since global handles it.

---

## 3. Cross-CWD Continuity

### 3a. The Problem

When switching between `~/.config/nvim` and `~/SecondBrain` CWDs, Claude gets a fresh context load based on local CLAUDE.md files. This means:
- Behavioral guidelines reset (unless globally imported)
- Project history is not visible
- The current state of nvim work is unknown when in SecondBrain

### 3b. `CwdChanged` Hook

Claude Code fires a `CwdChanged` event when the working directory changes. A hook can respond:

```json
{
  "hooks": {
    "CwdChanged": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "echo '{\"message\": \"CWD changed. Core context in ~/.claude/CLAUDE.md applies globally. nvim config context at ~/.config/nvim/.claude/. SecondBrain vault context at ~/SecondBrain/CLAUDE.md.\"}'"
          }
        ]
      }
    ]
  }
}
```

This is lightweight — it just injects a reminder into Claude's context that the full cross-repo documentation exists and where to find it.

### 3c. Auto-Memory Pooling

Claude Code's auto-memory system stores learned facts at `~/.claude/projects/<project>/memory/`. This is currently siloed by project — nvim facts don't transfer to SecondBrain sessions.

**Option A: Override auto-memory directory in both projects** to a shared path:
```json
{ "autoMemoryDirectory": "~/.claude/shared-memory" }
```
Add this to both `~/.config/nvim/.claude/settings.json` and `~/SecondBrain/.claude/settings.json`. Both projects would then write to and read from the same memory pool.

**Option B: Keep separate memory pools** but import a shared cross-repo memory index via `@import` in the global CLAUDE.md.

Option A is simpler. The risk is that highly project-specific memories could bleed across contexts — but given that these two projects are intentionally coupled, this is a feature not a bug.

### 3d. A Unified `/init` Skill

Consider creating a user-scoped skill at `~/.claude/skills/init/SKILL.md` that replaces the current project-local `/init` command and works identically in both CWDs:

```markdown
---
name: init
description: Load full context for Nathan's writing/config workspace
allowed-tools: Read
---

Read the following files in order:
1. ~/.claude/CLAUDE.md
2. ~/.config/nvim/.claude/PROJECT_CONTEXT.md
3. ~/.config/nvim/.claude/GLOBAL_SUMMARY_LOG.md
4. ~/SecondBrain/CLAUDE.md
5. ~/ghostdev/CLAUDE.md

Then confirm context loaded and ask what to work on.
```

This single `/init` works from any CWD and always loads both repos' contexts.

---

## 4. Claude Code Capabilities — April 2026 Overview

Features relevant to your workflow that are currently unused or underused:

### 4a. `.claude/rules/` (Path-Scoped Rules)

Files in `.claude/rules/` apply only when Claude is working with files matching the `paths:` frontmatter. Use cases:

- Rules that apply only in `3-Zettelkasten/` (NSEW format, atomic note conventions)
- Rules for files with Lectic frontmatter (persona switching, context link syntax)
- Rules for `.tex` files (VimTeX workflow, don't suggest non-LaTeX solutions)

This is more precise than dumping everything into CLAUDE.md and hoping it applies correctly.

### 4b. Custom Subagents (`~/.claude/agents/`)

Subagents are AI instances with their own system prompt, tool restrictions, and model. They run inside your main session or as delegates. User-scoped agents at `~/.claude/agents/` are available in every project.

The division of labor between Lectic and Claude Code matters here. Lectic — with 12 switchable personas (Researcher, Writer, Editor, Consultant, etc.) available mid-document — handles all research, synthesis, writing, and editing work. That's not Claude Code's job. Claude Code's role is **vault operations**: structural work that requires reading and writing multiple files, knowing the vault's shape, and operating on the Zettelkasten as a system.

With that in mind, the highest-value agents to create:

**`librarian.md`** — Combined vault operations agent. Handles both the Lectic→Zettelkasten handoff (decomposing synthesis documents into atomic notes with NSEW links) and ongoing vault maintenance (orphan note detection, backlink suggestions, knowledge graph gaps). Has the NSEW format, Zettelkasten conventions, and PARA structure loaded as context, plus the obsidian-nvim documentation as a WebFetch reference so it can advise on vault operations that intersect with Obsidian functionality.

**`nvim-dev.md`** — Neovim configuration expert. Has the full Lectic documentation (`llms-full.md`), the nvim README, and the current plugin list loaded at startup. Can optionally fetch project specs and session log history for deeper work. Invoke from any CWD — useful when you're in SecondBrain or ghostdev and hit a Neovim or Lectic issue without needing to switch contexts or re-explain the setup. When in the nvim CWD, complements `/init` rather than replacing it: `/init` orients a fresh session, `nvim-dev` is the specialist for plugin debugging, Lectic configuration, keymap issues, or any config change.

**`ghost-dev.md`** — Ghost theme development agent. Knows the `~/ghostdev/` theme structure, has read access to `~/.ghost/` and `~/ghostlocal/` for the local install, and has Ghost's theme documentation pre-loaded as a WebFetch reference. Handles Handlebars templating, Ghost's data helpers, CSS/JS for themes, and can reference the local running instance. Scoped to Ghost-specific work so it doesn't bleed into the writing/nvim context.

### 4c. Skills with Dynamic Shell Context

Skills (`.claude/commands/` or `.claude/skills/`) can run shell commands at invocation time and inject the output into Claude's context:

```markdown
## Current vault state
- Modified files: !`cd ~/SecondBrain && git status --short`
- Recent notes: !`ls -lt ~/SecondBrain/3-Zettelkasten/*.md | head -10`
```

Useful for: a `/vault-status` skill that gives Claude an instant snapshot of what's changed in the vault without manual description.

### 4d. Skills with `paths:` Frontmatter

Skills that auto-activate only for matching files. Relevant applications:
- A skill that activates only for `3-Zettelkasten/**` and enforces atomic note format
- A skill that activates for Lectic-frontmatter documents (currently `.md` files) and knows Lectic syntax
- A skill that activates for `1-Projects/**` and knows the PARA project conventions

### 4e. `SessionStart` Hook + CLAUDE.md `@import`

The `InstructionsLoaded` hook fires after CLAUDE.md loads. Useful for debugging which files were loaded in a session. If context seems incomplete, this hook can log what was imported.

### 4f. `context: fork` in Skills

For vault operations that would pollute your main conversation context, a skill with `context: fork` runs the task in an isolated subagent and returns a summary. Useful for: "read all notes tagged #ethnography and tell me what's missing from the NSEW link graph" — heavy file I/O that you want summarized, not streamed into your conversation.

---

## 5. Recommended Agents, Commands, and Skills

### 5a. Immediate Wins

| Skill/Command | Purpose | Scope |
|---|---|---|
| `/init` (user-global) | Load both repo contexts from any CWD | `~/.claude/skills/init/` |
| `/vault-status` | Git status + recent changes in SecondBrain | `~/SecondBrain/.claude/commands/` |
| `/zettel-from-doc` | Invoke librarian to decompose a Lectic synthesis doc into atomic notes | `~/SecondBrain/.claude/commands/` |
| `/vault-context` | Find relevant vault notes and insert as Lectic context links | `~/SecondBrain/.claude/commands/` |
| `/lectic-debug` | Invoke lectic-dev agent to troubleshoot current file | `~/.config/nvim/.claude/commands/` |

### 5b. Lectic Integration Skills

The 12-persona switching system (`<leader>mp`) is already fully functional — Researcher, Writer, Editor, Consultant, and others are all available mid-document in single-party mode. The "underutilizing Lectic" problem is therefore not about missing personas but about workflow patterns: how to move fluidly between Lectic output and Zettelkasten structure.

The highest-leverage Claude Code skill here is the **Lectic→Zettelkasten handoff**:

1. You produce a large synthesis document in Lectic (e.g., ethnographic methods overview, researched with Researcher persona, refined with Writer)
2. You invoke `/zettel-from-doc` (or similar) in Claude Code
3. Claude reads the Lectic document, identifies atomic concepts, creates individual note files in `3-Zettelkasten/` with NSEW links populated by cross-referencing existing vault notes
4. Returns a summary of what was created and what link candidates couldn't be resolved

This is the seam between the two tools. Lectic does the thinking; Claude Code does the filing.

**The other Lectic underutilization:** context links. Lectic can load any vault note as context via markdown links in the document body — `[Note Title](../3-Zettelkasten/note.md)`. A Claude Code skill that reads a Lectic document, searches the vault for topically relevant notes, and inserts those links would make it trivial to bring Zettelkasten knowledge into a Lectic research session. This is the reverse direction of the handoff above.

### 5c. Zettelkasten Enhancement

The planned project `003_zettelkasten_refinement` overlaps directly with this. Key capabilities worth prioritizing:

- **Telescope search across the vault** (already planned in project 003) — this is the highest-friction point in the current Zettelkasten workflow
- **NSEW link suggestions** — an agent or skill that reads a note and suggests candidates for each directional link based on vault content
- **Orphan note detection** — a `/vault-audit` skill that finds notes with no NSEW links
- **obsidian-nvim backlink navigation** — the community fork adds LSP-style rename that updates backlinks vault-wide; this is the most valuable new feature for Zettelkasten maintenance

---

## 6. Plugin Recommendations

### 6a. Priority: Upgrade obsidian-nvim

**Current:** `epwalsh/obsidian.nvim` (stalled, accumulating bugs)
**Recommended:** `obsidian-nvim/obsidian.nvim` (community fork, actively maintained)

**Key new features relevant to your setup:**
- `blink.cmp` native support (your completion engine — no more blink.compat wrapper needed for Obsidian completion)
- `snacks.picker` integration (consistent with your existing snacks.nvim usage)
- Checkbox and heading folding (complements ufo)
- LSP-style vault-wide rename (critical for Zettelkasten maintenance)

**Breaking changes to address during migration:**
1. Callback signatures — remove `client` parameter from any custom callbacks
2. No auto H1 on new notes — add to template if desired
3. Completion now triggers only on `[[` (actually an improvement)
4. Bare URLs need markdown syntax (low impact)

**Migration path:** Incremental. Follow startup warnings. No big-bang rewrite needed.

### 6b. Folding Mode Switching (Lectic LSP vs. Treesitter)

**Current state (project 011):** nvim-ufo is configured with treesitter provider for `.md` files and LSP provider for `.lec` files (hardcoded by filetype). Since Lectic work happens primarily in `.md` files, LSP folding is not currently active for most Lectic documents.

**Desired behavior:** A buffer-local toggle between LSP-based folding (Lectic research mode — folds tool-call blocks and conversation history) and treesitter heading-based folding (writing mode — folds by document structure). This is especially useful for `.md` files that serve dual purposes: heavy Lectic research sessions and then writing-focused editing.

**Recommended solution: A buffer-local toggle in ufo**

nvim-ufo supports per-buffer provider override via `require('ufo').setProviderSelector`. Add a toggle function:

```lua
-- In lua/plugins/ufo.lua or lua/core/functions.lua
local function toggle_fold_mode()
  local providers = vim.b.ufo_provider_mode
  if providers == "lsp" then
    require('ufo').setProviderSelector(0, function() return {'treesitter', 'indent'} end)
    vim.b.ufo_provider_mode = "treesitter"
    vim.notify("Fold mode: treesitter (writing)", vim.log.levels.INFO)
  else
    require('ufo').setProviderSelector(0, function() return {'lsp', 'indent'} end)
    vim.b.ufo_provider_mode = "lsp"
    vim.notify("Fold mode: LSP (research)", vim.log.levels.INFO)
  end
  -- Refresh folds
  vim.cmd('normal! zx')
end
```

Bind to `<leader>mfl` (fold: toggle mode) in which-key. The `vim.b` variable tracks state per-buffer so switching one document doesn't affect others.

**This avoids creating a new plugin** — it's a 15-line addition to the existing ufo config.

### 6c. Other Recommended Plugins

**High priority:**

| Plugin | Purpose | Why Now |
|---|---|---|
| `MeanderingProgrammer/render-markdown.nvim` | Already installed | N/A — keep current |
| `folke/snacks.nvim` | Already installed | N/A — keep current |

**Worth adding:**

| Plugin | Purpose | Notes |
|---|---|---|
| `nvim-telescope/telescope-fzf-native.nvim` | Faster Telescope sorting | Low-friction upgrade; Zettelkasten vault search speed |
| `nvim-pack/nvim-spectre` | Project-wide find/replace | Useful for vault-wide rename of concepts before obsidian-nvim's LSP rename is available |
| `epwalsh/pomo.nvim` | Pomodoro timer in statusline | Low overhead; supports writing sessions and coaching prep |
| `folke/twilight.nvim` | Dims non-active paragraph | Complements zen mode for long-form writing sessions |

**Likely not needed:**

- `zk-nvim` — overlaps with obsidian-nvim; your PARA+Zettelkasten hybrid is well-served by obsidian-nvim
- `neorg` — full replacement of your note system; too disruptive
- `copilot.nvim` — you use Lectic for AI assistance; Copilot would conflict or duplicate

---

## 7. Repo Infrastructure Standard

All three repos should have a root `CLAUDE.md` for CWD orientation and a `.claude/` folder for operational tracking. Depth scales with the complexity of the work:

| Repo | `CLAUDE.md` | `.claude/` contents |
|---|---|---|
| `~/.config/nvim/` | Yes (exists) | Full: `specs/`, `PROJECT_CONTEXT.md`, `SESSION_PROTOCOL.md`, `GLOBAL_SUMMARY_LOG.md` |
| `~/ghostdev/` | Create | Medium: `specs/` with project folders, `MAINTENANCE_LOG.md` |
| `~/SecondBrain/` | Yes (exists) | Light: `vault-log.md` for structural decisions and major Claude Code operations |

**SecondBrain `vault-log.md`** replaces the full session log system. It records: major PARA restructuring, significant vault-wide Claude Code operations (e.g., decomposing a Lectic doc into 20 atomic notes), and convention decisions (e.g., new tag schemas). No phase tracking or implementation plans needed — the vault is content, not code.

**ghostdev** follows the nvim pattern more closely since it involves actual code (Handlebars, CSS, JS). A `specs/` folder allows project tracking for theme features or major changes, and a maintenance log captures smaller fixes.

---

## 8. Other Suggestions

### 8a. Lectic Multi-Party Mode

Verify current status before planning new workflows. Check `https://github.com/gleachkr/Lectic/releases` for changelog entries post-beta6 regarding multi-party stability. If fixed, re-enabling the commented-out business and writing persona modes would be the highest-leverage Lectic improvement available. The infrastructure for it is already in your config — it just needs the comments removed and testing.

### 8b. Zettelkasten Workflow Formalization

Project 003 is planned but unstarted. Given your stated goal of building "an extremely powerful and intuitive Zettelkasten workflow," it deserves prioritization. The minimum viable improvements:

1. A Telescope search that scans note body content, not just filenames (ripgrep-backed live grep in vault)
2. An `/nsew` command or keymap that reads the current note and suggests NSEW link candidates from the vault
3. A template for new Zettel notes that pre-fills all six fields (Tags, Sources, West, East, North, South)

The obsidian-nvim upgrade unlocks #2 and #3 more cleanly.

### 8c. Consulting Portfolio

The SecondBrain currently lacks a dedicated consulting portfolio overview document. Based on the CV and coaching files, Nathan runs two practice lines:
- **Organizational** (Potential Project / Fortune 500 work)
- **Individual** (coaching: Danny Carlson, Dana Plays, Elan Spitzberg, etc.)

A `2-Areas/Consulting/consulting-portfolio.md` file summarizing current offerings, client types, and active engagements would give Claude useful business context for helping with proposals, coaching materials, and program design — work that appears frequently in the vault.

### 8d. SESSION_PROTOCOL.md is Too Long

At ~19KB, SESSION_PROTOCOL.md is the largest file in the context system and is currently only loaded via `/init` in the nvim CWD. The verification protocol, collaborative work style, and pronoun handling rules in it are universal and would benefit from being globally available. The nvim-specific documentation rules (maintenance logs, session logs, phase commits) should stay nvim-local.

Recommended split:
- `~/.claude/BEHAVIOR.md` (~4KB) — universal rules, globally imported
- `~/.config/nvim/.claude/SESSION_PROTOCOL.md` — trimmed to nvim-specific documentation and git rules only

### 8e. Profile Memory vs. CLAUDE.md

The auto-memory system accumulates facts across sessions. Consider treating `~/.claude/PROFILE.md` (the bio/consulting summary from 1c above) as a hybrid: it can also become a memory file that Claude updates when your professional context changes (new client, new program launch, completed project). This reduces the need to manually maintain the profile document over time.

---

## Summary of Recommended Next Steps

Once this report is reviewed and refined, a plan should address these in order:

| Priority | Action | Effort |
|---|---|---|
| 1 | Create `~/.claude/settings.json` with global read permissions + security denies (incl. Ghost folders) | Small |
| 2 | Create `~/.claude/PROFILE.md` with professional bio/context summary | Small |
| 3 | Create `~/.claude/BEHAVIOR.md` by extracting universal rules from SESSION_PROTOCOL.md | Medium |
| 4 | Update `~/.claude/CLAUDE.md` to `@import` PROFILE.md, BEHAVIOR.md, nvim PROJECT_CONTEXT.md | Small |
| 5 | Create user-global `/init` skill at `~/.claude/skills/init/SKILL.md` | Small |
| 6 | Add Lectic clarification (filetype + doc URLs) to nvim CLAUDE.md | Small |
| 7 | Add ufo fold-mode toggle to `lua/plugins/ufo.lua` | Small |
| 8 | Upgrade to `obsidian-nvim/obsidian.nvim` | Medium |
| 9 | Check Lectic multi-party status; re-enable if fixed | Small/Large |
| 10 | Create `~/ghostdev/CLAUDE.md` and `ghost-dev.md` agent | Small |
| 11 | Start project 003 (Zettelkasten refinement) with updated scope | Large |

---

*This report is for review. Edit collaboratively before creating a PLAN.md.*
