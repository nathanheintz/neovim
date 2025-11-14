# Which-Key Space Key Bug Report

**Date**: 2025-11-12
**Status**: Workaround implemented (see bottom)

## Bug Description

When using which-key.nvim in Kitty terminal, pressing `<Space>` (leader key) while a which-key menu is open causes the Space keypress to be fed back as the first-tier menu character instead of Space itself.

## Environment

- **Terminal**: Kitty (latest version)
- **Shell**: Fish
- **OS**: macOS (Darwin 24.1.0)
- **Neovim**: Latest
- **which-key.nvim**: v3 (latest)

## Minimal Reproduction

```lua
-- minimal init.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({"git", "clone", "https://github.com/folke/lazy.nvim.git", lazypath})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

require("lazy").setup({
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
      require("which-key").add({
        { "<leader>a", group = "TEST" },
        { "<leader>aa", "<cmd>echo 'aa pressed'<CR>", desc = "action a" },
      })
    end
  }
})
```

## Steps to Reproduce

1. Start nvim with the minimal config above
2. Press `<leader>a` (Space-a) - which-key menu opens showing "TEST" group
3. Press `<Space>` again (expecting menu to close or be ignored)

## Expected Behavior

Menu should close (like pressing `<Esc>`) or Space should be ignored as an unmapped key.

## Actual Behavior

The character `a` is fed back to the buffer. If there's a dashboard or single-character mappings (like Snacks dashboard), the `a` action gets executed.

## Pattern Observed

- `<leader>a<Space>` → executes action mapped to `a`
- `<leader>m<Space>` → executes action mapped to `m`
- `<leader>r<Space>` → executes action mapped to `r`
- `<leader>ms<Space>` → executes action mapped to `m` (parent tier, not `s`)

The Space keypress is consistently replaced with the **first-tier character** from the menu hierarchy, not the most recent key pressed.

## Debug Evidence

Using `vim.on_key()` logging shows:

```
Key: <Space> (typed: <Space>) Buffer: 1 Mode: n
Key: <Space> (typed: <Space>) Buffer: 1 Mode: n
Key: <t_ýg> (typed: a) Buffer: 1 Mode: n  -- Kitty terminal code typed as 'a'
```

The terminal code `<t_ýg>` (Kitty's encoding for Space) gets "typed" as the first-tier character.

## Root Cause Analysis

Located in `which-key/state.lua` line 227:

```lua
local keystr = node and node.keys or (state.node.keys .. (key or ""))
```

When Space is pressed in a submenu:
1. `state.node.keys` contains the parent key sequence (e.g., `<leader>m`)
2. Which-key calls `M.execute()` to feed back `<leader>m<Space>`
3. This goes through `nvim_replace_termcodes()` and `nvim_feedkeys()`
4. Somehow the result is just `m` reaching the buffer

The exact mechanism of how `<leader>m<Space>` becomes just `m` is unclear, but it's consistent and predictable - always the first-tier character.

## Terminal Specificity

- **Confirmed**: Happens in Kitty terminal
- **Not tested**: Other terminals (iTerm2, Alacritty, etc.)
- **Suspected**: Related to Kitty's enhanced keyboard protocol sending special terminal codes

## Workaround Implemented

Modified `which-key/state.lua` line 200 to treat Space as Escape:

```lua
-- Before:
elseif key == "<Esc>" then

-- After:
elseif key == "<Esc>" or key == "<Space>" then
```

This makes Space close the menu cleanly instead of triggering the buggy feedkeys mechanism.

Applied via auto-patch in `lua/plugins/which-key.lua` (lines 71-91) that runs on `VimEnter`.

## Files Modified

- `lua/plugins/which-key.lua` - Auto-patch on startup
- `README.md` - Documentation of the issue and workaround

## Upstream Report

Status: Not yet reported to which-key.nvim maintainer

If reporting, include:
1. This minimal reproduction
2. Debug logs showing terminal code corruption
3. Terminal environment details (Kitty + enhanced keyboard protocol)
