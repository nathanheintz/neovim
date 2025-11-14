# Neovim Second Brain - Implementation Plan

**Created**: 2025-11-09
**Status**: COMPLETED (2025-11-12)

## Overview

Transform neovim into a comprehensive second-brain and coding environment optimized for writing, research, publishing, and Ghost theme development. Fork from Ben's NeoTex config and adapt for writing/publishing workflow with Lectic AI, Obsidian integration, and streamlined keybindings.

## Phase 1: Foundation & Cleanup [COMPLETED]
- [x] Fork from Ben's NeoTex config to `nvim-custom` branch
- [x] Move from nested `lua/neotex/` to conventional `lua/` structure
- [x] Clean out Ben-specific features (NixOS, Avante, Kanban)
- [x] Clean which-key menus - remove Ben's mappings
- [x] Reorganize which-key menu structure for writing workflow
- [x] Delete unused top-level mappings (kanban, vimtex direct bindings)
- [x] Create new WINDOW menu (`<leader>w`)
- [x] Create new CODE menu (`<leader>c`)
- [x] Merge WRITING + MARKDOWN → `<leader>m` menu
- [x] Transform PANDOC → PUBLISHING menu (`<leader>p`)
- [x] Clean TEMPLATES menu
- [x] Create SURROUND submenu (`<leader>ms`)
- [x] Create TOGGLES submenu (`<leader>mt`)

## Phase 2: Lectic Integration [COMPLETED]
- [x] Install Lectic plugin
- [x] Investigate multi-party conversations (BLOCKED - broken in beta6)
- [x] Implement single-party mode with persona switching
- [x] Create 12 persona definitions (Consultant, Marketing, Finance, Product, Researcher, Writer, Editor, Designer, Scholar, Scribe, Homie, Nomad)
- [x] Add persona switching menu (`<leader>mp` submenu)
- [x] Create new file command (`<leader>mn` with Homie persona)
- [x] Add context link insertion (`<leader>mc`)
- [x] Disable multi-party code (comment with reason)
- [x] Update Lectic cheatsheet documentation

## Phase 3: Configuration Refinements [COMPLETED]
- [x] Fix which-key Kitty terminal bug (Space key corruption)
- [x] Implement CWD-based colorscheme auto-switching
- [x] Disable auto-format-on-save (keep manual `<leader>af`)
- [x] Clean up documentation directory (remove Ben's docs)
- [x] Move nvim-cheatsheet.md → CHEATSHEET.md
- [x] Keep useful cheatsheets (Lectic, LazyGit, Deckset, generic Vim)
- [x] Create bug report for which-key issue
- [x] Update README with current state

## Phase 4: Completion Toggles [COMPLETED]
- [x] Disable buffer completion by default in markdown files
- [x] Keep buffer completion ON in code files
- [x] Create toggle for buffer completion (`<leader>mtb`)
- [x] Create toggle for Obsidian completion (`<leader>mto`)
- [x] Create toggle for snippet completion (`<leader>mtx`)
- [x] Add toggle keybindings to which-key

## Success Criteria

- ✅ Config reflects actual usage (Lectic not Avante, Deckset included, writing-focused not LaTeX-academic)
- ✅ Which-key works reliably in Kitty terminal
- ✅ Colorschemes auto-switch by project directory
- ✅ Lectic personas functional with single-party mode
- ✅ Completion toggles reduce noise while writing markdown
- ✅ Documentation is accurate and up-to-date

## Notes

- Multi-party Lectic conversations broken in beta6 - using single-party with manual switching instead
- Which-key bug with Kitty terminal required auto-patch on startup
- Removed format-on-save to prevent unwanted stylua reformatting
- Buffer completion disabled by default in markdown to reduce noise from open SecondBrain buffers
- Publishing workflows split to Project 004
- Zettelkasten refinement split to Project 003
