# Global Summary Log

**Purpose**: High-level view of all completed and in-progress projects
**Last Updated**: 2025-11-13

---

## 001: Neovim Second Brain - Initial Setup
**Status**: Completed (2025-11-12)
**Problem**: Forked from Ben's NeoTex config which was heavily LaTeX/academic focused. Needed to adapt for writing/publishing workflow with Lectic AI, Obsidian integration, and Ghost theme development.
**Solution**: Multi-session project cleaning up which-key menus, removing Ben-specific features (Avante, Kanban, NixOS tools), reorganizing keybindings for writing workflow. Fixed which-key Kitty terminal bug, added CWD-based colorscheme switching, disabled auto-format-on-save, cleaned up documentation structure.
**Key Files**:
- lua/plugins/which-key.lua - Reorganized all menus (removed 6 menus, created 4 new ones)
- lua/core/options.lua - Added colorscheme auto-switching autocmd
- lua/plugins/conform.lua - Disabled format_on_save
- CHEATSHEET.md - Moved from cheatsheet-readme/, updated with current state
- cheatsheet-readme/ - Removed 4 outdated files (ben-README, nh-README, config-cheatsheet, claude-config-guidelines)
**Impact**: Config now reflects actual usage (Lectic not Avante, Deckset included, writing-focused not LaTeX-academic). Which-key works reliably in Kitty. Colorschemes auto-switch by project directory.
**Git Commits**: 1d36eeb, 065c7c6, d988084 (multiple sessions)

---

## 002: Lectic Single-Party Persona System
**Status**: Completed (2025-11-11)
**Problem**: Multi-party Lectic conversations broken in beta6 - `:ask[PersonaName]` directive produces undefined errors. Needed working AI assistant for writing.
**Solution**: Converted to single-party mode with manual persona switching via `<leader>mp` submenu. Added context link insertion with `<leader>mc`. All 12 personas accessible (Consultant, Marketing, Finance, Product, Researcher, Writer, Editor, Designer, Scholar, Scribe, Homie, Nomad). Frontmatter preserved during switching.
**Key Files**:
- lua/plugins/lectic.lua - Added SwitchLecticPersona() (line 280), InsertContextLink() (line 219), all_personas table (line 228)
- lua/plugins/which-key.lua - Added persona switching submenu `<leader>mp` (lines 330-345)
- cheatsheet-readme/lectic-cheatsheet.md - Updated for single-party workflow
**Impact**: Can now use Lectic reliably for writing assistance. Workflow: create file with Homie (`<leader>mn`), switch personas as needed (`<leader>mp`), add context via markdown links (`<leader>mc`), run Lectic (`<leader>ml`).
**Git Commits**: 065c7c6

---

## 008: Completion Toggles
**Status**: Completed (2025-11-11)
**Problem**: Buffer completion was pulling "massive strings of related words" from all open Second Brain buffers during markdown writing, creating noise in completion menu.
**Solution**: Changed buffer completion default to OFF in markdown files, ON in code files. Created three toggle functions: `<leader>mtb` (buffer), `<leader>mto` (obsidian), `<leader>mtx` (snippets). Toggles persist within session, reset to defaults on restart.
**Key Files**:
- lua/plugins/lsp/blink-cmp.lua - Added toggle functions (lines 30-52), set buffer completion OFF by default for markdown
- lua/plugins/which-key.lua - Added toggle keybindings in `<leader>mt` submenu
**Impact**: Cleaner completion experience while writing markdown. Can still access buffer completion if needed via toggle. LSP and path completion always on.
**Git Commits**: (included in 1d36eeb)

---

## 009: Documentation System
**Status**: Completed (2025-11-13)
**Problem**: Needed standardized documentation approach to preserve context across sessions and prevent work loss from context summarization. Previous projects had inconsistent documentation structures.
**Solution**: Implemented hybrid documentation system with three core files (PROJECT_CONTEXT.md, SESSION_PROTOCOL.md, GLOBAL_SUMMARY_LOG.md) and standardized per-project structure (PLAN.md, SESSION_LOG.md, SUMMARY.md). Created /init command to load context at session start. Backfilled all existing projects to new standard.
**Key Files**:
- .claude/PROJECT_CONTEXT.md - Config overview and preferences
- .claude/SESSION_PROTOCOL.md - Agent behavior guidelines
- .claude/GLOBAL_SUMMARY_LOG.md - Global project summaries (this file)
- .claude/commands/init.md - Session initialization command
- .claude/specs/NNN_project/ - Standardized project structure
**Impact**: Agent maintains full context across sessions. Documentation is consistent and comprehensive. Can resume work after weeks away without losing context. All projects follow same 3-file structure.
**Git Commits**: 0073bb5

---

## 004: Publishing Workflows
**Status**: In Progress (2025-12-04 → ongoing)
**Problem**: Needed LaTeX templates for professional writing and an improved markdown writing environment.
**Solution (Phase 1 — 2025-12-04)**: Created three LaTeX templates (PersonalLetter, ProfessionalLetter with fancyhdr letterhead, SimpleBook with A5 format). Added `<leader>tp/tl/tb` which-key bindings.
**Solution (Phase 2 — 2026-03-26)**: Installed vim-table-mode for live table editing (`<leader>mtt`). Improved render-markdown.nvim: smaller bullet icons (`• ◦ ▸ ▹`), heading colors wired to nightfox palette API so H1–H6 use a distinct orange→maroon→blue→grey-blue hierarchy that auto-adapts to carbonfox/terafox/nightfox by cwd. Background banners graduated from `bg4` down to `bg1` for visual depth.
**Key Files**:
- `lua/plugins/vim-table-mode.lua` — vim-table-mode config (new)
- `lua/plugins/render-markdown.lua` — Heading colors, bullet icons
- `templates/PersonalLetter.tex`, `ProfessionalLetter.tex`, `SimpleBook.tex` — LaTeX templates
**Git Commits**: cb7260e (2026-03-26)

---

## 010: Templating Workflows
**Status**: In Progress (2026-03-26)
**Problem**: Needed quick-insert diagram snippets for markdown writing — triangle ASCII art and a 4x4 quadrant matrix with live dynamic centering.
**Solution**: Triangle as SnipMate snippet (static, 6 tab stops). 4x4Matrix as LuaSnip Lua-native snippet with `functionNode` padding that re-centers content in real time as user types. Two triggers: `4x4Matrix` and `matrix4x4`. Added `from_lua` loader and `region_check_events = "CursorMoved"` to LuaSnip config.
**Key Files**:
- `snippets/markdown.snippets` — Triangle diagram
- `lua/snippets/markdown.lua` — 4x4Matrix + matrix4x4 (new file)
- `lua/plugins/luasnip.lua` — region_check_events, from_lua loader
**Git Commits**: cb7260e

---

## Projects Not Yet Started

### 003: Zettelkasten Refinement
**Status**: Planned
**Purpose**: Enhanced Telescope search for vaults, citation insertion from Literature vault, preview functionality, wikilink improvements

### 005: Integration Testing
**Status**: Planned
**Purpose**: End-to-end testing of integrations

### 006: Knowledge Library
**Status**: Planned
**Purpose**: Organize knowledge resources

### 007: Case Studies
**Status**: Planned
**Purpose**: Document use cases

---

## Notes

- Projects 001, 002, 008, 009 completed across overlapping sessions (2025-11-09 to 2025-11-13)
- Project 001 was the main "second brain setup" that spanned multiple phases
- Project 009 restructured all project documentation to new standard
- Projects 003-007 have PLAN.md files but haven't been started yet
- Git commits reference multiple projects when work overlapped
