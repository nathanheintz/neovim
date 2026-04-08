# 013: Plugin Upgrades — Plan

**Status**: Not started
**Depends on**: 012 (Claude Workflow Optimization) — obsidian-nvim migration should happen after the new obsidian-nvim docs are loaded into the librarian agent context
**CWD**: `~/.config/nvim`

---

## Overview

Three workstreams:
1. Migrate `epwalsh/obsidian.nvim` → `obsidian-nvim/obsidian.nvim` (community fork)
2. Add buffer-local fold-mode toggle to nvim-ufo
3. Zettelkasten workflow improvements: live grep keybinding + NSEW note template

---

## Agent Notes

**Before starting:** Run `/init` or invoke `nvim-dev` to load full config context.

**Key files for this project:**
- `lua/plugins/obsidian.lua` — obsidian plugin config (current: epwalsh, simple opts-based, no callbacks)
- `lua/plugins/ufo.lua` — ufo config with `ToggleHeadingFolds()` global function and `provider_selector` per filetype
- `lua/plugins/which-key.lua` — all leader keybindings; fold toggle goes in `<leader>m` (MARKDOWN) group
- `lua/plugins/lsp/blink-cmp.lua` — completion sources; obsidian currently uses blink.compat wrapper
- `~/SecondBrain/4-Resources/Obsidian-Templates/` — template folder for new note templates

**Critical constraints:**
- Obsidian and Lectic frontmatter coexist in the same `.md` files. Never suggest separating them. Obsidian fields: `id`, `aliases`, `tags`. Lectic fields: `interlocutor`, `interlocutors`, `memories`. Neither overwrites the other.
- Lectic works in `.md` files (primary workflow) and `.lec` files. Do not suggest filetype changes.
- Discuss all proposed changes before implementing. Show code for approval. Work one phase at a time.

---

## Phase 1: obsidian-nvim Community Fork Migration

### Background

Current plugin: `epwalsh/obsidian.nvim` — stalled, accumulating bugs.
Target plugin: `obsidian-nvim/obsidian.nvim` — active community fork.

**New features to enable:**
- Native `blink.cmp` support (eliminates blink.compat wrapper for obsidian completion)
- `snacks.picker` integration (consistent with existing snacks.nvim usage)
- LSP-style vault-wide rename (critical for Zettelkasten maintenance)
- Checkbox and heading folding (complements ufo)

**Breaking changes to handle:**
1. Completion config syntax changes — `nvim_cmp = true` becomes native blink.cmp config
2. Picker config — telescope still works but snacks.picker is preferred
3. Callback signatures — `client` parameter removed from all callbacks (current config has no callbacks, so low impact)
4. No auto H1 on new notes — if desired, add to template
5. Completion triggers only on `[[` — this is an improvement, no action needed
6. Bare URLs must be in markdown syntax — low impact, not in current config

### Steps

- [ ] Fetch and read the obsidian-nvim/obsidian.nvim README and wiki before making changes: `https://github.com/obsidian-nvim/obsidian.nvim`
- [ ] Read `lua/plugins/obsidian.lua` (current config)
- [ ] Read `lua/plugins/lsp/blink-cmp.lua` (current completion sources for obsidian)
- [ ] Draft updated `lua/plugins/obsidian.lua` with:
  - Plugin source changed to `"obsidian-nvim/obsidian.nvim"`
  - Completion updated for native blink.cmp (remove nvim_cmp compat)
  - Picker updated to snacks.picker
  - Workspace, templates path unchanged
- [ ] Show proposed changes for approval
- [ ] Update `lua/plugins/lsp/blink-cmp.lua` to remove blink.compat obsidian wrapper if native support confirmed
- [ ] Test: open SecondBrain note, verify `[[` completion works, verify wiki-link navigation works
- [ ] Test: attempt vault-wide rename on a test note, verify backlinks update
- [ ] Update the librarian agent at `~/.claude/agents/librarian.md`:
  - Change obsidian docs URL from `https://github.com/epwalsh/obsidian.nvim` to `https://github.com/obsidian-nvim/obsidian.nvim`
  - Update the "currently installed" note to reflect migration is complete
- [ ] Update MAINTENANCE_LOG.md

---

## Phase 2: UFO Fold-Mode Toggle

### Background

Current state: `lua/plugins/ufo.lua` has `provider_selector` hardcoded by filetype — treesitter for `markdown`, lsp for `lectic.markdown`. Since Lectic work happens primarily in `.md` files, LSP folding is not active for most Lectic documents.

Desired behavior: a buffer-local toggle between:
- **LSP mode** — Lectic research/conversation mode; folds tool-call blocks and conversation history
- **Treesitter mode** — writing mode; folds by heading structure (already implemented via `ToggleHeadingFolds()`)

The toggle should be buffer-local (switching one buffer doesn't affect others) and notify the user of the current mode.

### Implementation

Add to `lua/plugins/ufo.lua` inside the `config` function, after the existing `ufo.setup()` call:

```lua
-- Buffer-local fold mode toggle (LSP ↔ treesitter)
-- Use when switching between Lectic research mode and writing mode in .md files
function _G.ToggleFoldMode()
  local bufnr = vim.api.nvim_get_current_buf()
  local mode = vim.b[bufnr].ufo_fold_mode or "treesitter"
  if mode == "treesitter" then
    require('ufo').setProviderSelector(bufnr, function() return { 'lsp', 'indent' } end)
    vim.b[bufnr].ufo_fold_mode = "lsp"
    vim.cmd('normal! zx')
    vim.notify("Fold mode: LSP (research)", vim.log.levels.INFO)
  else
    require('ufo').setProviderSelector(bufnr, function() return { 'treesitter' } end)
    vim.b[bufnr].ufo_fold_mode = "treesitter"
    vim.cmd('normal! zx')
    vim.notify("Fold mode: treesitter (writing)", vim.log.levels.INFO)
  end
end
```

Add to `lua/plugins/which-key.lua` in the `<leader>m` (MARKDOWN & WRITING) group, near existing fold bindings:

```lua
{ "<leader>mfl", "<cmd>lua ToggleFoldMode()<cr>", desc = "toggle fold mode (lsp/treesitter)" },
```

### Steps

- [ ] Read `lua/plugins/ufo.lua` in full
- [ ] Read `lua/plugins/which-key.lua` to find correct location in `<leader>m` group
- [ ] Show proposed additions for approval
- [ ] Add `ToggleFoldMode()` to `lua/plugins/ufo.lua`
- [ ] Add `<leader>mfl` keybinding to `lua/plugins/which-key.lua`
- [ ] Test: open `.md` file with Lectic frontmatter, toggle to LSP mode, verify fold behavior changes
- [ ] Update MAINTENANCE_LOG.md

---

## Phase 3: Zettelkasten Workflow Improvements

### 3a. Live Grep Keybinding for Vault

Telescope with telescope-fzf-native is already installed and configured. The vault needs a dedicated live grep keybinding scoped to `~/SecondBrain/`.

Add to `lua/plugins/which-key.lua` in the `<leader>f` (FIND) group:

```lua
{ "<leader>fz", function()
    require('telescope.builtin').live_grep({ search_dirs = { vim.fn.expand("~/SecondBrain") } })
  end, desc = "live grep vault (SecondBrain)" },
```

### 3b. Zettelkasten Note Template

Create `~/SecondBrain/4-Resources/Obsidian-Templates/zettelkasten.md`:

```markdown
---
id: {{date:YYYYMMDDHHmm}}
aliases: []
tags: []
---

# {{title}}

### Tags: #
### Sources:
### West:
### East:
### North:
### South:
```

This pre-fills all six required Zettelkasten fields (Tags, Sources, NSEW directional links). The `id` uses Obsidian's date templating syntax.

### Steps

- [ ] Read `lua/plugins/which-key.lua` to find the `<leader>f` group
- [ ] Show proposed keybinding for approval
- [ ] Add `<leader>fz` vault live grep keybinding
- [ ] Check whether `~/SecondBrain/4-Resources/Obsidian-Templates/` already has a zettelkasten template
- [ ] Create or update the zettelkasten template file
- [ ] Test: `<leader>fz` opens live grep scoped to SecondBrain
- [ ] Test: new note creation uses template with NSEW fields
- [ ] Update MAINTENANCE_LOG.md

---

## Completion Checklist

- [ ] Phase 1: obsidian-nvim migration complete and tested
- [ ] Phase 2: fold-mode toggle working in `.md` files
- [ ] Phase 3: live grep and template in place
- [ ] CHEATSHEET.md updated with new keybindings (`<leader>mfl`, `<leader>fz`)
- [ ] MAINTENANCE_LOG.md updated
- [ ] `~/.claude/agents/librarian.md` updated with obsidian-nvim/obsidian.nvim docs URL
- [ ] Git commit
