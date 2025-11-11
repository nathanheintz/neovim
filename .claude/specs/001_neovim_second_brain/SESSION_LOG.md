# Neovim Second Brain - Session Log

**Started**: 2025-11-09
**Approach**: Iterative and collaborative - build as we go, document decisions

---

## Session 1: Which-Key Cleanup (IN PROGRESS)

**Date**: 2025-11-09

### Goal
Clean out Ben's config from which-key menus and make them mine.

### Decisions Made

#### Top-Level Mappings
- **KEEP**:
  - `<leader>e` - Toggle NeoTree explorer
  - `<leader>q` - Save all and quit
  - `<leader>d` - Save and delete buffer
  - `<leader>u` - Telescope undo (not discussed, keeping for now)

- **CHANGE**:
  - `<leader>w` → WINDOW menu (was WRITING)
    - Create split
    - Close split
    - Maximize split
    - Any other window management stuff

- **DELETE**:
  - `<leader>k` - Kanban (plugin deleted)
  - `<leader>b` - VimtexCompile (move to publishing menu)
  - `<leader>i` - VimtexTocOpen (move to publishing menu)
  - `<leader>v` - VimtexView (move to publishing menu)
  - `<leader>c` - Create split (goes into window menu)
  - `<leader>j` - Close split (goes into window menu)

#### Menu Deletions
- **DELETE ENTIRE `<leader>a` ACTIONS MENU**
  - Useful items to reincorporate later:
    - `ah` - Toggle local highlight → maybe `<leader>mh`?
    - `ar` - Recalculate autolist → maybe `<leader>mr`?
    - `as` - Edit snippets → maybe `<leader>ms`?
    - `af` - Format buffer → keep in LSP menu
    - `au` - Update CWD → maybe useful later
  - DELETE completely:
    - All VimTeX actions (already moved to publishing)
    - `al` - Lean info (Ben's formal math stuff)
    - `am` - Model checker (Ben's tool)
    - `ap` - Run Python (not needed)
    - `aS` - SSH to MIT (definitely Ben's!)
    - `aa` - PDF annotations
    - `ab` - Export bibliography
    - `ag` - Edit glossary

#### Menu Merges
- **MERGE `<leader>w` WRITING + `<leader>m` MARKDOWN → `<leader>m`**
  - All markdown/writing stuff lives under `<leader>m`
  - Lectic commands stay here
  - Zen mode goes here (`<leader>mz`)
  - Word count goes here (`<leader>mw`?)

#### Menu Reorganizations
- **`<leader>p` becomes PUBLISHING** (was PANDOC):
  - VimTeX compile → `<leader>pc`?
  - VimTeX view → `<leader>pv`?
  - VimTeX TOC → `<leader>pi`?
  - Keep pandoc conversions for now
  - Will organize better later when we actually need it

#### Delete Other Stuff
- **`<leader>k` KANBAN menu** - plugin deleted, remove entirely
- **`<leader>t` TEMPLATES menu** - clean out Ben's academic templates:
  - KEEP: `tl` - Letter.tex
  - DELETE: PhilPaper, Glossary, HandOut, PhilBeamer, SubFile, Root, MultipleAnswer

### Files to Modify
- `lua/plugins/which-key.lua`

### Changes Made

**Completed**:
- ✅ Removed Harpoon commented code
- ✅ Deleted KANBAN menu entirely
- ✅ Cleaned up ACTIONS menu (kept: pdf annotations, highlight word, reorder list, edit snippets, update cwd)
  - Removed: format buffer (moved to CODE menu)
- ✅ Merged WRITING into MARKDOWN menu at `<leader>m`
- ✅ Created WINDOW menu at `<leader>w` (create split, close split, maximize)
- ✅ Transformed PANDOC → PUBLISHING menu with all VimTeX commands
- ✅ Cleaned TEMPLATES menu (only Letter template remains)
- ✅ Moved citations search (`fc`) from FIND to PUBLISHING menu (`pf`)
- ✅ Deleted LIST menu entirely (was: checkbox toggle, next/prev/reorder list items)
  - Note: Autolist plugin still works, just removed the which-key mappings
  - Reorder list kept in ACTIONS menu (`ar`)
- ✅ Created CODE menu at `<leader>c` (beginner-friendly LSP features)
- ✅ Deleted LSP menu at `<leader>l` (replaced by CODE menu)
- ✅ Created SURROUND submenu at `<leader>ms` (markdown → surround)
- ✅ Deleted SURROUND menu at `<leader>s`
- ✅ Moved SESSIONS from `<leader>S` → `<leader>s`
- ✅ Kept GIT menu (all git operations useful)

**File Modified**: `lua/plugins/which-key.lua`

**Menus Deleted & Documentation**:

*KANBAN* - Plugin was removed

*LIST* - Autolist works automatically, didn't need manual controls
- Deleted: checkbox toggle, next/prev/reorder list items
- Kept: reorder list in ACTIONS menu (`<leader>ar`)

*LSP* - Replaced with simplified CODE menu at `<leader>c`
- **KEPT in CODE menu** (beginner-friendly):
  - `cf` - Format
  - `cd` - Go to definition
  - `ch` - Hover help
  - `cn` - Next error
  - `cp` - Previous error
  - `ca` - Code action
  - `cr` - Rename
- **DELETED** (can add back later if needed):
  - `lb` - Buffer diagnostics (Telescope diagnostics for current file)
  - `lD` - Go to declaration (different from definition)
  - `li` - Implementations (Telescope lsp_implementations)
  - `lk` - Kill LSP (LspStop)
  - `ll` - Line diagnostics (vim.diagnostic.open_float)
  - `lr` - References (Telescope lsp_references)
  - `ls` - Restart LSP (LspRestart)
  - `lt` - Start LSP (LspStart)
  - `ly` - Copy diagnostics to clipboard
  - `lT` - Type definition (commented out)

*SURROUND* - Moved to `<leader>ms` submenu (makes more sense with writing)

### Next Steps
1. ✅ ~~Make these changes to which-key.lua~~ DONE
2. ✅ ~~Test that everything still works~~ DONE - menus work
3. ✅ ~~Move to dashboard cleanup~~ DONE
4. Then assess Obsidian setup (if needed)

---

## Session 2: Dashboard Cleanup (COMPLETED)

**Date**: 2025-11-09

### Goal
Simplify dashboard shortcuts and fix ronin image display.

### Changes Made

**Dashboard shortcuts** (`lua/plugins/snacks/dashboard.lua`):
- `e` - Explorer (NeoTree)
- `r` - Recent Files
- `f` - Find File
- `n` - Config (browse nvim config files)
- `b` - Second Brain (open NeoTree in SecondBrain folder)
- `z` - Search Zettelkasten (grep entire SecondBrain)
- `a` - README
- `c` - Cheatsheet
- `m` - Manage Plugins
- `q` - Quit

**Deleted shortcuts**:
- `s` - Restore Session (now at `<leader>s`)
- `g` - Find Text (redundant with `z`)
- `n` - New File (not needed)
- `i` - Info (duplicate of cheatsheet)
- `h` - Checkhealth (moved to `<leader>ac`)

**Ronin image fixes**:
- Reduced width: `W 44` → `W 35`
- Reduced height: `50` → `35`
- Suppressed "[process exited 0]": added `2>/dev/null` to command
- Note: Image should bump below menu when window is narrow (responsive layout)

### Notes
- Literature vault is INSIDE SecondBrain vault at `~/SecondBrain/Literature/`
- No multi-vault setup needed - it's all one vault
- Obsidian and Lectic frontmatter already work together fine
- Zettelkasten linking already works
- Most core functionality is already there, just need to clean up menus

---

## Session 3: Lectic Persona System (COMPLETED)

**Date**: 2025-11-10

### Goal
Implement Lectic persona system with switchable AI writing assistants and combined Obsidian + Lectic frontmatter.

### Changes Made

**Lectic Configuration** (`lua/plugins/lectic.lua`):
- Added 4 persona templates (writer, editor, researcher, business)
- Created `CreateNewLecticFile(persona)` function:
  - Opens `.md` file (not `.lec`) for Obsidian compatibility
  - Combined Obsidian + Lectic frontmatter
  - Persona selection menu on creation
  - Default filename: `YYYY-MM-DD.md`
- Created `SwitchLecticPersona(persona)` function:
  - Switches persona in current file
  - Preserves Obsidian fields (id, aliases, tags, memories)
  - Updates interlocutor name and prompt
  - Works with both `.md` and `.lec` files

**Which-Key Menu** (`lua/plugins/which-key.lua`):
- Added `<leader>mp` - PERSONAS submenu:
  - `<leader>mpw` - Design Writer persona
  - `<leader>mpe` - Editing Expert persona
  - `<leader>mpr` - Researcher persona
  - `<leader>mpb` - Business Coach persona
  - `<leader>mpp` - Choose persona (selection menu)
- Moved markdown preview from `<leader>mp` to `<leader>mv`

**Dashboard** (`lua/plugins/snacks/dashboard.lua`):
- User manually added `n` shortcut for "New Lectic File"

**Colorscheme** (`lua/plugins/colorscheme.lua`):
- Switched from nightfly to terafox (green variant of nightfox)
- Removed `provider: anthropic` field from frontmatter (set globally in config)

**Documentation Updates**:
- Updated `README.md` with persona features
- Updated `cheatsheet-readme/nvim-cheatsheet.md`:
  - Removed Avante section (plugin not in use)
  - Removed phantom Lectic commands that don't exist
  - Added accurate Lectic persona documentation
  - Documented actual workflow

### Persona Details

1. **Design Writer**
   - Minimalist, accessible style
   - Language as designed object
   - Humble, curious, detail-oriented
   - Focus: Internal arts, personal development, leadership, philosophy

2. **Editing Expert**
   - Nonfiction editor and storytelling expert
   - Deep editing theory knowledge
   - Helps with structure, clarity, narrative flow

3. **Researcher**
   - Philosopher, logician, political theorist
   - Neuroscientist, anthropologist, psychologist
   - Expertise: Conflict resolution, peacebuilding, restorative justice, organizational psychology

4. **Business Coach**
   - Marketing and strategy expert
   - Professional services, consulting focus
   - Business storytelling and compelling narratives

### File Structure

Combined Obsidian + Lectic frontmatter format (updated 2025-11-10):
```yaml
---
id:
aliases: []
tags: []
interlocutor:
  name: Design Writer
  prompt: [persona-specific prompt]
  reminder:
---
```

**Field Order**:
- **Obsidian fields first** (in Obsidian's processing order): `id`, `aliases`, `tags`
- **Lectic `interlocutor` field**
- **Inside `interlocutor`** (alphabetized): `name`, `prompt`, `reminder`

**Note**: Obsidian alphabetizes unknown fields, so we alphabetize `interlocutor` subfields to match

### Workflow

1. **Create new file**: `<leader>mn` or dashboard `n`
2. **Choose persona**: Selection menu appears
3. **Write content**: Start writing below frontmatter
4. **Switch persona**: Use `<leader>mp` menu to change mid-document
5. **Run Lectic**: `:Lectic` or `<leader>ml` to process file
6. **Visual selections**: Select text + `<leader>mS` for targeted feedback

### Technical Notes

**Lectic Architecture**:
- Lectic plugin is simple: calls `lectic` CLI binary via stdin/stdout
- CLI only has `-s` (short), `-c` (consolidate), `-f` (file) options
- Personas are managed in nvim config, not in Lectic itself
- Files are regular `.md` for full Obsidian integration
- `.lec` extension still works but not recommended

**Plugin Loading Strategy**:
- Lectic is lazy-loaded: `lazy = true, ft = { "markdown", "lectic.markdown" }`
- Plugin only loads when opening markdown/lectic files
- BUT persona functions need to be available immediately (for dashboard)
- Solution: Put functions in `init` section (runs on startup) not `config` section (runs on plugin load)
- File location: `~/.config/nvim/lua/plugins/lectic.lua`

**Neovim Config Structure**:
```
~/.config/nvim/
├── init.lua              # Entry point - loads core and bootstrap
├── lua/
│   ├── bootstrap.lua     # Sets up Lazy.nvim, imports plugins/
│   ├── core/             # Core vim settings
│   └── plugins/          # Each .lua file = plugin spec
│       ├── lectic.lua    # Persona functions in init section
│       ├── which-key.lua # Keybinding menus
│       └── snacks/
│           └── dashboard.lua
```

**How Lazy.nvim Works**:
1. `bootstrap.lua` tells Lazy: `{ import = "plugins" }`
2. Lazy reads every `.lua` file in `lua/plugins/`
3. Each file returns a plugin spec with:
   - `init = function()` - runs immediately on startup
   - `config = function()` - runs when plugin actually loads
4. Persona functions in `init` = available for dashboard immediately

### Troubleshooting Log

**Issue 1**: Dashboard shortcut error - `CreateNewLecticFile` is nil
**Cause**: Functions were in `config` section (only runs when opening markdown)
**Solution**: Moved to `init` section (runs immediately on startup)
**Files modified**: `lua/plugins/lectic.lua` (lines 12-202)

**Issue 2**: Lectic couldn't access context files via `memories` field
**Investigation**:
- `memories` field was deprecated in Lectic (July 2025, commit a8f5678)
- Current approach uses `file:` prefix in `prompt` or `reminder` fields
- `file:~/path.md` tells Lectic to load that file's content
**Solution**:
- Use `reminder:` field for context (invisibly added to every user message)
- Updated persona templates to include `reminder:` field
- Persona switching now preserves `reminder` value
**Files modified**: `lua/plugins/lectic.lua` (lines 45-202)

**Issue 3**: Obsidian rearranged frontmatter fields on save
**Cause**: Obsidian alphabetizes unknown fields
**Solution**:
- Obsidian fields first (Obsidian's order): `id`, `aliases`, `tags`
- Then `interlocutor` with alphabetized subfields: `name`, `prompt`, `reminder`
- This matches Obsidian's behavior so it doesn't rearrange
**Files modified**: `lua/plugins/lectic.lua` (frontmatter generation)

### Context Management Testing (2025-11-10 Evening)

**Goal**: Get `file:` prefix working to load context files into Lectic prompts.

**Issue 4**: Empty YAML fields break parsing
**Test**: Frontmatter with `reminder:` (no value) field
```yaml
interlocutor:
  name: Design Writer
  prompt: You are a design writer...
  reminder:
---
```
**Result**: YAML parse error: "YAML Header is missing something. One or more interlocutors need to be specified."
**Root cause**: YAML parser doesn't accept empty field values in this context
**Solution**: Remove empty `reminder:` field entirely from templates

**Issue 5**: `file:` prefix with blank lines requires multiline syntax
**Test 1**: Blank lines without `|` indicator
```yaml
prompt: file:~/path.md

   You are a design writer...
```
**Result**: YAML parse error about missing interlocutor
**Conclusion**: Need `|` indicator for multiline YAML strings

**Issue 6**: `file:` prefix NOT loading file content (CRITICAL - UNSOLVED)
**Test 2**: Single line with `file:` prefix
```yaml
interlocutor:
  name: Design Writer
  prompt: file:~/SecondBrain/1-Projects/Book-Meditation/Meditation-Book-Posture-of-Mind.md
    You are a design writer with a minimalist, accessible style...
---
```
**Result**: Lectic responded to user message BUT when asked about file content, said:
> "I don't actually have access to your 'Posture of Mind' file. When you included the file path... This was just text that I can see, but I don't have the ability to access or read files on your device..."

**Critical finding**: The `file:` prefix is being treated as literal text, NOT triggering Lectic's file loader.

**Hypothesis**: `file:` needs to be on its own line with proper multiline YAML syntax:
```yaml
prompt: |
  file:~/SecondBrain/path.md

  You are a design writer...
```

**Status**: NEEDS TESTING - haven't verified this syntax actually works

### Documentation Tracking Issues

**Problem**: Not updating SPEC.md systematically, only SESSION_LOG.md
**User feedback**: "Why aren't you tracking our work??? [...] please be more systematic."
**Required improvement**: Update SPEC.md with constraints and current approach, mark completed phases

### Current Constraints Discovered

1. **Empty YAML fields**: Cannot have fields like `reminder:` with no value - breaks parsing
2. **`file:` prefix syntax**: Still unknown - single-line approach doesn't work
3. **Multiline YAML**: Likely needs `|` indicator for multiline strings
4. **Obsidian frontmatter**: Will rewrite if it contains gaps and commented text
5. **Field ordering**: Must be: `id`, `aliases`, `tags`, then `interlocutor` with alphabetized subfields

### RESOLUTION (2025-11-10 Early Afternoon)

**Problem solved by user testing:**

The correct syntax for loading context files is:
```yaml
interlocutor:
  name: Design Writer
  prompt: file:/Users/nathanheintz/SecondBrain/path.md
    You are a design writer with minimalist style...
```

**Key findings:**
1. **Absolute paths required** - NOT tilde `~`, NOT relative paths for reliability
2. **`file:` prefix works on same line** - The entire prompt field can contain both file reference and persona text
3. **Multiple interlocutors design** - Lectic is designed to have ALL personas defined in frontmatter, switch with `:ask[Name]` directive
4. **Context in messages** - Use markdown links `[Context](absolute/path.md)` in conversation body

**What we should have done:**
- Read Lectic documentation FIRST before any code analysis
- Used absolute paths from the start (clearly stated in docs)
- Recognized Lectic's multiparty conversation design

**Process failures documented:**
- Claude failed to locate documentation when blocked, pivoted to source code instead of asking for help
- User explicitly asked for documentation review multiple times before providing direct links
- Solution-implementer, not problem-identifier/solver
- User solved the problem through testing

### Multi-Persona System Implementation (2025-11-10 Afternoon)

**Goal**: Implement both multi-persona modes AND individual personas using Lectic's native multiparty design.

**Persona Modes Created**:

1. **Business Mode** (4 personas):
   - Consultant - Business strategy + professional services BD specialist
   - Marketing - Marketing and storytelling specialist
   - Finance - Finance expert
   - Product - Product and service design expert

2. **Writing Mode** (3 personas):
   - Researcher - Logician, philosopher, neuroscientist, conflict resolution expert
   - Writer - Design writer with minimalist, accessible style
   - Editor - Nonfiction editor and storytelling expert

3. **Workshop Design Mode** (3 personas):
   - Designer - Workshop designer & facilitator with facilitation tool library
   - Scholar - Scientific researcher for rigorous, cited research
   - Scribe - Succinct writer for slide notes and content

4. **Homie** (1 persona) - Aspirational generalist
5. **Nomad** (1 persona) - Travel planner & digital nomadism expert

**Implementation Changes**:

Files modified:
- `lua/plugins/lectic.lua`:
  - Removed `SwitchLecticPersona()` function (no longer needed)
  - Completely rewrote `CreateNewLecticFile()` for multiparty mode selection
  - Creates frontmatter with `interlocutors:` array
- `lua/plugins/which-key.lua`:
  - Removed PERSONAS submenu (`<leader>mp`)
  - Created TOGGLES submenu (`<leader>mt`) consolidating completion and folding toggles
  - Updated menu descriptions
- `lua/core/options.lua`:
  - Added `file:` abbreviation → `file:/Users/nathanheintz/SecondBrain/`
  - Only active in markdown/lectic.markdown files

**Frontmatter Structure** (Obsidian-compatible):
```yaml
---
id:
aliases: []
tags: []
interlocutors:
  - name: Consultant
    prompt: You are a business strategy expert...
  - name: Marketing
    prompt: You are a marketing and storytelling specialist...
---
```

**Usage Workflow**:
1. `<leader>mn` - Create new Lectic file
2. Select mode (Business/Writing/Workshop/Homie/Nomad)
3. All personas for mode available in one file
4. Switch during conversation: `:ask[PersonaName]`

**Technical Notes**:
- One-word persona names for easier typing in `:ask[]` directives
- Mode-based grouping reduces frontmatter size vs always loading all personas
- Follows Lectic's native multiparty conversation design
- Compatible with Obsidian field ordering

**See Also**: `LECTIC_REDESIGN.md` for complete implementation details

### Next Steps

1. ✅ **COMPLETE**: Multi-persona system implemented
2. **TO TEST**: Verify multiparty workflow with real writing session
3. **TO UPDATE**: README.md and CHEATSHEET.md with new workflow
4. **TO DOCUMENT**: Add to maintenance log

---

## Future Sessions (TBD)

### Session 2: Dashboard Cleanup
- Update dashboard shortcuts
- Remove Ben's stuff
- Add quick access to Second Brain

### Session 3: Obsidian Assessment
- Review current Obsidian setup
- See if anything needs tweaking
- Make sure everything works smoothly

### Session 4+: Build As Needed
- Lectic persona system (if/when needed)
- Publishing workflows (when ready to publish)
- Citation stuff (when actively using)
- Whatever else comes up

---

## Key Principles

1. **Iterative**: Build piece by piece, test as we go
2. **Simple**: Only add what's actually needed NOW
3. **Document**: Write down all decisions so we don't lose work
4. **Collaborative**: Work together, make decisions together
5. **Practical**: Focus on actual workflow, not theoretical features
