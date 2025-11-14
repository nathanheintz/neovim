# Session Log - Project 003: Zettelkasten Refinement

**Project**: Zettelkasten Search & Citations Enhancement
**Started**: 2025-11-13
**Status**: In Progress

---

## Task Batch 1: Update Which-Key FIND Menu

**Date**: 2025-11-13

### Discussion

User wanted to refine the `<leader>f` FIND menu by:
- Removing unused commands (all files from home, colorscheme picker, grep string)
- Adding current buffer grep functionality
- Changing buffer search from file-name-only to content grep
- Reordering menu items for better workflow

Key decisions:
- Keep yank history in FIND menu (not move to ACTIONS)
- Use `<leader>fc` for current buffer grep
- Use `<leader>fb` for all buffers grep (changed from buffer switcher)
- New order: ff, fr, fc, fb, fw, fg, fl, fy, fk, fh

### Implementation

**Created two new search functions** in `lua/core/functions.lua` (lines 23-51):

1. `SearchCurrentBuffer()`:
   - Uses `telescope.builtin.current_buffer_fuzzy_find()`
   - Searches only the current file
   - Fast fuzzy search within buffer

2. `SearchAllBuffers()`:
   - Filters for loaded, listed buffers using `vim.tbl_filter`
   - Extracts file paths from each buffer
   - Uses `telescope.builtin.live_grep()` with `search_dirs` parameter
   - Shows warning if no buffers available to search
   - Custom prompt title: "Grep All Open Buffers"

**Updated which-key menu** in `lua/plugins/which-key.lua` (lines 128-139):

Removed:
- `<leader>fa` - All files from home directory
- `<leader>ft` - Colorscheme picker
- `<leader>fs` - Grep string (redundant with live_grep)

Changed:
- `<leader>fb` - Now calls `SearchAllBuffers()` instead of buffer file switcher

Added:
- `<leader>fc` - Calls `SearchCurrentBuffer()`

Reordered to:
```
ff - project files
fr - recent
fc - current buffer
fb - all buffers
fw - word
fg - project grep
fl - last search
fy - yanks
fk - keymaps
fh - help
```

### Files Modified

- `lua/core/functions.lua` (lines 23-51) - Added SearchCurrentBuffer() and SearchAllBuffers() functions
- `lua/plugins/which-key.lua` (lines 128-139) - Updated FIND menu structure
- `lua/plugins/which-key-old.lua` - Renamed to `.bak` to prevent loading conflict

### Testing

User tested both new commands:
- `<leader>fc` - Current buffer grep works correctly
- `<leader>fb` - All buffers grep works correctly
- Menu displays in correct order
- Old commands (fa, ft, fs) removed successfully

### Troubleshooting

**Issue**: After initial changes, which-key menu still showed old commands.

**Root cause**: Two files were being loaded by lazy.nvim:
1. `lua/plugins/which-key.lua` (new, updated version)
2. `lua/plugins/which-key-old.lua` (old version still returning plugin spec)

The old file was overriding the new configuration.

**Solution**:
1. Renamed `which-key-old.lua` to `which-key-old.lua.bak` so lazy.nvim wouldn't load it
2. Cleared which-key plugin cache: `rm -rf ~/.local/share/nvim/lazy/which-key.nvim`
3. Ran `nvim --headless "+Lazy! sync" +qa` to reinstall which-key cleanly

**Additional notes**: The issue was directory-specific - the menu worked correctly in `~/SecondBrain` but not in `~/.config/nvim`. After plugin sync, both locations showed correct menu.

### Decisions

- Kept grep_string removal even though it's slightly different from live_grep (user confirmed redundant)
- Used fuzzy find for current buffer (faster) vs live_grep (more powerful but slower)
- Decided against adding buffer file switcher elsewhere since user navigates buffers with Tab/Shift+Tab

### Git Commit

b9ac389

---

## Next Steps

Continue with Phase 1 remaining tasks:
- Create zettelkasten file search function
- Create zettelkasten content search function
- Create literature file search function
- Create literature content search function
- Configure Telescope preview for markdown
- Add which-key submenu structure for vault searches
