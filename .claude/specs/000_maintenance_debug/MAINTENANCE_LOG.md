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

### 2026-04-08 - SESSION_PROTOCOL.md documentation system overhaul

**Task**: Clarified project vs. maintenance distinction, simplified documentation structure, added planning guidance

**Changes**:
- `SESSION_PROTOCOL.md` — Added Task Complexity Assessment rule (project vs. maintenance decision upfront)
- `SESSION_PROTOCOL.md` — Replaced SESSION_LOG format with lightweight Notes blocks inline in PLAN.md (decisions, pivots, gotchas, commit hashes)
- `SESSION_PROTOCOL.md` — Removed SESSION_LOG.md and SUMMARY.md as standard project artifacts
- `SESSION_PROTOCOL.md` — Added "Creating a Project Plan" section with succinct guidance
- `SESSION_PROTOCOL.md` — Clarified GLOBAL_SUMMARY_LOG as canonical completed-project record; MAINTENANCE_LOG for small tasks only
- `SESSION_PROTOCOL.md` — Updated directory structure, session init, phase break steps, and Quick Reference

---

### 2026-04-08 - Removed stale `<leader>rr` reference from PROJECT_CONTEXT.md

**Task**: Fixed incorrect keybinding reference in documentation

**Changes**:
- `~/.config/nvim/.claude/PROJECT_CONTEXT.md` — "Adding a New Keybinding" step 4 previously said "Reload config with `<leader>rr`". That binding doesn't exist. Replaced with "Restart nvim to pick up changes."

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
  - `<leader>fz` - grep zettelkasten (`~/SecondBrain/3-Zettelkasten/`)
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

### 2026-03-13 - which-key Kitty Patch: File-write → In-memory Monkey-patch

**Task**: Replaced file-writing which-key Space patch with in-memory monkey-patch to stop `:Lazy update` conflicts

**Problem**: The old patch wrote directly to `~/.local/share/nvim/lazy/which-key.nvim/lua/which-key/state.lua` on every nvim startup. This caused a tracked-file conflict that blocked every `:Lazy update`.

**Old approach** (file-writing — blocked updates):
```lua
local function apply_patch()
  local state_file = vim.fn.stdpath("data") .. "/lazy/which-key.nvim/lua/which-key/state.lua"
  local lines = vim.fn.readfile(state_file)
  local content = table.concat(lines, "\n")
  local patched = content:gsub(
    'elseif key == "<Esc>" then',
    'elseif key == "<Esc>" or key == "<Space>" then'
  )
  if content ~= patched then
    vim.fn.writefile(vim.split(patched, "\n"), state_file)
    vim.notify("which-key patched: Space closes menus", vim.log.levels.INFO)
  else
    vim.notify("which-key: patch already applied", vim.log.levels.DEBUG)
  end
end
vim.schedule(apply_patch)
```

**New approach** (in-memory monkey-patch — no file changes):
```lua
local state = require("which-key.state")
local original_check = state.check
state.check = function(s, key)
  if key == "<Space>" then key = "<Esc>" end
  return original_check(s, key)
end
```

**Why it's safe**: `state.check` is only called when a which-key menu is already open. The initial `<Space>` keypress that opens the menu goes through a different code path and is unaffected.

**Files Modified**:
- `lua/plugins/which-key.lua` (lines ~73-82) - Replaced patch block

---

### 2026-03-13 - Lectic Binary/Plugin Sync Fix

**Task**: Fixed lectic broken after long period without updates

**Problem chain**:
1. lectic binary was alpha6 (2025-04-04), defaulting to `claude-3-7-sonnet-latest` → 404 error
2. `version = false` in lectic.lua was pulling main branch (beta dev code) instead of releases
3. Main branch plugin used `lectic --format block` flag which the 0.0.2 binary doesn't support
4. Build step ran `npm install` on every update, modifying `package-lock.json` → blocked every `:Lazy update`

**Fixes applied**:
- Updated lectic binary to 0.0.2 via: `curl -fsSL https://raw.githubusercontent.com/gleachkr/lectic/main/install.sh | sh`
- Changed `version = false` → `version = "*"` in `lua/plugins/lectic.lua` (pins to releases, not main)
- Replaced `build` npm install step with a `vim.notify` reminder to update binary via terminal
- Changed `vim.g.lectic_model` from `"claude-4-sonnet"` to `"claude-sonnet-4-6"` (note: this var is unused by the plugin — model comes from frontmatter or binary default)

**To update lectic in future**:
1. Run `:Lazy update` in nvim (updates plugin)
2. Run in terminal: `curl -fsSL https://raw.githubusercontent.com/gleachkr/lectic/main/install.sh | sh` (updates binary)

**Files Modified**:
- `lua/plugins/lectic.lua` - version, build step, lectic_model

---

### 2026-03-20 - Fix Tab Key in Markdown: Completion, Bullet Indent, Plain Text

**Task**: Tab in markdown was unconditionally running Autolist's bullet-indent behavior, breaking path completion and inserting stray spaces in plain prose.

**Problem**: `set_markdown_keymaps()` used `buf_map` to set Tab → `<Esc>><cmd>AutolistRecalculate<cr>a<space>` on every markdown buffer. This buffer-local mapping overrode blink.cmp's Tab entirely. Additionally, the mapping had two bugs: `a<space>` inserted a literal space character into the document, and `>` triggered the remapped visual-select-indent sequence instead of a clean `>>`.

**Fix**: Replaced the string mapping with a `vim.keymap.set` Lua function that checks context in order:
1. Completion menu visible → `blink.select_and_accept()`
2. Current line matches a list pattern (`^%s*%d+%.%s` or `^%s*[-*+]%s`) → `normal! >>` + `AutolistRecalculate`
3. Otherwise → `<C-t>` (normal tab/spaces per tabstop)

**Files Modified**:
- `lua/core/keymaps.lua` (line 150) - Commented out old `buf_map` Tab mapping, added new `vim.keymap.set` function

**Commit**: [pending]

---

### 2026-03-26 - Zettelkasten Path Corrected (4 → 3)

**Task**: All references to `4-Zettelkasten` were incorrect — folder was renumbered to `3-Zettelkasten`

**Changes**:
- `lua/plugins/which-key.lua` — `<leader>fz` search path corrected
- `lua/plugins/snacks/dashboard.lua` — `z` key cwd corrected
- `CHEATSHEET.md`, `.claude/specs/003_zettelkasten_refinement/PLAN.md`, `SESSION_LOG.md`, `MAINTENANCE_LOG.md` — docs updated

**Commit**: 30cf201

---

### 2026-03-26 - Dashboard & Keymap Cleanup

**Task**: Fixed dashboard Config path, removed dead which-key bindings, fixed broken commands

**Changes**:
- `lua/plugins/snacks/dashboard.lua` — Config key fixed from `~/.config` to `~/.config/nvim`
- `lua/plugins/which-key.lua` — Removed dead ACTIONS bindings (`<leader>aa` pdf annotations, `<leader>ah` local highlight — plugins not installed). Fixed broken `NeoTreeToggle` → `Neotree` for edit snippets and update-cwd commands.

**Commit**: 30cf201

---

### 2026-03-26 - PDFs Open in Skim Instead of Neovim

**Task**: Clicking a PDF in neo-tree was loading binary content as text in Neovim

**Fix**: Added `BufReadCmd` autocmd for `*.pdf` — intercepts the open before content loads, fires Skim via `open -a Skim`, then deletes the buffer

**Files Modified**:
- `lua/core/autocmds.lua` — Added PDF intercept autocmd

**Commit**: 30cf201

---

### 2026-03-26 - Tab/S-Tab Markdown Keymap Overhaul

**Task**: Rewrote Tab and S-Tab keymaps in markdown to fix multiple compounding bugs

**Problems**:
1. Tab was calling `feedkeys('a', 'n', false)` after `normal! >>`, inserting a literal `a` character mid-bullet
2. Cursor landed behind the new bullet point after indent (wrong position)
3. Tab had no LuaSnip awareness — couldn't jump forward through snippet tab stops
4. S-Tab was a string `buf_map` (`<Esc><<cmd>AutolistRecalculate<cr>a`) — same cursor bug, no LuaSnip backward jump

**Fix**: Replaced both with `vim.keymap.set` Lua functions with proper priority chains:
- Tab: LuaSnip `jump(1)` → blink `select_and_accept` → `AutolistTab` → `<C-t>`
- S-Tab: LuaSnip `jump(-1)` → `AutolistShiftTab` → `<C-d>`
- Discovered AutoList has native `AutolistTab`/`AutolistShiftTab` commands that handle indent + cursor + recalculation correctly in one call

**Files Modified**:
- `lua/core/keymaps.lua` — Replaced both Tab and S-Tab mappings in `set_markdown_keymaps()`

**Commit**: cb7260e

---

### 2026-03-26 - LuaSnip: Snippets Staying Active After Completion

**Task**: After filling a snippet, Tab was jumping back into the previous snippet

**Problem**: LuaSnip had no `region_check_events` configured, so active snippets were never deactivated when the cursor moved away

**Fix**: Added `region_check_events = "CursorMoved"` to LuaSnip setup

**Files Modified**:
- `lua/plugins/luasnip.lua` — Added `config.setup({ region_check_events = "CursorMoved" })`

**Commit**: cb7260e

---

### 2026-03-26 - Snippet Completion Triggering Mid-Sentence

**Task**: Typing normal prose words (e.g. "one" at end of "List item one") was popping up the "triangle" snippet in the completion menu

**Problem**: blink.cmp's fuzzy matching was finding "triangle" as a subsequence match for "one" (tria**n**gl**e** contains n and e). `min_keyword_length = 3` wasn't enough protection — any 3-char word could fuzzy-match any snippet.

**Fix**: Added `transform_items` to the snippets provider in blink.cmp that:
1. Checks the line before cursor — strips leading whitespace and list prefix (`- `, `* `, `1. ` etc.)
2. Only shows snippets if the remaining content is a single word (no spaces = start of line)
3. Applies prefix match instead of fuzzy: snippet label must START with what's typed

**Files Modified**:
- `lua/plugins/lsp/blink-cmp.lua` — Added `transform_items` to snippets provider

**Commit**: cb7260e

---

### 2026-03-27 - Snippet Menu: Require 3 Chars Before Showing

**Task**: Triangle snippet appearing in autocomplete menu after typing a single "t"

**Problem**: `min_keyword_length = 3` was set on the snippets provider but was not being enforced by blink.cmp — snippet showed on "t".

**Resolution**: After a full Neovim restart (triggered by edits this session), blink.cmp began correctly enforcing `min_keyword_length = 3`. No code change was needed — the setting was already correct. Snippet now requires 3+ chars to appear.

**What NOT to do**: Do not add a `#keyword < 3` guard inside `transform_items` — this causes snippets to stop appearing entirely due to a cursor-read timing issue where blink calls `transform_items` before the latest character is committed to the buffer.

**Files Modified**: None (reverted all attempted changes)

**Commit**: [pending]

---

### 2026-03-27 - Removed ReloadConfig / `<leader>rr`

**Task**: Remove the `ReloadConfig` command and its which-key binding — it was misleading and non-functional for the common case

**Problem**: `ReloadConfig` cleared `package.loaded` entries matching `'^plugins'` then re-ran `dofile(MYVIMRC)`. This cannot reload lazy.nvim-managed plugin configs — `setup()` calls have already run and cannot be re-executed mid-session. `:Lazy reload` exists but is explicitly marked experimental in the docs. Full restart is the only reliable approach for plugin config changes.

**Changes**:
- `lua/core/functions.lua` — Removed `ReloadConfig` user command entirely
- `lua/plugins/which-key.lua` — Removed `<leader>rr` binding from RUN menu

**Commit**: [pending]

---

### 2026-03-30 - Lectic LSP Multi-Buffer Fix, Paper Search Researcher Persona, Whisper/Python Recovery

**Lectic LSP Auto-Attach (subsequent buffers)**
- *Problem*: `plugin/lsp.lua` in lectic is never sourced for dynamically-added rtp directories. The config-function LSP start only covered the first `.lec` open. Subsequent `.lec` buffers got no LSP, so fold ranges weren't sent and tool-call blocks didn't auto-collapse.
- *Fix*: Added a `FileType` autocmd in the lectic config function mirroring `plugin/lsp.lua`. Added `LspAttach` autocmd using `vim.defer_fn(500ms)` to call `zMzv` after LSP sends fold ranges.
- *Files*: `lua/plugins/lectic.lua`

**Paper Search MCP — Researcher Persona Only**
- *Fix*: Added `tools` field to Researcher entry in `all_personas`. Updated `SwitchLecticPersona()` to write tools block into frontmatter when `persona.tools` is present. Removed OVERRIDE line from Researcher prompt.
- *Files*: `lua/plugins/lectic.lua`

**Python / Whisper Recovery**
- *Problem*: `brew install pipx` (used to attempt paper-search-mcp install) required `python@3.14`, updating the `python3` symlink from 3.13 → 3.14. `openai-whisper` is not compatible with Python 3.14, breaking vocal.nvim dictation.
- *Fix*: Uninstalled pipx (brew auto-removed python@3.14). Rebuilt paper-search-mcp venv on python3.13. Restored `python3` symlink to python3.13. Reverted vocal.lua `python_path` to `/opt/homebrew/bin/python3`.
- *Note*: vocal.nvim hardcodes `command = "python"` in `transcription.lua` — `python_path` config option is ignored by the plugin (upstream bug).
- *Files*: `lua/plugins/vocal.lua`

**Commit**: [pending]

---

### 2026-03-31 - Lectic Binary Update (0.0.2 → 0.0.3)

**Problem**: Lectic broken after plugin update. `submit.lua` calls `lectic --format block` (added in plugin commit 377a86b, March 5 2026) but binary was still 0.0.2 which doesn't support the `--format` flag. Binary exited immediately with "error: unknown option '--format'", causing the spinner to crash (`nvim_buf_del_extmark` called with nil id before first 250ms tick).

**Fix**: Updated binary to 0.0.3 via install script:
```
curl -fsSL https://raw.githubusercontent.com/gleachkr/lectic/main/install.sh | sh
```

**Note**: When lectic plugin is updated via `:Lazy update`, check if binary also needs updating. Binary and plugin must stay in sync.

**Files Modified**: None (binary only, installed to `~/.local/bin/lectic`)

**Commit**: [pending]

---

### 2025-11-19 - Insert Mode Navigation & Markdown Folding

**Task**: Added Ctrl+Up/Down keybindings for actual line navigation, swapped paragraph navigation to Ctrl+Opt, fixed markdown folding to only fold on headers

**Changes**:
- `lua/core/keymaps.lua` (lines 306-307, 313-315) - Navigation keybindings:
  - `<M-Up>` / `<M-Down>` - Changed to actual line navigation (was paragraph)
  - `<C-M-Up>` / `<C-M-Down>` - Changed to paragraph navigation (was unused)
  - Removed `<C-Up>` / `<C-Down>` to free for macOS window switching

- `lua/core/functions.lua` (lines 162-179) - Markdown folding function:
  - Removed setext-style heading checks (underline with `===` or `---`)
  - Now only folds on ATX-style headers (`#`, `##`, `###`)
  - Added default fold setup when no state file exists (lines 296-302)

- `lua/core/autocmds.lua` (lines 74-80) - Added markdown autocmd:
  - Calls `LoadFoldingState()` when markdown files open
  - Ensures regex-based fold function loads on startup

**Rationale**:
- Treesitter folding had unstable cache during editing, reverted to regex
- Regex function only checks for explicit headers, ignores all other patterns (YAML, indentation, etc.)
- LoadFoldingState() wasn't being called, so fold config never applied on startup
- Added autocmd to ensure function runs when markdown files open

**Testing**:
- Verified markdown files fold only on headers (`#`, `##`, `###`)
- Confirmed YAML frontmatter and indented content don't create folds
- Tested navigation keybindings work correctly

**Commit**: [pending]

---

### 2026-04-05 - Lectic Cancel Keybinding

**Task**: Added `<leader>mx` to interrupt a running Lectic request.

**Changes**:
- `lua/plugins/which-key.lua` — Added `<leader>mx` calling `require('lectic.submit').cancel_submit()`
- `cheatsheet-readme/lectic-cheatsheet.md` — Documented new keybinding

**Notes**: `cancel_submit()` already existed in `submit.lua` (line 9) but was never wired to a key. Calls `process:kill()` on the active Lectic subprocess.

**Commit**: [pending]

---

