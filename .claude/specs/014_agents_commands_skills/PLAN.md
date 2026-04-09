# 014: Agents, Commands & Skills — Plan

**Status**: Not started
**Depends on**: 012 (Claude Workflow Optimization) — agents librarian, nvim-dev, ghost-dev must exist before skills that invoke them are written
**CWD**: `~/.config/nvim` (for nvim-specific skills) and `~/SecondBrain` (for vault skills)

---

## Overview

Two workstreams:
1. Create vault-operation skills/commands for SecondBrain
2. Check Lectic multi-party mode status and re-enable if fixed

---

## Agent Notes

**Before starting:** Invoke `nvim-dev` to load config context.

**Key facts:**
- Lectic works in `.md` files (primary) and `.lec` files. The plugin loads for both `markdown` and `lectic.markdown` filetypes. Do not suggest filetype changes.
- Obsidian and Lectic frontmatter coexist in the same `.md` files without conflict. Never suggest separating them.
- Skills/commands live in `.claude/commands/` (project-scoped) or `~/.claude/skills/` (user-scoped).
- The `librarian` agent handles all vault operations (Zettelkasten handoff + maintenance). It must exist before `/zettel-from-doc` and `/vault-context` skills are written.
- Lectic documentation: `https://grahamlk.me/Lectic/llms-full.md` (complete, single URL).
- Lectic source: `https://github.com/gleachkr/Lectic`

**Skill file format:**
```markdown
---
name: skill-name
description: One-line description for auto-invocation matching
allowed-tools: Read, Glob, Grep, Write
---
Skill prompt content here.
```

---

## Phase 1: Vault Operation Skills

These skills live at `~/SecondBrain/.claude/commands/` (project-scoped to SecondBrain).

### 1a. `/vault-status`

Gives Claude an instant snapshot of the vault state without manual description.

**File:** `~/SecondBrain/.claude/commands/vault-status.md`

```markdown
---
name: vault-status
description: Show current vault state — recent changes, modified files, new notes
allowed-tools: Bash, Glob
---

Report the current state of the SecondBrain vault:

## Recent changes
- Modified files: !`cd ~/SecondBrain && git status --short`
- Recent notes (by modification): !`ls -lt ~/SecondBrain/3-Zettelkasten/*.md 2>/dev/null | head -10`
- Untracked files: !`cd ~/SecondBrain && git ls-files --others --exclude-standard | head -20`

Summarize what's changed and ask what to work on.
```

### 1b. `/zettel-from-doc`

Hands off a Lectic synthesis document to the librarian agent for decomposition into atomic Zettelkasten notes.

**File:** `~/SecondBrain/.claude/commands/zettel-from-doc.md`

```markdown
---
name: zettel-from-doc
description: Decompose the current Lectic synthesis document into atomic Zettelkasten notes with NSEW links
allowed-tools: Read, Write, Glob, Grep
---

Invoke the librarian agent to decompose the document at $ARGUMENTS (or the current file if no argument given) into atomic Zettelkasten notes.

The librarian should:
1. Read the source document
2. Identify distinct atomic concepts (one idea per note)
3. For each concept, create a note in ~/SecondBrain/3-Zettelkasten/ using the zettelkasten template format:
   - Tags, Sources, West, East, North, South fields populated
   - NSEW links cross-referenced against existing vault notes where possible
4. Return a summary: notes created, NSEW links populated, links that couldn't be resolved

Zettelkasten note format:
---
id: [YYYYMMDDHHmm]
aliases: []
tags: []
---
# [Note Title]
### Tags: #tag1, #tag2
### Sources: [source links]
### West: [[Similar/Adjacent note]]
### East: [[Opposite perspective note]]
### North: [[Theme/Question note]]
### South: [[What this leads to note]]

[Note body — one atomic idea]
```

### 1c. `/vault-context`

Finds relevant vault notes and inserts them as Lectic context links in the current document.

**File:** `~/SecondBrain/.claude/commands/vault-context.md`

```markdown
---
name: vault-context
description: Find relevant vault notes for the current document and insert as Lectic context links
allowed-tools: Read, Grep, Glob, Edit
---

Given the current document at $ARGUMENTS (or ask user to specify topic/keywords):
1. Search ~/SecondBrain/3-Zettelkasten/ for notes topically relevant to the document's content
2. Present a list of candidates with a one-line summary of each
3. Wait for user to confirm which to include
4. Insert confirmed notes as Lectic context links in markdown link format at the end of the document:
   [Note Title](../3-Zettelkasten/note-filename.md)

Note: these links are Lectic context links — they load the note content as context for the AI persona. Do not convert to Obsidian wiki-link format [[Note Title]].
```

### 1d. `/lectic-debug`

Invokes nvim-dev to troubleshoot Lectic configuration issues.

**File:** `~/.config/nvim/.claude/commands/lectic-debug.md`

```markdown
---
name: lectic-debug
description: Troubleshoot Lectic configuration, frontmatter, or persona issues in the current file
allowed-tools: Read, WebFetch
---

Invoke the nvim-dev agent to diagnose the Lectic issue described in $ARGUMENTS.

The agent should:
1. Read the current file's frontmatter
2. Fetch https://grahamlk.me/Lectic/llms-full.md as reference
3. Diagnose the issue against the documentation
4. Propose a fix

Key facts the agent must know:
- Lectic works in .md files (primary) AND .lec files — do not suggest filetype changes
- Obsidian and Lectic frontmatter coexist in the same file without conflict
- Obsidian fields: id, aliases, tags. Lectic fields: interlocutor, interlocutors, memories
- The nvim plugin is loaded for ft = { "markdown", "lectic.markdown" }
```

### Steps

- [ ] Create `~/SecondBrain/.claude/commands/` directory if it doesn't exist
- [ ] Create `~/SecondBrain/.claude/commands/vault-status.md`
- [ ] Create `~/SecondBrain/.claude/commands/zettel-from-doc.md`
- [ ] Create `~/SecondBrain/.claude/commands/vault-context.md`
- [ ] Create `~/.config/nvim/.claude/commands/lectic-debug.md`
- [ ] Test `/vault-status` from SecondBrain CWD
- [ ] Test `/lectic-debug` from nvim CWD

---

## Phase 2: Lectic Multi-Party Mode Check

### Background

Multi-party Lectic mode (`:ask[PersonaName]` and `:aside[PersonaName]` directives) was broken in beta6. The config currently has 12 personas disabled as multi-party modes in `lua/plugins/lectic.lua` (lines ~28-60 are commented out).

Single-party persona switching via `<leader>mp` is fully functional and is the current primary workflow.

Multi-party would enable simultaneous dialogue between personas in a single document — e.g., Researcher and Editor responding to the same prompt. This is distinct from single-party switching.

### Steps

- [ ] Fetch `https://github.com/gleachkr/Lectic/releases` and check changelog for any post-beta6 entries addressing multi-party stability
- [ ] Fetch `https://grahamlk.me/Lectic/llms-full.md` and check current documentation for multi-party status
- [ ] If fixed:
  - [ ] Read `lua/plugins/lectic.lua` in full
  - [ ] Identify the commented-out multi-party persona_modes (lines ~28-60)
  - [ ] Propose a test document with two interlocutors before uncommenting anything
  - [ ] Test multi-party in a `.md` file with `interlocutors:` (plural) frontmatter
  - [ ] If confirmed working, uncomment the business and writing persona modes in `lua/plugins/lectic.lua`
  - [ ] Update MAINTENANCE_LOG.md
- [ ] If still broken: note status and date in MAINTENANCE_LOG.md, revisit later

---

## Completion Checklist

- [ ] Phase 1: all four skill files created
- [ ] Phase 2: multi-party status checked and documented
- [ ] MAINTENANCE_LOG.md updated
