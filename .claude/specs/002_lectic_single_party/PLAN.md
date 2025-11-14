# Lectic Single-Party Persona System - Implementation Plan

**Created**: 2025-11-11
**Status**: COMPLETED (2025-11-11)

## Overview

Convert Lectic from broken multi-party mode to functional single-party mode with manual persona switching. Multi-party conversations in Lectic beta6 are broken (`:ask[PersonaName]` produces undefined errors), requiring a workaround using frontmatter switching.

## Phase 1: Problem Investigation [COMPLETED]
- [x] Test multi-party Lectic conversations
- [x] Identify bug: `:ask[Name]` produces undefined errors
- [x] Research alternative approaches
- [x] Decide on single-party with manual switching

## Phase 2: Single-Party Implementation [COMPLETED]
- [x] Create `all_personas` table with 12 personas
- [x] Implement `SwitchLecticPersona()` function
- [x] Preserve Obsidian frontmatter during switching
- [x] Use `interlocutor:` (singular) format
- [x] Comment out multi-party code with reason notes

## Phase 3: Context File Loading [COMPLETED]
- [x] Test `file:` prefix in frontmatter (FAILED - doesn't load)
- [x] Switch to markdown link approach in document body
- [x] Implement `InsertContextLink()` function
- [x] Add path completion support (`Ctrl+x Ctrl+f`)
- [x] Use absolute paths (tilde `~` not supported)

## Phase 4: Keybindings & UI [COMPLETED]
- [x] Create `<leader>mp` persona switching submenu
- [x] Add all 12 personas to submenu (c,m,f,p,r,w,e,d,s,b,h,n)
- [x] Add `<leader>mc` context link insertion
- [x] Simplify `<leader>mn` to always create Homie files
- [x] Remove multi-party mode selection prompt

## Phase 5: Documentation [COMPLETED]
- [x] Rewrite `cheatsheet-readme/lectic-cheatsheet.md` for single-party
- [x] Update README.md quick reference
- [x] Document multi-party as disabled
- [x] Create implementation summary
- [x] Update which-key menu descriptions

## Success Criteria

- ✅ Single-party Lectic files work reliably
- ✅ Can switch between all 12 personas
- ✅ Obsidian frontmatter preserved during switching
- ✅ Context files load via markdown links
- ✅ No multi-party errors occur
- ✅ Documentation reflects current workflow

## Personas (12 Total)

**Business** (4):
- Consultant - Strategy expert, business development
- Marketing - Storytelling, marketing strategies
- Finance - Financial planning, pricing, budgets
- Product - Service design, customer experiences

**Writing** (3):
- Researcher - Philosopher, logician, conflict resolution expert
- Writer - Design writer, minimalist accessible style
- Editor - Nonfiction editor, storytelling expert

**Workshop** (3):
- Designer - Workshop designer, facilitation tools
- Scholar - Research scientist, academic rigor
- Scribe - Succinct writer, slide notes, workshop content

**General** (2):
- Homie - Aspirational generalist, systems thinker (DEFAULT)
- Nomad - Travel planner, digital nomadism expert

## Notes

- Multi-party broken in Lectic beta6 - all multi-party code commented out
- Context loading via markdown links, NOT `file:` prefix in frontmatter
- Absolute paths required (`/Users/...`), tilde (`~`) not supported
- Persona switching is manual - cannot switch within same conversation
- When multi-party is fixed, uncomment code and restore `:ask[Name]` workflow
