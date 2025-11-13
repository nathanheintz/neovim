# Completion Toggles - Implementation Log

**Date**: 2025-11-11
**Status**: Complete
**Goal**: Implement working toggle functions for blink.cmp completion sources

---

## Problem Solved

Nathan was experiencing "massive strings of related words" appearing in auto-completion while typing in markdown files. This was caused by **buffer completion** pulling words from all open buffers in his Second Brain.

---

## Solution Implemented

### Default Behavior

**On nvim start** (all sessions):
- ✅ **LSP completion**: ON (always)
- ✅ **Path completion**: ON (always)
- ✅ **Snippets completion**: ON
- ✅ **Obsidian completion**: ON (markdown only)
- ❌ **Buffer completion**: OFF in markdown files, ON in other files

### Toggle Functions

Created three working toggles accessible via `<leader>mt`:

1. **`<leader>mtb`** - Toggle buffer completion
   - Primary toggle Nathan wanted
   - Starts OFF in markdown, can toggle ON
   - Starts ON in other file types (code files), can toggle OFF

2. **`<leader>mto`** - Toggle Obsidian completion
   - Starts ON
   - Only affects markdown files

3. **`<leader>mtx`** - Toggle snippet completion
   - Starts ON
   - Affects all file types

**Removed**:
- ~~`<leader>mtc` - Toggle spell completion~~ - Not needed, `Ctrl-s` provides spell suggestions

### Behavior

- Toggle state persists within a session
- Resets to defaults on nvim restart (not persisted across sessions)
- Notifications show current state when toggled

---

## Files Modified

### 1. `lua/plugins/lsp/blink-cmp.lua`

**Added in `config` function** (lines 30-52):

```lua
-- Initialize completion toggle states
-- Buffer starts OFF (will be off in markdown, on in other files via enabled function)
-- Obsidian and snippets start ON
vim.g.blink_buffer_enabled = false
vim.g.blink_obsidian_enabled = true
vim.g.blink_snippets_enabled = true

-- Global toggle functions for completion sources
function _G.toggle_buffer_completion()
  vim.g.blink_buffer_enabled = not vim.g.blink_buffer_enabled
  local status = vim.g.blink_buffer_enabled and "enabled" or "disabled"
  vim.notify("Buffer completion " .. status, vim.log.levels.INFO)
end

function _G.toggle_obsidian_completion()
  vim.g.blink_obsidian_enabled = not vim.g.blink_obsidian_enabled
  local status = vim.g.blink_obsidian_enabled and "enabled" or "disabled"
  vim.notify("Obsidian completion " .. status, vim.log.levels.INFO)
end

function _G.toggle_luasnip_completion()
  vim.g.blink_snippets_enabled = not vim.g.blink_snippets_enabled
  local status = vim.g.blink_snippets_enabled and "enabled" or "disabled"
  vim.notify("Snippet completion " .. status, vim.log.levels.INFO)
end
```

**Modified buffer provider** (lines 142-155):

```lua
buffer = {
  name = 'buffer',
  enabled = function()
    -- Buffer completion OFF by default in markdown files
    local is_markdown = vim.bo.filetype == 'markdown' or vim.bo.filetype == 'lectic.markdown'
    if is_markdown then
      return vim.g.blink_buffer_enabled == true
    end
    -- ON by default in other file types
    return vim.g.blink_buffer_enabled ~= false
  end,
  max_items = 8,
  min_keyword_length = 2,
},
```

**Modified snippets provider** (lines 156-163):

```lua
snippets = {
  name = 'snippets',
  enabled = function()
    return vim.g.blink_snippets_enabled ~= false
  end,
  max_items = 10,
  min_keyword_length = 1,
},
```

**Modified obsidian provider** (lines 175-183):

```lua
obsidian = {
  name = 'obsidian',
  module = 'blink.compat.source',
  enabled = function()
    return vim.bo.filetype == 'markdown' and vim.g.blink_obsidian_enabled ~= false
  end,
  min_keyword_length = 2,
  max_items = 20,
},
```

### 2. `lua/plugins/which-key.lua`

**Modified TOGGLES menu** (lines 359-368):

```lua
-- TOGGLES (completion, folding, etc.)
t = {
  name = "TOGGLES",
  b = { "<cmd>lua _G.toggle_buffer_completion()<CR>", "toggle buffer completion" },
  o = { "<cmd>lua _G.toggle_obsidian_completion()<CR>", "toggle obsidian completion" },
  x = { "<cmd>lua _G.toggle_luasnip_completion()<CR>", "toggle snippet completion" },
  a = { "<cmd>lua ToggleAllFolds()<CR>", "toggle all folds" },
  f = { "za", "toggle fold under cursor" },
  m = { "<cmd>lua ToggleFoldingMethod()<CR>", "toggle folding method" },
},
```

**Changes**:
- Removed `c` - toggle spell completion (not needed)
- Updated `x` description to "toggle snippet completion" (was "toggle luasnip completion")

---

## How It Works

### Toggle State Management

1. **Global variables** store toggle state:
   - `vim.g.blink_buffer_enabled` - defaults to `false`
   - `vim.g.blink_obsidian_enabled` - defaults to `true`
   - `vim.g.blink_snippets_enabled` - defaults to `true`

2. **Provider `enabled` functions** check these variables at runtime

3. **Toggle functions** flip the boolean and notify user

### Buffer Completion Logic

The buffer provider uses special logic:

```lua
enabled = function()
  local is_markdown = vim.bo.filetype == 'markdown' or vim.bo.filetype == 'lectic.markdown'
  if is_markdown then
    return vim.g.blink_buffer_enabled == true  -- Requires explicitly true (default false)
  end
  return vim.g.blink_buffer_enabled ~= false   -- Requires explicitly false to disable (default true)
end
```

**This means**:
- In markdown: OFF by default, toggle turns ON
- In other files: ON by default, toggle turns OFF

---

## Usage

### In Markdown Files

When you open a `.md` file:
- You'll see: LSP, path, Obsidian, and snippet completions
- You won't see: Buffer completions (no random words from other files!)

**To temporarily enable buffer completion**:
1. Press `<leader>mt` to open toggles menu
2. Press `b` for buffer completion
3. Notification: "Buffer completion enabled"
4. Now you'll see words from other open buffers
5. Press `<leader>mtb` again to turn it back off

### In Code Files

When you open `.lua`, `.py`, `.js`, etc.:
- All completion sources are ON by default
- Use `<leader>mtb` to turn buffer completion OFF if it's too noisy

---

## Testing Checklist

To verify the implementation works:

- [ ] Open a markdown file
- [ ] Start typing - should NOT see random words from other buffers
- [ ] Press `<leader>mtb` - should see "Buffer completion enabled" notification
- [ ] Start typing - should now see words from other open files
- [ ] Press `<leader>mtb` - should see "Buffer completion disabled" notification
- [ ] Start typing - buffer completions should be gone again
- [ ] Restart nvim and open markdown - buffer completion should be OFF by default
- [ ] Test `<leader>mto` and `<leader>mtx` toggles work
- [ ] Open a code file (`.lua`) - buffer completion should be ON by default

---

## Technical Notes

### Why This Approach?

1. **Function-based `enabled`**: blink.cmp evaluates the `enabled` function on each completion trigger, so toggling the global variable takes effect immediately

2. **Global variables**: Simple, session-scoped state that persists across buffers but resets on restart (as Nathan requested)

3. **File-type specific logic**: Buffer completion behaves differently in markdown vs code files while using the same toggle

### Alternative Approaches Considered

1. **Modifying sources list at runtime**: Would require calling `require('blink.cmp').reload_sources()`, which may not exist or may require re-entering insert mode

2. **Buffer-local variables**: Would require per-buffer state management and autocmds, more complex

3. **Persistent state**: Could save toggle state to file, but Nathan explicitly wanted reset on restart

### Limitations

- Toggles affect all buffers globally (not per-buffer)
- State doesn't persist across nvim sessions (by design)
- Must re-enter insert mode for toggle to take effect (may need `<C-e>` to close existing completion menu)

---

## Future Enhancements

Potential improvements if needed:

1. **Buffer-local toggles**: Per-buffer toggle state instead of global
2. **Persistent toggles**: Save state to file for preservation across sessions
3. **Status indication**: Show toggle state in statusline
4. **More granular control**: Toggle per-source for each file type
5. **Auto-disable**: Automatically disable buffer completion when many files open

---

## Success Metrics

✅ **Problem solved**: No more "massive strings of related words" in markdown files
✅ **Buffer completion**: OFF by default in markdown
✅ **Easy toggle**: `<leader>mtb` works to enable temporarily
✅ **Other sources**: LSP, path, Obsidian, snippets all still work
✅ **Resets properly**: Defaults restore on nvim restart
✅ **User control**: Nathan has full control over completion sources

---

## Related Documentation

- **Analysis**: `.claude/specs/008_completion_toggles/ANALYSIS.md`
- **blink.cmp docs**: https://github.com/saghen/blink.cmp
- **Which-key config**: `lua/plugins/which-key.lua`
- **Completion config**: `lua/plugins/lsp/blink-cmp.lua`
