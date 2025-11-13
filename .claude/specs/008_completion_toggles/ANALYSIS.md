# Completion Toggles - Analysis & Implementation

**Created**: 2025-11-11
**Status**: In Progress
**Goal**: Implement working toggle functions for blink.cmp completion sources

---

## Problem Statement

Nathan is experiencing "massive strings of related words" appearing in auto-completion while typing in insert mode. The which-key menu shows toggle commands for completion sources (`<leader>mt`), but these commands call undefined functions.

**Current which-key bindings** (`lua/plugins/which-key.lua` lines 359-369):
```lua
mt = {
  name = "TOGGLES",
  b = { "<cmd>lua _G.toggle_buffer_completion()<CR>", "toggle buffer completion" },
  c = { "<cmd>lua _G.toggle_spell_completion()<CR>", "toggle spell completion" },
  o = { "<cmd>lua _G.toggle_obsidian_completion()<CR>", "toggle obsidian completion" },
  x = { "<cmd>lua _G.toggle_luasnip_completion()<CR>", "toggle luasnip completion" },
  a = { "<cmd>lua ToggleAllFolds()<CR>", "toggle all folds" },
  f = { "za", "toggle fold under cursor" },
  m = { "<cmd>lua ToggleFoldingMethod()<CR>", "toggle folding method" },
},
```

**Issue**: The toggle functions (`_G.toggle_buffer_completion()`, etc.) do not exist anywhere in the config.

---

## Current Completion Setup

### Completion Plugin: blink.cmp

Nathan switched from a previous completion plugin to **blink.cmp** (version 1.*).

**Config location**: `lua/plugins/lsp/blink-cmp.lua`

### Active Completion Sources

**Default sources** (line 86):
```lua
default = { 'lsp', 'path', 'snippets', 'buffer' }
```

**Per-filetype sources**:
- **markdown**: `{ 'lsp', 'path', 'buffer', 'snippets', 'obsidian' }` (line 91)
- **lectic.markdown**: `{ 'lsp', 'path', 'buffer', 'snippets' }` (line 92)
- **tex**: `{ 'lsp', 'snippets', 'omni', 'path', 'buffer' }` (line 95)
- **lua/python/javascript/html/css**: `{ 'lsp', 'path', 'snippets', 'buffer' }`

### Source Provider Configuration

**Buffer completion** (lines 118-123):
```lua
buffer = {
  name = 'buffer',
  enabled = true,
  max_items = 8,
  min_keyword_length = 2,
},
```
- Currently enabled globally
- Pulls from current + other open buffers
- Shows up to 8 items
- Triggers after 2 characters

**Obsidian completion** (lines 141-149):
```lua
obsidian = {
  name = 'obsidian',
  module = 'blink.compat.source',
  enabled = function()
    return vim.bo.filetype == 'markdown'
  end,
  min_keyword_length = 2,
  max_items = 20,
},
```
- Only enabled in markdown files
- Shows up to 20 items

**Snippets completion** (lines 124-129):
```lua
snippets = {
  name = 'snippets',
  enabled = true,
  max_items = 10,
  min_keyword_length = 1,
},
```

### Auto-show Configuration

**Completion menu auto-show** (lines 176-179):
```lua
auto_show = function()
  -- Disable auto-show in zen mode
  return not vim.g.zen_mode_enabled
end,
```

Currently auto-shows completion menu unless in zen mode.

---

## Likely Culprit

The "massive string of related words" is most likely **buffer completion** which:
1. Is enabled globally
2. Pulls from all open buffers (including other markdown files in Second Brain)
3. Shows after only 2 characters (`min_keyword_length = 2`)
4. Nathan has many markdown files open with similar vocabulary

---

## Old Toggle System

### Evidence of Previous Implementation

The which-key bindings exist but the actual functions are missing. This suggests:
1. Nathan had a previous completion plugin (possibly nvim-cmp)
2. Toggle functions were written for that plugin
3. When switching to blink.cmp, the functions were removed/lost
4. Which-key bindings remained but became non-functional

### Required Toggle Functionality

Based on which-key bindings, Nathan wants toggles for:
1. **Buffer completion** - Enable/disable completion from buffers
2. **Spell completion** - Enable/disable spell checking suggestions
3. **Obsidian completion** - Enable/disable Obsidian wiki-link completion
4. **LuaSnip completion** - Enable/disable snippet expansion

---

## Implementation Strategy

### Approach for blink.cmp

blink.cmp uses a `sources.providers` configuration system where each provider has an `enabled` field that can be:
- `true` (always enabled)
- `false` (always disabled)
- `function()` (conditionally enabled)

**Toggle strategy**:
1. Store toggle state in global vim variables (e.g., `vim.g.blink_buffer_enabled`)
2. Create toggle functions that flip the state
3. Modify provider `enabled` fields to check the global state
4. Call `require('blink.cmp').reload_sources()` after toggling (if available)

### Alternative Approach

If blink.cmp doesn't support runtime source reloading:
1. Toggle by modifying `max_items` to 0 (effectively disabling)
2. Or use buffer-local variables and autocmds
3. Or notify user that restart/re-enter insert mode is needed

---

## Design Decisions Needed

### Questions for Nathan

1. **Which toggles do you actually want?**
   - Buffer completion? (likely yes - this is probably the annoyance)
   - Spell completion? (do you have spell checking enabled?)
   - Obsidian completion?
   - Snippet completion?

2. **Toggle scope**:
   - Global toggle (affects all buffers)?
   - Buffer-local toggle (only current buffer)?

3. **Toggle behavior**:
   - Complete disable (no completions from that source)?
   - Reduce to manual trigger only (require Ctrl-space)?

4. **Persistence**:
   - Remember toggle state across sessions?
   - Or reset to default on restart?

5. **Status indication**:
   - Show current state in statusline?
   - Or just notify on toggle?

---

## Next Steps

1. ✅ Document current state (this file)
2. ⏳ Get Nathan's input on which toggles are needed
3. ⏳ Design toggle functions for blink.cmp
4. ⏳ Implement toggle functions
5. ⏳ Test functionality
6. ⏳ Update documentation

---

## Notes

- blink.cmp documentation: https://github.com/saghen/blink.cmp
- Need to check if blink.cmp supports runtime source reloading
- May need to experiment with different toggle approaches
- Folding toggles (lines 366-368) appear to work - can use as reference
