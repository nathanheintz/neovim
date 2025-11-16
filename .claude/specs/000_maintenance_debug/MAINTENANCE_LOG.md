# Maintenance & Debug Log

**Project**: 000 - Ongoing Maintenance & Debugging
**Purpose**: Track small fixes, tweaks, and debugging tasks that don't require full project planning
**Created**: 2025-11-14

---

## How to Use This Log

This log is for **small maintenance tasks** like:
- Bug fixes
- Minor tweaks and adjustments
- Cleanup tasks
- Quick configuration changes
- Debugging sessions

Each entry should include:
- **Date**: When the work was done
- **Task**: Brief description
- **Changes**: What files were modified
- **Commit**: Git commit hash (if applicable)

---

## Log Entries

### 2025-11-14 - Project Created

**Task**: Created 000_maintenance_debug project for ongoing small tasks

**Changes**:
- Created `/Users/nathanheintz/.config/nvim/.claude/specs/000_maintenance_debug/`
- Created `MAINTENANCE_LOG.md` to track small fixes

**Notes**: This project doesn't require PLAN.md or SESSION_LOG.md - just this maintenance log for quick reference.

---

### 2025-11-15 - Added Speech-to-Text (vocal.nvim)

**Task**: Installed vocal.nvim plugin for dictation/speech-to-text in markdown files

**Changes**:
- Created `lua/plugins/vocal.lua` - Plugin config with local Whisper model
- Updated `lua/plugins/which-key.lua` (line 162) - Added `<leader>md` keybinding
- Updated `CHEATSHEET.md` (line 276) - Documented dictation keybinding
- Created `/opt/homebrew/bin/python` symlink to `python3` (vocal.nvim hardcodes `python`)
- Installed dependencies:
  - `sox` via Homebrew (audio recording)
  - `openai-whisper` via pip (user-level: `~/Library/Python/3.13/lib/python/site-packages/`)

**Configuration**:
- Local Whisper model: `base` (stored in `~/.cache/whisper`)
- Recordings: `~/recordings/` (auto-deleted after transcription)
- Markdown files only (lazy-loaded via `ft = { "markdown" }`)
- Fully offline, no API calls

**Usage**: Press `<leader>md` to start recording, press again to stop and transcribe

**Commit**: bbb08a2

---

### 2025-11-15 - Window Management & Zettelkasten Search Keybindings

**Task**: Added directional window splits and directory-specific grep for zettelkasten workflow

**Changes**:
- `lua/plugins/which-key.lua` (lines 103-110) - New window keybindings:
  - `<leader>wl` - new win right (vertical split)
  - `<leader>wh` - new win left (vertical split)
  - `<leader>wj` - new win below (horizontal split)
  - `<leader>wk` - new win above (horizontal split)
  - `<leader>wx` - close window
  - `<leader>ws` - buffer split (same buffer in new window)
  - Removed: `<leader>wc` (old create split), `<leader>wk` (old maximize)

- `lua/plugins/which-key.lua` (lines 132-144) - Directory-specific grep:
  - `<leader>fz` - grep zettelkasten (`~/SecondBrain/4-Zettelkasten/`)
  - `<leader>fl` - grep lit notes (`~/SecondBrain/Literature/`)
  - `<leader>fp` - previous search (renamed from "last search")
  - `<leader>fw` - renamed to "word project" for clarity

- `lua/plugins/which-key.lua` (line 61) - Fixed sort order:
  - Changed from `"alphanum"` to `"manual"` to preserve custom menu ordering

- `lua/plugins/which-key.lua` (lines 71-99) - Improved which-key Space patch:
  - Changed from VimEnter autocmd to `vim.schedule()` for immediate application
  - Patch now runs every time which-key config loads
  - Added commented-out cache deletion (for future testing after plugin updates)

**Known Issue** (incomplete):
- After which-key plugin updates, the Space patch may not take effect until cache file is manually deleted
- Cache file location: `~/.cache/nvim/luac/%2fUsers%2fnathanheintz%2f.local%2fshare%2fnvim%2flazy%2fwhich-key.nvim%2flua%2fwhich-key%2fstate.luac`
- Workaround: Delete cache file after `:Lazy update` if Space starts causing issues
- Auto-deletion code commented out at lines 88-91, pending testing

**Commit**: [pending]

---

### 2025-11-16 - Search Menu Reorganization & Window Separators

**Task**: Reorganized FIND menu for brain-centric workflow and added window separator visibility

**Changes**:
- `lua/plugins/which-key.lua` (lines 139-159) - Reorganized FIND menu:
  - Changed `<leader>ff` from "project files" to "brain files" (searches all of ~/SecondBrain)
  - Changed `<leader>fb` from "all buffers" to "grep brain" (greps all of ~/SecondBrain)
  - Changed `<leader>fb` (old all buffers) to `<leader>fo` "open buffers"
  - Reordered: recent, brain files, grep brain, zettelkasten, literature, buffers...
  - Created new `<leader>fd` submenu "DEV SEARCH" for cwd-relative searches:
    - `<leader>fdf` - find files in cwd
    - `<leader>fdg` - grep cwd
    - `<leader>fdc` - grep nvim config
    - `<leader>fds` - search nvim config files

- `lua/core/options.lua` (line 22) - Window separator visibility:
  - Changed `fillchars = "eob: "` to `fillchars = "eob: ,vert:█,horiz:▀"`
  - Vertical separator: full block (`█`)
  - Horizontal separator: upper half block (`▀`)
  - Makes window splits more visible without being distracting

**Rationale**:
- User's primary workflow is Second Brain, not general dev work
- With sessions per directory, needed absolute-path searches to access entire vault
- CWD-relative searches relegated to `<leader>fd` submenu for development work
- Window separators were too subtle (hairline), making split boundaries hard to see

**Usage Notes**:
- `<leader>ff` and `<leader>fb` now work from any directory (absolute paths)
- Can `cd` into chapter subdirectories and still search entire Second Brain
- Sessions save per directory, allowing different layouts for different chapters
- Zen mode (`<leader>mz`) provides focus/unfocus toggle

**Commit**: [pending]

---

