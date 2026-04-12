# 014: Agents, Commands & Skills — Plan

**Status**: Phase 1 complete (2026-04-12). Phase 2 not yet started.
**Depends on**: 012 PLAN2 (Claude optimization) can proceed in parallel — agents will be
updated as part of that project, but this plan's Phase 1 is independent.
**CWD**: `~/.config/nvim` (for Lectic config) and `~/SecondBrain` (for vault skills)

---

## Agent Notes

**nvim-dev agent**: Parked for now. The nvim-dev.md file is being updated as part of
012 PLAN2 — its content (Lectic facts, paper_search config, persona-switching workflow)
will flow into main session context via the CWD-conditional /init instead of requiring
agent invocation. Do not invoke nvim-dev as a specialist during this plan's execution.

**Key facts:**
- Lectic works in `.md` files (primary) and `.lec` files. The plugin loads for both `markdown` and `lectic.markdown` filetypes. Do not suggest filetype changes.
- Obsidian and Lectic frontmatter coexist in the same `.md` files without conflict. Never suggest separating them.
- Skills/commands live in `.claude/commands/` (project-scoped) or `~/.claude/skills/` (user-scoped).
- Lectic documentation: `https://grahamlk.me/Lectic/llms-full.md` (complete, single URL).
- Lectic source: `https://github.com/gleachkr/Lectic`

---

## Phase 1: Lectic Multi-Party Mode — Investigation and Fix

### Background

Nathan's primary writing workflow is switching personas mid-document using `<leader>mp[key]`
(mpr=Researcher, mpw=Writer, mpe=Editor, etc.). This was implemented via `SwitchLecticPersona()`
in `lua/plugins/lectic.lua` — a custom build that rewrites `interlocutor:` (singular) in
the frontmatter on each switch.

**This is now broken.** Lectic v0.0.3 (released 2026-03-31) introduced strict document
history parsing. It reads `:::Name` response blocks from the full document and validates
each against the list of known interlocutors. When `interlocutor:` (singular) only defines
one persona, any `:::PreviousPersona` block from earlier in the conversation throws:
`interlocutor [Name] can't be found!`

The frontmatter-switching approach is fundamentally incompatible with v0.0.3's history
parsing. It needs to be replaced.

**What Nathan wants**: Use Lectic multi-party mode as Graham intends it — multiple personas
available in a single document, switching between them naturally, without overly complex
frontmatter.

### The Multi-Party Approach

Lectic's native multi-party format uses `interlocutors:` (plural) with an array of personas.
Each persona is then addressed via the `:::Name` directive syntax. This is what v0.0.3
was built for.

**The frontmatter complexity concern**: Defining all persona prompts inline means very long
YAML. However, Lectic v0.0.2 added `imports:` support — top-level imports that load config
from external files. This may allow persona definitions to live in `~/.config/lectic/lectic.yaml`
(which already exists and defines the paper_search tool) and be referenced in documents
without repeating full prompts.

This needs to be investigated before designing the fix.

### Investigation Steps

- [x] Fetch `https://grahamlk.me/Lectic/llms-full.md` — read in full
- [x] Read `~/.config/lectic/lectic.yaml` — understood current structure
- [x] Read `lua/plugins/lectic.lua` in full — understood current state
- [x] Design the replacement workflow

### Design Decisions

- [x] Decide: define personas in lectic.yaml (global) — confirmed, no frontmatter duplication needed
- [x] Decide: keep `<leader>mp` switching — yes, but now inserts `:ask[Name]` instead of rewriting frontmatter
- [x] Decide: existing documents — `:::Name` blocks validate correctly once named personas are in lectic.yaml
- [x] Draft proposed changes — approved, implemented

**Notes:**
- `kit:` references a `kits:` top-level array. `- kit: paper_search` in Researcher's `tools:` is valid
  and working. Researcher entry in `~/Library/Preferences/lectic/lectic.yaml` uses `tools: - kit: paper_search`.
- macOS critical finding: Lectic reads `~/Library/Preferences/lectic/lectic.yaml`, NOT `~/.config/lectic/lectic.yaml`.
  The latter is silently ignored. Writing personas to wrong file caused `:ask[Editor]` failure.
- Document frontmatter: `interlocutor: name: Scholar / prompt:` (empty prompt is valid — Lectic merges full
  prompt from system config). No `provider:` needed.
- `SwitchLecticPersona()` inserts `:ask[Name] ` at cursor and enters insert mode — no frontmatter mutation.
- `CreateNewLecticFile()` and `AddLecticFrontmatter()` write minimal frontmatter (name + empty prompt only).
- `persona_modes` table and `all_personas` table removed from lectic.lua. `scholar_prompt` local var removed.

### Implementation Steps

- [x] Update `~/Library/Preferences/lectic/lectic.yaml` — all 12 personas + kits defined globally
- [x] Update `lua/plugins/lectic.lua` — SwitchLecticPersona, CreateNewLecticFile, AddLecticFrontmatter
- [x] Update `lectic-cheatsheet.md` to reflect new workflow
- [x] Test: fresh file, multi-persona conversation, persona switching — confirmed working
- [x] Update all context docs with correct macOS config path
- [x] Update GLOBAL_SUMMARY_LOG.md

---

## Phase 2: Vault Operation Skills

**Dependency**: 012 PLAN2 agent updates should be complete before these skills are written,
so the librarian agent they invoke is accurate.

### 2a. `/vault-status`

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

### 2b. `/zettel-from-doc`

**File:** `~/SecondBrain/.claude/commands/zettel-from-doc.md`

Hands off a Lectic synthesis document to the librarian agent for decomposition into atomic
Zettelkasten notes. Brief to be written once librarian agent is finalized in 012 PLAN2.

### 2c. `/vault-context`

**File:** `~/SecondBrain/.claude/commands/vault-context.md`

Finds relevant vault notes and inserts them as Lectic context links in the current document.
Brief to be written once librarian agent is finalized in 012 PLAN2.

### 2d. `/lectic-debug`

**File:** `~/.config/nvim/.claude/commands/lectic-debug.md`

Invokes nvim-dev to troubleshoot Lectic configuration issues. To be written once nvim-dev
agent is finalized in 012 PLAN2.

### Steps

- [ ] Create `~/SecondBrain/.claude/commands/` directory
- [ ] Write vault-status.md
- [ ] Write zettel-from-doc.md (after 012 PLAN2 Phase 3b complete)
- [ ] Write vault-context.md (after 012 PLAN2 Phase 3b complete)
- [ ] Write lectic-debug.md (after 012 PLAN2 Phase 3c complete)
- [ ] Test each skill

---

## Completion Checklist

- [x] Phase 1: Lectic multi-party working, workflow documented, config updated (2026-04-12)
- [ ] Phase 2: All four skill files created and tested
- [x] GLOBAL_SUMMARY_LOG.md updated
