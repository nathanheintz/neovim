# 012: Claude Workflow Optimization — Plan 2

**Date**: 2026-04-11
**Status**: Complete (2026-04-11)
**Scope**: Claude context architecture only. Lectic fix (SwitchLecticPersona) is a separate project (014).
**Context**: Follows diagnosis session 016. See 016_context_memory_diagnosis/ for full transcript and report.

---

## Desired Functionality

The agent should arrive at any session already knowing:
1. Who Nathan is, how to behave, and where everything lives (global, always-on)
2. A full, detailed overview of the CWD it's working in (auto-loaded by CWD)
3. Where to go for deeper context when a task requires it — and the rule for when to go there

**Mental model**: The agent is in a room with labeled drawers. The global context is the room map. The CWD-specific context opens the right drawer automatically. Deeper context (plugin docs, Lectic docs, project logs) is fetched on demand — the agent knows the drawers exist and what's in them, but doesn't open them until the task calls for it.

**Specifically**: When a Lectic issue arises from SecondBrain CWD, the agent already knows:
- The Lectic docs URL (pointer in global map — fetch on demand, not pre-loaded)
- That lectic.yaml exists at `~/Library/Preferences/lectic/lectic.yaml` on macOS and what it does
- That Lectic issues are nvim-config-related and require loading nvim context
- The available personas and how persona switching works in practice
- That it should NOT guess URLs, should NOT search blindly — it has the map

---

## Architecture: Three Layers

### Layer 1 — Global (always loaded, every session, every CWD)

**File**: `~/.claude/CLAUDE.md`

The master map. Contains:
- @imports: PROFILE.md, BEHAVIOR.md only
- Overview of all three CWDs: what they are, what work happens in each
- Key reference pointers: lectic.yaml path, Lectic docs URL, plugin GitHub pattern
- Routing rules: "Lectic functionality questions → load nvim CLAUDE.md + fetch Lectic docs"; "SecondBrain behavior issues → likely nvim config, load nvim CLAUDE.md"
- Where everything lives: key files across all repos, what they're for
- Agent continuity rules, /init instruction

Does NOT contain: deep plugin lists, keybinding tables, full Zettelkasten conventions — those live in Layer 2.

### Layer 2 — CWD-Specific (auto-loaded by Claude Code based on repo root)

Claude Code automatically loads the `CLAUDE.md` at the root of whichever repo the CWD is in. This is the intended mechanism for CWD-specific context — no skill or manual reading required.

**`~/SecondBrain/CLAUDE.md`** — auto-loaded in SecondBrain CWD
Full vault and workflow overview:
- PARA structure and folder purposes
- Zettelkasten conventions (NSEW linking, note lifecycle, frontmatter format)
- Lectic usage context: available personas, what each is for, how persona switching works in practice
- lectic.yaml: location, purpose (global Lectic config — paper_search tool, future persona definitions)
- Writing workflow: how Lectic, Obsidian, and the Zettelkasten interact
- Obsidian plugins in use and what they do
- Claude infrastructure (specs, vault-log, maintenance-log)
- Pointer: "for nvim config or Lectic functionality issues, load `~/.config/nvim/CLAUDE.md`"

**`~/.config/nvim/CLAUDE.md`** — auto-loaded in nvim CWD (NEW FILE)
Full nvim config overview:
- What the config is and what it's optimized for
- Tools used and not used
- Directory structure
- Key configuration details: Lectic, keybindings, colorscheme switching, completion toggles
- Common patterns: adding keybindings, plugins, modifying Lectic personas
- Pointer: "for plugin-specific issues, fetch that plugin's raw GitHub docs before advising"
- Pointer: "Lectic docs at https://grahamlk.me/Lectic/llms-full.md — fetch when needed"
- Known bugs and patches

**`~/ghostdev/CLAUDE.md`** — auto-loaded in ghostdev CWD (already correct, no changes)

### Layer 3 — On-Demand (fetched when the task requires it)

The agent knows these exist from Layers 1-2 and fetches only when needed:
- Lectic documentation: `https://grahamlk.me/Lectic/llms-full.md`
- Plugin GitHub repos: for any plugin-specific issue, fetch that plugin's raw GitHub
- `~/.config/nvim/CLAUDE.md`: when raised from SecondBrain CWD and nvim context is needed
- GLOBAL_SUMMARY_LOG.md: loaded by /init (project history, not always-on)
- vault-log.md: loaded by /init (structural decisions log)

---

## Current State vs Target State

### `~/.claude/CLAUDE.md`
**Currently**: @imports PROFILE.md, BEHAVIOR.md, PROJECT_CONTEXT.md. Contains three-repo overview, CWD strategy, agent continuity, stack.
**Problem**: PROJECT_CONTEXT.md @import is a workaround for missing nvim root CLAUDE.md. Content is partially right but not structured as a navigation map.
**Target**: Rewrite as master map. Remove PROJECT_CONTEXT.md @import. Keep three-repo overview but trim — deep content moves to Layer 2 files. Add:
- Lectic: what it is, docs at `https://grahamlk.me/Lectic/llms-full.md` — "the Lectic docs" always means fetch this URL, no searching
- lectic.yaml: Lectic's own global config at `~/Library/Preferences/lectic/lectic.yaml` on macOS (separate from both vault and nvim config) — holds all 12 persona definitions + paper_search kit
- Obsidian: what it is, how it integrates with the vault
- How Lectic and Obsidian frontmatter coexist in the same `.md` files
- Routing rules: Lectic questions → fetch Lectic docs + load nvim CLAUDE.md if needed; SecondBrain behavior issues → likely nvim config

### `~/.config/nvim/.claude/PROJECT_CONTEXT.md`
**Currently**: Full nvim config overview — tools, directory structure, keybindings, patterns, bugs. Globally @imported via CLAUDE.md as a workaround.
**Problem**: Lives in `.claude/` subdir, not repo root. Globally loaded when it should be CWD-conditional.
**Target**: Content migrates to `~/.config/nvim/CLAUDE.md` (new root-level file). PROJECT_CONTEXT.md is then deleted. The @import in global CLAUDE.md is removed.

### `~/SecondBrain/CLAUDE.md`
**Currently**: Thin — PARA structure, brief note conventions, one-line Lectic integration note, Obsidian plugins list, git behavior, Claude infrastructure table.
**Problem**: Not a full overview. Missing Lectic usage context, personas, lectic.yaml, writing workflow, Zettelkasten conventions.
**Target**: Expand significantly into a full vault+workflow overview equivalent in depth to PROJECT_CONTEXT.md. Covers: how to USE Lectic in practice (persona switching workflow, what each persona is for), Zettelkasten conventions and NSEW linking, writing workflow, PARA structure detail, Obsidian plugins and how they're used.

### `~/.config/nvim/CLAUDE.md`
**Currently**: Does not exist.
**Target**: Create. Full nvim config overview, consolidating content from PROJECT_CONTEXT.md. Covers: how Lectic is CONFIGURED in nvim (lectic.lua, persona table, SwitchLecticPersona, keymaps), obsidian.nvim setup, directory structure, tools used/not used, common patterns, known bugs. Includes on-demand fetch rules: "for plugin-specific issues, fetch that plugin's raw GitHub docs before advising."

### `~/.claude/skills/init/SKILL.md`
**Currently**: Reads three files regardless of CWD: GLOBAL_SUMMARY_LOG.md, SecondBrain/CLAUDE.md, ghostdev/CLAUDE.md.
**Problem**: SecondBrain/CLAUDE.md is already auto-loaded by Layer 2 — /init is redundantly reading it. /init should load supplementary context (logs, history) not overview content.
**Target**: Rewrite as CWD-conditional. Loads project history and logs appropriate to the current CWD.
- SecondBrain path: vault-log.md, GLOBAL_SUMMARY_LOG.md
- nvim config path: GLOBAL_SUMMARY_LOG.md, NVIM_STANDARDS.md, SESSION_PROTOCOL.md
- ghostdev path: ghostdev MAINTENANCE_LOG.md
- Requires verification: does `!cmd` shell execution work in SKILL.md? If not, two separate skills (/init-vault, /init-nvim) or another mechanism.

### `~/.claude/agents/nvim-dev.md`
**Currently**: Contains Lectic URL, persona table, SwitchLecticPersona description, Obsidian coexistence facts. Written for agent invocation.
**Status**: PARKED. Agent invocation model is on hold.
**Target**: Content migrates into Layer 2 files (SecondBrain/CLAUDE.md and ~/.config/nvim/CLAUDE.md). nvim-dev.md left in place but not updated or invoked.

### `~/.claude/agents/librarian.md`
**Currently**: Line ~111 says "interlocutors: (plural) is multi-party mode — currently disabled. Do not suggest using it." — OUTDATED.
**Target**: Remove that line. Will conflict directly with the upcoming SwitchLecticPersona fix (014).

### `~/SecondBrain/.claude/vault-log.md`
**Currently**: Missing entry for lectic.yaml (global Lectic config).
**Target**: Add entry documenting lectic.yaml — its location, purpose, and why it exists (Obsidian overwrites complex frontmatter).

### `~/.config/nvim/.claude/GLOBAL_SUMMARY_LOG.md`
**Currently**: Stops at project 013 (2026-04-09).
**Target**: Add entries for 014 (in progress) and 016 (context/memory diagnosis session).

### `~/.config/nvim/.claude/agents/research-specialist.md`
**Currently**: Dormant — referenced only by `commands/research.md` (now deleted).
**Target**: Leave in place. No active use.

### `~/.claude/agents/nvim-dev.md` (PARKED)
**Currently**: Referenced in global CLAUDE.md agent continuity section as if active.
**Target**: Global CLAUDE.md agent continuity section updated to note nvim-dev is parked.

### `~/.claude/skills/cleanup/SKILL.md`
**Currently**: Referenced in librarian.md only. Not visible from SecondBrain/CLAUDE.md.
**Problem**: Users running `/cleanup` from SecondBrain CWD without the librarian have no upstream reference to this skill.
**Target**: Add `/cleanup` skill reference to SecondBrain/CLAUDE.md (Claude Infrastructure section).

### `~/ghostdev/.claude/MAINTENANCE_LOG.md`
**Currently**: Exists but not referenced in ghostdev/CLAUDE.md.
**Target**: Add reference to ghostdev/CLAUDE.md.

---

## Files to Create

| File | Purpose |
|---|---|
| `~/.config/nvim/CLAUDE.md` | New root-level nvim config overview (Layer 2) |

## Files to Migrate Content From → To

| From | To | Then |
|---|---|---|
| `~/.config/nvim/.claude/PROJECT_CONTEXT.md` | `~/.config/nvim/CLAUDE.md` | Delete PROJECT_CONTEXT.md |
| `~/.claude/agents/nvim-dev.md` (Lectic/persona content) | `~/SecondBrain/CLAUDE.md` + `~/.config/nvim/CLAUDE.md` | Leave nvim-dev.md in place (parked) |

## Files to Delete

| File | Reason |
|---|---|
| `~/.config/nvim/.claude/PROJECT_CONTEXT.md` | Content migrated to `~/.config/nvim/CLAUDE.md` |
| `~/.config/nvim/.claude/commands/research.md` | Already deleted — leftover from prior approach, references non-existent files, not active |

## Files to Update (no migration, content changes only)

| File | Change |
|---|---|
| `~/.claude/CLAUDE.md` | Rewrite as master map; remove PROJECT_CONTEXT.md @import; add routing rules and pointers; note nvim-dev is parked |
| `~/SecondBrain/CLAUDE.md` | Expand to full vault+workflow overview; add /cleanup skill reference |
| `~/ghostdev/CLAUDE.md` | Add reference to `.claude/MAINTENANCE_LOG.md` |
| `~/.claude/skills/init/SKILL.md` | Rewrite as CWD-conditional |
| `~/.claude/agents/librarian.md` | Remove outdated "multi-party disabled" instruction |
| `~/SecondBrain/.claude/vault-log.md` | Add lectic.yaml entry |
| `~/.config/nvim/.claude/GLOBAL_SUMMARY_LOG.md` | Add 016 and 012-PLAN2 entries |

---

## Phase 3: Implementation

Each step shown for approval before writing. Order matters — create before delete, update logs last.

### 3a. Verify /init conditional mechanism
- [ ] Check Claude Code docs: does `!cmd` shell execution work in SKILL.md?
- [ ] Decision: one conditional /init or two separate skills (/init-vault, /init-nvim)

### 3b. Create `~/.config/nvim/CLAUDE.md`
- [ ] Draft: consolidate PROJECT_CONTEXT.md content + routing pointers + on-demand fetch rules
- [ ] Approval
- [ ] Write

### 3c. Expand `~/SecondBrain/CLAUDE.md`
- [ ] Draft: add Lectic usage context, personas, lectic.yaml, writing workflow, Zettelkasten conventions
- [ ] Approval
- [ ] Write

### 3d. Rewrite `~/.claude/CLAUDE.md`
- [ ] Draft: master map — remove PROJECT_CONTEXT.md @import, add routing rules and reference pointers, trim deep content that now lives in Layer 2
- [ ] Approval
- [ ] Write

### 3e. Delete `~/.config/nvim/.claude/PROJECT_CONTEXT.md`
- [ ] Confirm 3b is complete and content is fully preserved in nvim/CLAUDE.md
- [ ] Approval
- [ ] Delete

### 3f. Rewrite `/init` skill
- [ ] Draft based on 3a decision (conditional or split)
- [ ] Approval
- [ ] Write `~/.claude/skills/init/SKILL.md`

### 3g. Fix `~/.claude/agents/librarian.md`
- [ ] Remove "multi-party disabled" line
- [ ] Approval
- [ ] Edit

### 3g2. Update `~/ghostdev/CLAUDE.md`
- [ ] Add reference to `.claude/MAINTENANCE_LOG.md`
- [ ] Approval
- [ ] Edit

### 3h. Update `~/SecondBrain/.claude/vault-log.md`
- [ ] Add lectic.yaml entry
- [ ] Approval
- [ ] Edit

### 3i. Update `~/.config/nvim/.claude/GLOBAL_SUMMARY_LOG.md`
- [ ] Add entries for 016 diagnosis and 012 PLAN2 work
- [ ] Approval
- [ ] Edit

---

## Completion Checklist

## Complete File Inventory

Every file in the Claude context system, with its upstream reference:

| File | Upstream reference | Status |
|---|---|---|
| `~/.claude/CLAUDE.md` | Root — always loaded | Active |
| `~/.claude/PROFILE.md` | @imported by CLAUDE.md | Active |
| `~/.claude/BEHAVIOR.md` | @imported by CLAUDE.md | Active |
| `~/.claude/agents/librarian.md` | Referenced in CLAUDE.md | Active |
| `~/.claude/agents/ghost-dev.md` | Referenced in CLAUDE.md | Active |
| `~/.claude/agents/nvim-dev.md` | Referenced in CLAUDE.md | PARKED |
| `~/.claude/skills/init/SKILL.md` | Referenced in CLAUDE.md | Active |
| `~/.claude/skills/cleanup/SKILL.md` | Referenced in librarian.md + SecondBrain/CLAUDE.md (after 3c) | Active |
| `~/.claude/shared-memory/MEMORY.md` | Auto-loaded by memory system | Active |
| `~/.claude/shared-memory/feedback.md` | Indexed in MEMORY.md | Active |
| `~/.claude/shared-memory/project-structure.md` | Indexed in MEMORY.md | Active |
| `~/.claude/shared-memory/markdown-preview.md` | Indexed in MEMORY.md | Active |
| `~/.claude/settings.json` | Auto-applied by Claude Code | Active |
| `~/.config/nvim/CLAUDE.md` | Auto-loaded by Claude Code (nvim CWD) | Active (new) |
| `~/.config/nvim/.claude/PROJECT_CONTEXT.md` | Was @imported globally — being deleted | DELETED after 3e |
| `~/.config/nvim/.claude/GLOBAL_SUMMARY_LOG.md` | Loaded by /init (nvim path); referenced in nvim CLAUDE.md | Active |
| `~/.config/nvim/.claude/SESSION_PROTOCOL.md` | Loaded by /init (nvim path); referenced in nvim CLAUDE.md | Active |
| `~/.config/nvim/.claude/NVIM_STANDARDS.md` | Loaded by /init (nvim path); referenced in nvim CLAUDE.md | Active |
| `~/.config/nvim/.claude/agents/research-specialist.md` | commands/research.md (deleted) — now orphaned | Dormant |
| `~/.config/nvim/.claude/commands/research.md` | Nothing — deleted | DELETED |
| `~/.config/nvim/.claude/settings.local.json` | Auto-applied by Claude Code | Active |
| `~/.config/nvim/.claude/specs/` | Referenced in SESSION_PROTOCOL.md; summarized in GLOBAL_SUMMARY_LOG | Active |
| `~/SecondBrain/CLAUDE.md` | Auto-loaded by Claude Code (SecondBrain CWD) | Active |
| `~/SecondBrain/.claude/vault-log.md` | Referenced in SecondBrain/CLAUDE.md; loaded by /init (vault path) | Active |
| `~/SecondBrain/.claude/maintenance-log.md` | Referenced in SecondBrain/CLAUDE.md | Active |
| `~/SecondBrain/.claude/specs/` | Referenced in SecondBrain/CLAUDE.md | Active |
| `~/SecondBrain/.claude/settings.local.json` | Auto-applied by Claude Code (empty) | Active |
| `~/ghostdev/CLAUDE.md` | Auto-loaded by Claude Code (ghostdev CWD) | Active |
| `~/ghostdev/.claude/MAINTENANCE_LOG.md` | Referenced in ghostdev/CLAUDE.md (after 3g2) | Active |

---

## Completion Checklist

- [x] Phase 1: Audit complete, findings documented
- [x] Phase 2: Architecture designed and approved
- [x] Phase 1 supplemental: Full file inventory complete, no invisible files
- [x] Phase 3a: /init mechanism verified
- [x] Phase 3b: `~/.config/nvim/CLAUDE.md` created
- [x] Phase 3c: `~/SecondBrain/CLAUDE.md` expanded
- [x] Phase 3d: `~/.claude/CLAUDE.md` rewritten as master map
- [x] Phase 3e: `PROJECT_CONTEXT.md` deleted
- [x] Phase 3f: `/init` skill rewritten
- [x] Phase 3g: librarian.md fixed (interlocutors disabled line removed; note format updated)
- [x] Phase 3g2: ghostdev/CLAUDE.md updated
- [x] Phase 3h: vault-log.md updated
- [x] Phase 3i: GLOBAL_SUMMARY_LOG.md updated
