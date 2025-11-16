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

---

## Task Batch 2: Window Management & Directory-Specific Grep

**Date**: 2025-11-15

### Discussion

User needed to learn window/buffer navigation for zettelkasten workflow:
- Goal: 3-window layout (writing left | literature upper-right | zettelkasten lower-right)
- Existing `<leader>w` menu insufficient (only had create split, close, maximize)
- Needed directional split commands
- Realized `<leader>ff` searches entire project, not vault-specific
- Needed directory-specific grep for `~/SecondBrain/4-Zettelkasten/` and `~/SecondBrain/Literature/`

Key decisions:
- Implement directional window splits (left, right, above, below)
- Remove maximize command (destructive, not useful)
- Add directory-specific grep commands directly in which-key (no separate functions needed)
- Fix which-key sort order to preserve custom menu ordering

### Implementation

**1. Window Management Keybindings** (`lua/plugins/which-key.lua` lines 103-110):

Created directional split commands:
- `<leader>wl` - new win right (`:rightbelow vsplit`)
- `<leader>wh` - new win left (`:leftabove vsplit`)
- `<leader>wj` - new win below (`:rightbelow split`)
- `<leader>wk` - new win above (`:leftabove split`)
- `<leader>wx` - close window (`:close`)
- `<leader>ws` - buffer split (`:vert sb`)

Removed:
- Old `<leader>wc` (create split)
- Old `<leader>wk` (maximize/`:only`)

**2. Directory-Specific Grep** (`lua/plugins/which-key.lua` lines 139-140):

Added inline Telescope calls:
- `<leader>fz` - grep zettelkasten (`~/SecondBrain/4-Zettelkasten/`)
- `<leader>fl` - grep lit notes (`~/SecondBrain/Literature/`)
- `<leader>fp` - previous search (renamed from "last search")
- `<leader>fw` - renamed to "word project"

Implementation:
```lua
require('telescope.builtin').live_grep({search_dirs={'~/SecondBrain/4-Zettelkasten'}})
```

**3. Which-Key Sort Order Fix** (`lua/plugins/which-key.lua` line 61):

Changed from:
```lua
sort = { "local", "order", "group", "alphanum", "mod" }
```

To:
```lua
sort = { "local", "order", "group", "manual", "mod" }
```

This preserves custom menu ordering instead of alphabetically sorting.

**4. Which-Key Space Patch Improvements** (`lua/plugins/which-key.lua` lines 71-99):

Changed patch trigger from `VimEnter` autocmd to `vim.schedule()`:
- Runs immediately when which-key config loads
- Applies every time which-key loads, not just on startup
- Added commented-out cache deletion code (pending testing)

### Files Modified

- `lua/plugins/which-key.lua` (lines 61, 71-99, 103-110, 132-144)
- `.claude/specs/000_maintenance_debug/MAINTENANCE_LOG.md` - Added maintenance entry
- `.claude/specs/003_zettelkasten_refinement/PLAN.md` - Checked off completed tasks
- `CHEATSHEET.md` (lines 332-350, 291-313) - Added Window Management and Telescope sections
- `README.md` (lines 52-62) - Updated which-key bug documentation
- `.claude/PROJECT_CONTEXT.md` (lines 141-144) - Updated known bugs section

### Testing

- ✅ Window splits create in correct directions
- ✅ Directory-specific grep returns correct results
- ✅ Menu ordering preserved (not alphabetical)
- ✅ Space patch applies on nvim startup

### Troubleshooting

**Issue 1**: Which-key changes not appearing after restart

**Root cause**:
- Neovim compiles `.lua` files to `.luac` bytecode
- Cache stored in `~/.cache/nvim/luac/`
- Cached bytecode persists across restarts
- Changes to source files don't invalidate cache

**Solution**:
- Deleted cache file: `~/.cache/nvim/luac/.../which-key.luac`
- Restarted nvim
- Changes appeared correctly

**Issue 2**: Space patch not working after config changes

**Root cause**:
- Patch was using `VimEnter` autocmd with `once = true`
- Wouldn't re-run after which-key reload
- Compiled cache prevented patched code from running

**Solution**:
- Changed to `vim.schedule()` trigger
- Patch now applies every time which-key loads
- Added manual cache deletion workaround for after `:Lazy update`

### Known Issues

**Cache Issue After Plugin Updates**:
- After `:Lazy update` on which-key, patch may not take effect
- Cached `.luac` file may prevent patched code from running
- Manual workaround: Delete `~/.cache/nvim/luac/.../state.luac` and restart
- Auto-deletion code commented out at lines 88-91, pending testing

### Decisions

- Implemented grep directly in which-key.lua instead of separate functions
- Simpler approach - inline calls work fine, can refactor later if needed
- Commented out cache auto-deletion until tested after next which-key update
- Directory is `4-Zettelkasten` not `3-Zettelkasten` (plan corrected)

### Git Commit

[pending]

---

## Task Batch 3: Search Menu Reorganization & Sessions

**Date**: 2025-11-16

### Discussion

User discovered workflow issues with directory-specific sessions:
- Wanted to save different sessions per chapter (Ch-1, Ch-2, etc.)
- Sessions are saved per cwd, so can `cd` to different directories
- Problem: `<leader>ff` and `<leader>fg` only searched cwd, not entire SecondBrain
- With cwd in `~/SecondBrain/Book/Ch-1/`, couldn't search zettelkasten (parent directory)
- Needed: Absolute-path searches for brain-wide access, cwd-relative for dev work

Also discovered zen mode provides window zoom/focus functionality.

Key decisions:
- Make `<leader>ff` and `<leader>fb` search entire SecondBrain (absolute paths)
- Move cwd-relative searches to new `<leader>fd` submenu "DEV SEARCH"
- Add nvim config searches to dev submenu
- Improved window separator visibility (was too subtle)

### Implementation

**1. FIND Menu Reorganization** (`lua/plugins/which-key.lua` lines 139-159):

Main FIND menu (absolute paths for Second Brain):
- `<leader>fr` - recent files
- `<leader>ff` - brain files (searches all of `~/SecondBrain`)
- `<leader>fb` - grep brain (greps all of `~/SecondBrain`)
- `<leader>fz` - grep zettelkasten
- `<leader>fl` - grep lit notes
- `<leader>fc` - current buffer
- `<leader>fo` - open buffers (renamed from `<leader>fb`)
- `<leader>fw` - word project
- `<leader>fp` - previous search
- `<leader>fy` - yanks
- `<leader>fk` - keymaps
- `<leader>fh` - help

New DEV SEARCH submenu (`<leader>fd`) for cwd-relative:
- `<leader>fdf` - find files in cwd
- `<leader>fdg` - grep cwd
- `<leader>fdc` - grep nvim config
- `<leader>fds` - search nvim config files

**2. Window Separator Visibility** (`lua/core/options.lua` line 22):

Changed from:
```lua
fillchars = "eob: "
```

To:
```lua
fillchars = "eob: ,vert:█,horiz:▀"
```

- Vertical: full block (`█`)
- Horizontal: upper half block (`▀`)

### Files Modified

- `lua/plugins/which-key.lua` (lines 139-159) - FIND menu reorganization
- `lua/core/options.lua` (line 22) - Window separators
- `CHEATSHEET.md` (lines 291-316, 360-366) - Updated search section, added session management
- `.claude/specs/000_maintenance_debug/MAINTENANCE_LOG.md` - Added maintenance entry

### Testing

- ✅ `<leader>ff` searches entire SecondBrain from any directory
- ✅ `<leader>fb` greps entire SecondBrain from any directory
- ✅ `<leader>fz` and `<leader>fl` still work (absolute paths)
- ✅ `<leader>fd` submenu provides cwd-relative searches
- ✅ Window separators more visible

### Workflow Benefits

**Session per directory**:
1. `cd ~/SecondBrain/Book/Ch-1`
2. Set up 3-window layout
3. `<leader>ss` - Save "Ch-1" session
4. `<leader>ff` - Still searches ALL SecondBrain files
5. `<leader>fz` - Still searches ALL zettelkasten
6. `<leader>fdf` - Only searches Ch-1 directory (dev work)

**Zen mode discovery**:
- `<leader>mz` - Toggle zen mode (focus/unfocus window)
- Provides window zoom functionality without needing separate plugin
- Restores layout on toggle

### Decisions

- Brain-centric searches use absolute paths (always access entire vault)
- Dev-centric searches in submenu (cwd-relative when needed)
- Sessions remain directory-based (simple, works well for chapters)
- Window separators: full block vertical, half block horizontal (good visibility balance)

### Git Commit

[pending]

---

## Next Steps

Continue with Phase 1 remaining tasks:
- Create zettelkasten file search function (not just grep)
- Create literature file search function (not just grep)
- Configure Telescope preview for markdown
- Test which-key cache workaround after next plugin update
- Continue to Phase 2: Citation insertion workflows

**Note**: File search (not grep) may be less critical now that `<leader>ff` searches entire brain. Consider if still needed or if just zettelkasten/literature file search would be sufficient.
