# Neovim Second Brain - Session Log

**Started**: 2025-11-09
**Approach**: Iterative and collaborative - build as we go, document decisions

---

## Session 4: Lectic Single-Party Persona System

**Date**: 2025-11-11
**Status**: COMPLETED

### Goal
Convert Lectic from broken multi-party mode to working single-party mode with persona switching and context file loading.

### Problem Discovery
Multi-party conversations in Lectic beta6 are broken. Using `:ask[PersonaName]` directive produces error:
```
<error>Something went wrong when executing a command:<stdout from="PersonaName">undefined</stdout><stderr from="PersonaName">undefined</stderr></error>
```

### Solution Implemented

**Single-Party Mode with Manual Switching**:
- Use `interlocutor:` (singular) in frontmatter
- Switch personas via `<leader>mp` which-key menu
- Add context files via markdown links in document body

**Context File Loading**:
- Use markdown link syntax: `[Context](/absolute/path.md)`
- `<leader>mc` inserts template with path completion
- Use `Ctrl+x Ctrl+f` to complete file paths

### Implementation Details

**New Functions** (`lua/plugins/lectic.lua`):

1. **`InsertContextLink()`** (line 219):
   - Inserts `[Context](/Users/nathanheintz/SecondBrain/)`
   - Positions cursor after last `/`
   - Starts insert mode

2. **`SwitchLecticPersona(persona_name)`** (line 280):
   - Finds persona from `all_personas` table (12 personas)
   - Reads current frontmatter
   - Preserves Obsidian fields (`id`, `aliases`, `tags`)
   - Updates only `interlocutor.name` and `interlocutor.prompt`
   - Writes new frontmatter

3. **`CreateNewLecticFile()`** (line 187):
   - Always creates with Homie persona
   - Generates Obsidian-compatible frontmatter
   - Prompts for save location

**Disabled Multi-Party Code**:
All multi-party code commented out with: `-- MULTI-PARTY DISABLED: Multi-party conversations are broken in Lectic beta6`

Sections disabled:
- Multi-party persona modes (business, writing, workshop, test) - lines 27-96
- Multi-party frontmatter generation - lines 118-131
- Test mode template logic - lines 137-151
- Multi-party mode selection menu - lines 189-213

**New Which-Key Keybindings** (`lua/plugins/which-key.lua`):
- `<leader>mc` - Insert context link (line 328)
- `<leader>mp` - Persona switching submenu (lines 330-345):
  - `c` - Consultant
  - `m` - Marketing
  - `f` - Finance
  - `p` - Product
  - `r` - Researcher
  - `w` - Writer
  - `e` - Editor
  - `d` - Designer
  - `s` - Scholar
  - `b` - Scribe
  - `h` - Homie
  - `n` - Nomad

### Persona List (12 Total)

**Business**:
- Consultant - Strategy expert, business development
- Marketing - Storytelling, marketing strategies
- Finance - Financial planning, pricing, budgets
- Product - Service design, customer experiences

**Writing**:
- Researcher - Philosopher, logician, conflict resolution expert
- Writer - Design writer, minimalist accessible style
- Editor - Nonfiction editor, storytelling expert

**Workshop**:
- Designer - Workshop designer, facilitation tools
- Scholar - Research scientist, academic rigor
- Scribe - Succinct writer, slide notes, workshop content

**General**:
- Homie - Aspirational generalist, systems thinker
- Nomad - Travel planner, digital nomadism expert

### Workflow

1. **Create new file**: `<leader>mn` (creates with Homie)
2. **Add context**: `<leader>mc` → insert markdown link → `Ctrl+x Ctrl+f` for path completion
3. **Switch persona**: `<leader>mp` → select persona
4. **Write content**: Add questions/text in document body
5. **Run Lectic**: `<leader>ml` processes entire file

### File Structure

**Frontmatter format**:
```yaml
---
id:
aliases: []
tags: []
interlocutor:
  name: Homie
  prompt: You are a logician, philosopher...
---

[Context](/Users/nathanheintz/SecondBrain/file.md)

Question or content here
```

**Field Order**:
- Obsidian fields: `id`, `aliases`, `tags`
- Lectic field: `interlocutor` (singular)
- Subfields: `name`, `prompt`

### Documentation Updated

**Cheatsheet** (`cheatsheet-readme/lectic-cheatsheet.md`):
- Complete rewrite for single-party workflow
- Added keybinding reference
- Added persona switching menu
- Updated context file loading instructions
- Documented multi-party as disabled

**README** (`README.md`):
- Updated quick reference with new keybindings

**Project Docs**:
- Created `.claude/specs/002_lectic_single_party/summaries/001_implementation_summary.md`
- Updated STATUS.md with current state

### Git Commits

**Commit 065c7c6**: feat: implement single-party Lectic persona system
- Added persona switching and context link insertion
- Simplified file creation
- Commented out multi-party code
- Updated documentation

**Commit 1d36eeb**: chore: update configuration and documentation
- Updated Claude Code configuration
- Added project documentation
- Updated plugin configurations

### Known Issues

1. **Multi-party broken** - `:ask[Name]` produces undefined errors (Lectic beta6 bug)
2. **Must use markdown links** - `file:` prefix in frontmatter doesn't work
3. **Absolute paths required** - tilde (`~`) not supported
4. **Manual persona switching** - Cannot switch within conversation

### Future Work

**When Multi-Party Fixed**:
1. Uncomment multi-party code in `lectic.lua`
2. Restore multi-party modes (business, writing, workshop)
3. Re-enable `:ask[Name]` directive
4. Update documentation

---

## Session 3: Lectic Multi-Party Investigation

**Date**: 2025-11-10
**Status**: BLOCKED - Multi-party broken in Lectic beta6

### Goal
Implement multi-party Lectic conversations with context file loading.

### Outcome
Discovered multi-party mode is broken. `:ask[PersonaName]` directive produces undefined errors. Transitioned to single-party implementation (Session 4).

---

## Session 2: Dashboard Cleanup

**Date**: 2025-11-09
**Status**: COMPLETED

### Changes Made
- Cleaned up dashboard shortcuts
- Added Lectic file creation shortcut
- Updated colorscheme configuration

---

## Session 1: Which-Key Cleanup

**Date**: 2025-11-09
**Status**: COMPLETED

### Goal
Clean out Ben's config from which-key menus and make them mine.

### Decisions Made

#### Top-Level Mappings
- **KEEP**:
  - `<leader>e` - Toggle NeoTree explorer
  - `<leader>q` - Save all and quit
  - `<leader>d` - Save and delete buffer
  - `<leader>u` - Telescope undo

- **CHANGE**:
  - `<leader>w` → WINDOW menu
    - Create split
    - Close split
    - Maximize split

- **DELETE**:
  - `<leader>k` - Kanban (plugin deleted)
  - `<leader>b` - VimtexCompile (moved to publishing)
  - `<leader>i` - VimtexTocOpen (moved to publishing)
  - `<leader>v` - VimtexView (moved to publishing)
  - `<leader>c` - Create split (moved to window menu)
  - `<leader>j` - Close split (moved to window menu)

#### Menu Reorganizations
- **MERGE `<leader>w` WRITING + `<leader>m` MARKDOWN → `<leader>m`**
  - All markdown/writing under `<leader>m`
  - Lectic commands here
  - Zen mode: `<leader>mz`

- **`<leader>p` becomes PUBLISHING**:
  - VimTeX compile, view, TOC
  - Pandoc conversions
  - Bibliography tools

#### Menu Deletions
- **DELETED `<leader>a` ACTIONS** - Moved useful items elsewhere
- **DELETED `<leader>k` KANBAN** - Plugin removed
- **DELETED `<leader>L` LIST** - Autolist still works, just no menu
- **DELETED `<leader>l` LSP** - Replaced with `<leader>c` CODE menu
- **DELETED `<leader>s` SURROUND** - Moved to `<leader>ms` submenu
- **DELETED `<leader>t` TEMPLATES** - Cleaned to only Letter template

#### New Menus Created
- **`<leader>w` WINDOW** - Split management
- **`<leader>c` CODE** - Beginner-friendly LSP features
- **`<leader>ms` SURROUND** - Text surround operations (submenu)
- **`<leader>mt` TOGGLES** - Completion and folding toggles (submenu)

### Files Modified
- `lua/plugins/which-key.lua` - Complete reorganization

### Changes Made
- ✅ Removed Harpoon commented code
- ✅ Deleted KANBAN menu
- ✅ Cleaned ACTIONS menu
- ✅ Merged WRITING into MARKDOWN menu
- ✅ Created WINDOW menu
- ✅ Transformed PANDOC → PUBLISHING menu
- ✅ Cleaned TEMPLATES menu
- ✅ Deleted LIST menu
- ✅ Created CODE menu
- ✅ Deleted LSP menu
- ✅ Created SURROUND submenu
- ✅ Deleted SURROUND menu
- ✅ Moved SESSIONS from `<leader>S` → `<leader>s`
