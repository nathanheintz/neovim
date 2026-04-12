# 016: Context & Memory System Diagnosis

**Date**: 2026-04-11
**CWD at time of session**: `~/SecondBrain`
**Trigger**: Debugging session exposed multiple context failures — agent didn't know about
paper_search YAML setup, Lectic docs URL, or that persona-switching mid-document is the
primary SecondBrain writing workflow.

---

## 1. Session Thread Summary

### What the user asked
- Diagnose why Lectic persona switching (`<leader>mp`) was broken after upgrading to v0.0.3
- The specific error: "can't find the researcher"

### Tool calls and reads, in order

1. `/init` — loaded: `GLOBAL_SUMMARY_LOG.md`, `SecondBrain/CLAUDE.md`, `ghostdev/CLAUDE.md`
2. Read `Amgen-UC-Apaptability.md` (first 60 lines) — saw `interlocutor: Designer` in frontmatter, "Hi researcher" in body
3. **Attempted** `WebFetch(lectic.ai/docs)` — rejected by user (wrong URL, guessed)
4. Read `SESSION_PROTOCOL.md` (nvim) — no Lectic docs URL
5. Read `lectic-cheatsheet.md` (nvim) — correct workflow info but no docs URL
6. Read `lectic.lua` (full) — found Researcher tools definition, `SwitchLecticPersona` function
7. More `Amgen-UC-Apaptability.md` reads — found `:::Researcher` blocks at line 87
8. **Attempted** `WebFetch(grahamlk.me/Lectic/llms-full.md)` — rejected (user: "already loaded for this session" — it hadn't been, user misremembered, but the URL was correct)
9. Read `nvim-dev.md` agent — found the correct URL for the first time
10. **Attempted** `WebFetch(grahamlk.me/Lectic/llms-full.md)` — rejected again ("why are you fetching again?")
11. Read `SESSION_PROTOCOL.md` (nvim, again) — no new info
12. Read Lectic CHANGELOG — v0.0.3 released 2026-03-31
13. Examined `src/parsing/parse.ts` — found the error source: line 40
14. Examined `src/types/lectic.ts` — understood `header.interlocutors` array
15. Examined `src/types/interlocutor.ts` — confirmed provider is optional
16. Multiple rounds of user correction while agent chased wrong theories
17. Searched for YAML file: `~/.config/lectic/lectic.yaml` — found via Glob
18. Read `012 REPORT.md`, `014 PLAN.md`, `NVIM_STANDARDS.md`, `maintenance-log.md`, `vault-log.md`

---

## 2. Failures Identified

### 2a. Lectic docs URL not in session context at start

**What happened**: When asked to "look at the entire Lectic documentation," the agent guessed
`lectic.ai/docs` (wrong). The correct URL (`https://grahamlk.me/Lectic/llms-full.md`) is in
`~/.claude/agents/nvim-dev.md` — but `/init` does not load that file.

**Root cause**: `/init` skill reads: `GLOBAL_SUMMARY_LOG.md`, `SecondBrain/CLAUDE.md`,
`ghostdev/CLAUDE.md`. It does not load `nvim-dev.md`. The URL was available in the system
but not in the session's context window at start.

**Fix**: `/init` should read `~/.claude/agents/nvim-dev.md` (or the URL should be added
to `GLOBAL_SUMMARY_LOG.md` or `~/.claude/CLAUDE.md`).

---

### 2b. Persona-switching-mid-document workflow not in agent's active context

**What happened**: Agent didn't know that `<leader>mp` persona switching mid-document is the
primary SecondBrain writing workflow. The user had to explain it twice. Agent kept treating
it as an edge case rather than the core use pattern.

**Where it IS documented**:
- `~/.config/nvim/.claude/specs/014_agents_commands_skills/PLAN.md` — explicitly: "Single-party
  persona switching via `<leader>mp` is fully functional and is the current primary workflow"
- `~/.config/nvim/.claude/specs/012_claude_workflow_optimization/REPORT.md` — section 5b:
  "The 12-persona switching system (`<leader>mp`) is already fully functional — Researcher,
  Writer, Editor, Consultant, and others are all available mid-document in single-party mode"
- `~/.claude/agents/nvim-dev.md` — persona table and switching behavior

**Root cause**: `/init` does not load spec PLAN files or the nvim-dev agent. This workflow
was documented in the right places for an nvim-dev session but not surfaced for a SecondBrain
session where the user is actively using it.

**Fix**: This fact belongs in `~/.claude/shared-memory/` as a user workflow memory, so it's
available in every session regardless of CWD.

---

### 2c. paper_search YAML setup undocumented

**What happened**: Agent had no knowledge of `~/.config/lectic/lectic.yaml` — the global
Lectic config that defines the `paper_search` MCP tool. When the user said "we created a
YAML file," the agent couldn't find it and had to search. The user was (correctly) frustrated
that this should be known.

**Where it is NOT documented** (checked all):
- `GLOBAL_SUMMARY_LOG.md` — mentions `kit: paper_search` injection but not the YAML file
- `~/.claude/agents/nvim-dev.md` — says "Researcher persona injects tools: - kit: paper_search"
  but does not mention `~/.config/lectic/lectic.yaml`
- `vault-log.md` — nothing about paper_search
- `maintenance-log.md` — nothing about paper_search
- `lectic-cheatsheet.md` — nothing about global YAML config
- `014_agents_commands_skills/PLAN.md` — nothing
- `012_claude_workflow_optimization/REPORT.md` — nothing

**Root cause**: This setup was completed (presumably during or after project 013) but never
logged in any documentation file. It is a complete gap in the context system.

**Fix**:
1. Document in `~/.claude/agents/nvim-dev.md` under the Lectic section
2. Add a shared memory entry so it's available everywhere
3. Add to `vault-log.md` since it affects SecondBrain Lectic files

---

### 2d. `/init` doesn't load nvim-dev.md

**What happened**: Multiple pieces of critical Lectic/nvim context are in `nvim-dev.md`
but are only available when the agent happens to read that file. In a SecondBrain session,
that file never gets read unless the agent is explicitly directed to it.

**What nvim-dev.md contains that was needed this session**:
- Lectic docs URL
- Persona switching table and workflow
- `SwitchLecticPersona` function description
- Frontmatter structure details
- Obsidian coexistence facts

**Root cause**: `/init` was designed to be lightweight (3 files). The tradeoff was correct
in principle but the nvim-dev.md content is too important to leave out of SecondBrain sessions.

**Fix options**:
- Add `~/.claude/agents/nvim-dev.md` to `/init` reads
- OR extract the "always needed" facts from nvim-dev.md into shared memory

---

### 2e. Agent didn't cross-reference project dates when reasoning about kit compatibility

**What happened**: Agent flagged `kit: paper_search` syntax as "potentially broken in v0.0.3"
and called it "unresolved." The timeline made it obviously non-issue: v0.0.3 released 2026-03-31,
paper_search added in project 012 completed 2026-04-07. It was written FOR v0.0.3.

**Root cause**: Agent was reasoning about kit syntax in isolation without checking it against
the project timeline that was in GLOBAL_SUMMARY_LOG. A basic cross-reference would have
eliminated the false uncertainty.

**Fix**: No structural fix needed — this is a reasoning failure, not a documentation gap.
The BEHAVIOR.md rule "verify before concluding" applies here.

---

### 2f. Agent second-guessed correct diagnosis under user pressure

**What happened**: The `:::Researcher` block causing the "can't find" error was the correct
diagnosis. When the user pushed back ("I've used persona switching before"), the agent
abandoned the correct diagnosis and started looking for a different explanation, wasting
significant time. The user's pushback was about a different aspect (it used to work before
the version upgrade), not about the mechanism being wrong.

**Root cause**: The BEHAVIOR.md rule says "when the user says 'no, that's not it' — stop."
But the user didn't say that — they said persona switching worked before. Agent misread that
as a contradiction of the diagnosis rather than additional context about the timeline.

**Fix**: Distinguish "user is correcting the diagnosis" from "user is adding context about
history." The former warrants stopping; the latter warrants updating the hypothesis, not
abandoning it.

---

### 2g. Repeated unnecessary WebFetch attempts

**What happened**: Agent attempted to fetch Lectic docs three times across the session, twice
having the content either in context or available from a prior read.

**Root cause**: Agent didn't track what had been fetched earlier in the session. Once the
URL was found in nvim-dev.md and the docs were fetched successfully, the agent should have
treated that as sufficient for the session.

---

## 3. Structural Fixes Required

### Fix 1: Add paper_search YAML to nvim-dev.md

In `~/.claude/agents/nvim-dev.md`, under the Lectic section, add:

```markdown
### Global Lectic Config

`~/.config/lectic/lectic.yaml` — defines the `paper_search` MCP tool globally.
Lectic loads this file automatically. The Researcher persona's `tools: - kit: paper_search`
frontmatter injection references this definition. Do not attempt to inline the MCP
configuration in the frontmatter — it lives in the global config.
```

### Fix 2: Add persona-switching workflow to shared memory

Create `~/.claude/shared-memory/lectic-workflow.md` with the core workflow fact:
persona switching mid-document (`<leader>mp`) is Nathan's primary SecondBrain writing
pattern. Survives CWD changes since shared memory is always loaded.

### Fix 3: Update /init to read nvim-dev.md

Add `~/.claude/agents/nvim-dev.md` as a fourth read in the `/init` skill. The file is
~4KB — acceptable token cost for the context it provides.

### Fix 4: Log paper_search setup in vault-log.md

Add an entry to `~/SecondBrain/.claude/vault-log.md` documenting that `~/.config/lectic/lectic.yaml`
exists and what it does, since it directly affects how Lectic files in the vault behave.

### Fix 5: Consider a /lectic-debug skill

The 014 PLAN already proposed `/lectic-debug` as a skill that pre-loads the Lectic docs URL
and invokes nvim-dev. That skill would have short-circuited most of this session's friction.
This should be prioritized.

---

## 4. What Was NOT a System Failure

- The `:::Name` history validation behavior change in v0.0.3 — this is a genuine version
  change that couldn't be pre-documented
- The user's frustration about multi-party mode — this is a real regression, not a doc gap
- The actual fix (SwitchLecticPersona accumulating interlocutors) — the architecture was
  always going to need this once v0.0.3 landed

---

## 5. Priority Order for Fixes

| Priority | Fix | File to edit |
|---|---|---|
| 1 | Add paper_search YAML to nvim-dev.md | `~/.claude/agents/nvim-dev.md` |
| 2 | Add lectic-workflow to shared memory | `~/.claude/shared-memory/lectic-workflow.md` + `MEMORY.md` |
| 3 | Add paper_search to vault-log.md | `~/SecondBrain/.claude/vault-log.md` |
| 4 | Update /init to read nvim-dev.md | `~/.claude/skills/init/SKILL.md` |
| 5 | Implement /lectic-debug skill (014 Phase 1d) | `~/.config/nvim/.claude/commands/lectic-debug.md` |
| 6 | Actually fix SwitchLecticPersona | `~/.config/nvim/lua/plugins/lectic.lua` |
