# 013: Plugin Upgrades — Plan

**Status**: Phase 1 complete
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
---

## Phase 2: UFO Fold-Mode Toggle [COMPLETED]

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

- [x] Read `lua/plugins/ufo.lua` in full
- [x] Read `lua/plugins/which-key.lua` to find correct location in `<leader>m` group
- [x] Show proposed additions for approval
- [x] Add `ToggleFoldMode()` to `lua/plugins/ufo.lua`
- [x] Add `<leader>zm` keybinding to `lua/plugins/which-key.lua` (moved to FOLDS group, not `<leader>m`)
- [x] Test: toggle to LSP mode, verify code blocks fold

**Notes:**
- `ufo.setProviderSelector()` does not exist — confirmed via source. Correct approach: detach ufo, set native `foldmethod=expr` + `foldexpr='v:lua.vim.lsp.foldexpr()'`, then reattach ufo for writing mode.
- Lectic LSP folding for `.md` files was previously handled by a manual `zc` loop in the LspAttach autocmd (`lectic.lua`). This conflicted with treesitter heading folds. Removed — ufo now owns writing mode, `vim.lsp.foldexpr()` owns research mode.
- `vim.lsp.foldexpr()` cache confirmed populated (returned `1` for a code-block start line). Folds weren't closing because `vim.o.foldlevel = 99` (set by ufo globally) keeps everything open. Fix: set `vim.wo.foldlevel = 0` when switching to research mode.
- Added `zR` before provider switch in both directions to ensure clean fold state on transition.
- Added `<leader>zc` (zM, close all) and `<leader>zo` (zR, open all) for manual control.

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

- [x] Read `lua/plugins/which-key.lua` to find the `<leader>f` group
- [x] Add `<leader>fz` vault live grep keybinding (scoped to `~/SecondBrain/3-Zettelkasten/`)
- [x] Check whether `~/SecondBrain/4-Resources/Obsidian-Templates/` already has a zettelkasten template
  - Template exists: `Template – A Zettelkasten Note.md` — has NSEW structure but no frontmatter or H1 title placeholder
- [ ] Update template: add frontmatter (id, aliases, tags) and H1 title placeholder — id format TBD by user
- [ ] Test: new note creation uses template with frontmatter + NSEW fields

---

## Phase 4: claudecode.nvim — Buffer Close Behavior Fix

### Background

Current behavior: when the ClaudeCode toggle window is open and the user runs `:bd` on the main buffer, Neovim promotes the terminal buffer (the Claude Code window) to fill the full screen. Escaping from terminal mode is severely limited — `:bd`, normal-mode commands, and most leader bindings are unavailable inside a terminal buffer. The user is effectively trapped.

Desired behavior: `:bd` on a main buffer always switches to another listed buffer in that window position first, leaving the ClaudeCode toggle undisturbed as a split.

### Root Cause

When `:bd` removes the last non-terminal buffer visible in a window, Neovim has no listed buffer to display and falls back to the terminal buffer. The terminal then expands to fill the available space. There is no built-in guard against this in either claudecode.nvim or bufferline.

### Implementation

Add a `BufDelete` autocmd in `lua/plugins/claudecode.lua` (or `lua/core/keymaps.lua`) that intercepts buffer deletion when the Claude toggle is open and ensures a valid listed buffer is switched to first:

```lua
-- Guard against ClaudeCode terminal taking over when main buffer is closed
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function(ev)
    -- Only act on normal (non-terminal, non-special) buffers
    if vim.bo[ev.buf].buftype ~= "" then return end

    -- Find a listed, loaded, non-terminal buffer to switch to
    local current = ev.buf
    local fallback = nil
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if buf ~= current
        and vim.bo[buf].buflisted
        and vim.api.nvim_buf_is_loaded(buf)
        and vim.bo[buf].buftype == ""
      then
        fallback = buf
        break
      end
    end

    if fallback then
      -- Switch every window currently showing the deleted buffer to the fallback
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == current then
          vim.api.nvim_win_set_buf(win, fallback)
        end
      end
    end
  end
})
```

This fires before Neovim completes the deletion, switches any window showing the dying buffer to the fallback, and lets bufferline manage the tab display normally.

**Alternative approach** (simpler, if the autocmd has timing issues): remap `<leader>bd` or override `:bd` with a custom command that runs the switch-then-delete logic explicitly. This gives more control over ordering.

### Key Files

- `lua/plugins/claudecode.lua` — preferred location (keeps the guard co-located with the plugin config)
- `lua/core/keymaps.lua` — fallback if the autocmd needs to be filetype-agnostic

### Steps

- [ ] Read `lua/plugins/claudecode.lua` in full
- [ ] Read `lua/core/keymaps.lua` to check for existing `:bd` remaps or buffer-close logic
- [ ] Show proposed autocmd for approval
- [ ] Add autocmd to `lua/plugins/claudecode.lua`
- [ ] Test: open ClaudeCode toggle, open two buffers, `:bd` the active one — verify toggle stays as split and bufferline switches to the other buffer
- [ ] Test: `:bd` with only one main buffer open — verify behavior is sane (probably shows empty/scratch buffer rather than terminal)

---

## Completion Checklist

- [x] Phase 1: obsidian-nvim migration complete and tested
- [x] Phase 2: fold-mode toggle working in `.md` files (+ FoldToHeadingLevel, H1 virtual padding, Left arrow fix)
- [ ] Phase 3: live grep done; template update pending (id format TBD)
- [ ] Phase 4: claudecode.nvim buffer close fix
- [x] CHEATSHEET.md updated with fold keybindings
- [x] `~/.claude/agents/librarian.md` already had obsidian-nvim URLs (updated in project 012)
- [ ] Git commit
