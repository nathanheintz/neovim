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

**Commit**: [pending]

---

