# Neovim Second Brain Configuration Specification

**Created**: 2025-11-09
**Status**: Active
**Complexity**: 8/10 (High)

## Overview

Transform neovim into a comprehensive second-brain and coding environment optimized for writing, research, publishing, and Ghost theme development. This configuration should integrate Obsidian zettelkasten, Lectic AI personas, LaTeX publishing, and streamlined workflows for content creation.

## Background

### Previous Work
- Started from Ben's neotex config (fork at `~/.config/nvim:main`)
- Created new simplified branch `nvim-custom` with conventional structure
- Removed nested `neotex/` folder layer for simplicity
- Compared with LazyVim and original neotex at `~/nvim-config-refs/`
- Previous planning work was lost, necessitating reconstruction

### Current State
The `nvim-custom` branch shows significant progress:
- Moved from `lua/neotex/` to `lua/` conventional structure
- Basic Lectic integration functional
- Dashboard and which-key partially configured
- Zen mode working
- Obsidian plugin installed
- Markdown rendering active (needs disabling)

## Functional Requirements

### 1. Writing & Research Environment

#### Second Brain Integration
- **Vault Structure**:
  - Main vault: `~/SecondBrain/` (zettelkasten with wikilinks)
  - Literature vault: `~/SecondBrain/Literature/` (Readwise sync)
- **Search Capabilities**:
  - Search zettelkasten notes
  - Search/browse literature vault
  - Pull citations from Literature into working files
  - Preview notes in popup or new buffer
- **Workflow**:
  - Exit zen mode → search with `[[keyword]]` or custom command
  - Preview results in buffer
  - Insert citations/quotes inline

#### Lectic AI Personas
Create switchable AI personas via templates/snippets with custom which-key menu:

1. **Design Writer** (`<leader>mpw`)
   - Minimalist, accessible style
   - Language as designed object
   - Humble, curious, detail-oriented without verbosity

2. **Editing Expert** (`<leader>mpe`)
   - Nonfiction editor and storytelling expert
   - Deep knowledge of editing theory

3. **Researcher** (`<leader>mpr`)
   - Logician, philosopher, political theorist
   - Neuroscientist, anthropologist, psychologist
   - Expertise: conflict resolution, peacebuilding, restorative justice, organizational psychology

4. **Business Coach** (`<leader>mpb`)
   - Marketing and strategy expert
   - Professional services, consulting, storytelling
   - Business strategy specialist

**Persona Template Format** (Updated 2025-11-10):
```yaml
---
id:
aliases: []
tags: []
interlocutor:
  name: Writer/Researcher
  prompt: [persona-specific prompt]
---
```

**Context File Loading** (EXPERIMENTAL - NOT FULLY WORKING):
- Lectic deprecated `memories:` field in July 2025 (commit a8f5678)
- Current approach uses `file:` prefix in `prompt` field
- Example: `prompt: file:~/SecondBrain/context.md` (loads once at start)
- **Known issues**: Single-line `file:` syntax not loading content (needs testing with multiline YAML)
- See SESSION_LOG.md for current testing status

#### Markdown Settings
- **Rendering**: Disable auto-rendering of markdown elements
- **Syntax**: Color-based syntax highlighting only
- **Zen Mode**: Already functional, maintain current setup
- **Citations**: Support multiple output formats:
  - Markdown
  - LaTeX
  - Zettelkasten notes
  - Other formats TBD

### 2. Publishing Workflows

#### LaTeX Publishing
- Beautiful typesetting for articles and books
- Multiple selectable templates for each format
- Command to copy `.md` content → new buffer with LaTeX template
- Template categories:
  - Articles (existing: PhilPaper, HandOut)
  - Books (Root, SubFile)
  - Presentations (PhilBeamer)
  - Letters

#### E-book Publishing
- Plugin for Kindle/Apple Books export
- High-quality, beautiful layout
- Direct from markdown

#### Presentation Export
Support for:
- Deckset
- Marp
- Reveal.js

#### Ghost.org Integration
- Markdown optimized for Ghost publication
- Custom publishing workflow

### 3. Development Environment

#### Ghost Theme Development
- Handlebars syntax support (already configured)
- Claude Code neovim integration
- Preview/testing workflow

#### Neovim Configuration
- Easy access to config files
- Documentation and cheatsheet integration

#### Future: Frappe LMS
- App development support (defer to later phase)

## Interface Requirements

### Custom Dashboard

```
[f] Search
    - Search Zettelkasten
    - Search Literature Notes
    - Search Project Files
[l] Lectic
    - New Lectic file with base model
    - Quick persona selection
[r] Recent Files
[c] Config
    - Neovim configuration
    - Edit snippets
    - Edit templates
[g] Git
    - Git status
    - Lazygit
    - Commit history
[p] Publishing
    - LaTeX templates
    - Presentation rendering
    - E-book export
    - Ghost publishing
```

### Which-Key Menu Structure

#### `<leader>m` - MARKDOWN/WRITING
```
<leader>m - MARKDOWN & WRITING
  z - Zen mode toggle
  l - Run Lectic on file
  n - New markdown file with Lectic + Obsidian frontmatter
  p - Lectic Personas submenu
    w - Writer persona
    e - Editor persona
    r - Researcher persona
    b - Business coach persona
  s - Submit selection to Lectic with message
  u - Open URL under cursor
  p - Markdown preview toggle

  c - Citations submenu
    z - Search zettelkasten
    l - Search literature
    i - Insert citation

  f - Folding submenu
    a - Toggle all folds
    f - Toggle fold under cursor
    t - Toggle folding method

  b - Toggle buffer completion
  c - Toggle spell completion
  o - Toggle obsidian completion
  x - Toggle luasnip completion
```

#### `<leader>f` - FIND (Enhanced)
```
<leader>f - FIND
  f - Find project files
  a - Find all files (including hidden)
  g - Live grep in project
  b - Find buffers
  r - Recent files

  z - Search zettelkasten notes
  l - Search literature vault
  c - Find citations
  k - Find keymaps
  h - Help tags
  t - Colorschemes
  s - Search string
  w - Search word under cursor
  y - Yank history
  u - Resume last search
```

#### `<leader>p` - PUBLISHING
```
<leader>p - PUBLISHING
  l - LaTeX submenu
    a - Article template
    b - Book template
    p - Presentation template
    t - Convert MD → LaTeX
    c - Compile LaTeX
    v - View PDF

  e - E-book submenu
    k - Export to Kindle
    a - Export to Apple Books
    p - Preview e-book

  s - Slides/Presentations
    d - Export to Deckset
    m - Export to Marp
    r - Export to Reveal.js

  g - Ghost Publishing
    o - Optimize for Ghost
    u - Upload to Ghost
    p - Preview Ghost post

  w - Convert to Word (pandoc)
  h - Convert to HTML (pandoc)
  m - Convert to Markdown (pandoc)
```

#### Other Key Menus (Streamlined)
- `<leader>a` - ACTIONS (keep relevant, remove unused)
- `<leader>g` - GIT (maintain current)
- `<leader>l` - LSP (maintain current)
- `<leader>L` - LIST (maintain current)
- `<leader>s` - SURROUND (maintain current)
- `<leader>S` - SESSIONS (maintain current)
- `<leader>r` - RUN (streamline, keep useful)
- `<leader>t` - TEMPLATES (expand with Lectic personas)
- `<leader>k` - KANBAN (maintain current)

### Keymaps to Review

**Compare** between:
1. Current `nvim-custom` branch keymaps
2. Old `:main` branch keymaps
3. Ben's original neotex keymaps

**Evaluate**:
- Remove: Unused or redundant mappings
- Keep: Functional, frequently-used mappings
- Add: Missing mappings for new workflows

## Technical Considerations

### Plugins to Configure
- **Obsidian.nvim**: Zettelkasten integration, wikilinks
- **Telescope**: Enhanced search for vaults
- **Lectic**: Persona system implementation
- **VimTeX**: LaTeX workflow
- **Pandoc**: Format conversions
- **Ghost**: Publishing integration (may need custom)
- **E-book**: Research plugin options
- **Presentation**: Marp/Reveal.js support

### Disable/Fix
- **render-markdown.nvim**: Currently auto-rendering, need to disable or configure for syntax-only

### Custom Functions Needed
1. Search zettelkasten with preview
2. Search literature vault with preview
3. Insert citations from Literature
4. Create Lectic file with persona template
5. Switch Lectic personas
6. Convert MD → LaTeX with template selection
7. Export to e-book formats
8. Optimize markdown for Ghost

## Non-Goals (Defer)
- Frappe LMS development setup (future enhancement)
- Advanced PDF annotation (keep simple if exists)
- Complex presentation editing (export-only)

## Success Criteria

### Phase 1: Foundation [IN PROGRESS]
- [x] Markdown rendering disabled (syntax coloring only)
- [x] Zettelkasten search functional (dashboard shortcut `z`)
- [x] Literature vault search functional (same as zettelkasten - single vault)
- [x] Lectic persona templates created (4 personas: writer, editor, researcher, business)
- [x] Dashboard customized with new shortcuts
- [ ] **BLOCKED**: Context file loading via `file:` prefix (syntax issue - see constraints)

### Phase 2: Writing Workflow [IN PROGRESS]
- [x] Lectic persona switching via which-key (`<leader>mp` submenu)
- [x] New markdown file command with frontmatter (`<leader>mn`)
- [x] Enhanced `<leader>m` menu functional (merged with writing menu)
- [ ] Citation insertion from Literature vault (deferred - not critical yet)
- [ ] **BLOCKED**: Persona switching preserves context (depends on `file:` prefix fix)

### Phase 3: Publishing Workflow [NOT STARTED]
- [ ] LaTeX template selection and conversion
- [ ] Presentation export (Marp/Reveal.js)
- [ ] E-book export functional
- [ ] Ghost optimization workflow

### Phase 4: Refinement [NOT STARTED]
- [ ] Streamlined keymaps (remove unused)
- [ ] Custom which-key menus finalized
- [ ] Documentation updated
- [ ] All workflows tested end-to-end

## Technical Constraints (Discovered 2025-11-10)

### YAML Frontmatter
1. **Empty fields break parsing**: Cannot have fields like `reminder:` with no value
   - Error: "YAML Header is missing something"
   - Solution: Omit empty fields entirely from templates

2. **Multiline strings require `|` indicator**: Blank lines without `|` cause parse errors
   - Wrong: `prompt: text\n\n  more text`
   - Right: `prompt: |\n  text\n\n  more text`

3. **Obsidian field ordering**: Must follow specific order to prevent rewriting
   - Order: `id`, `aliases`, `tags`, then `interlocutor`
   - Subfields inside `interlocutor` must be alphabetized: `name`, `prompt`, `reminder`
   - Obsidian will rewrite frontmatter if it contains gaps or commented text

### Lectic Context File Loading
1. **`memories:` field deprecated**: Removed in July 2025 (commit a8f5678)

2. **`file:` prefix approach**: Replaced memories with `file:` prefix in `prompt` or `reminder`
   - `prompt` field: Loads file content ONCE at conversation start (system prompt)
   - `reminder` field: Adds content to EVERY user message (expensive for large files)

3. **Current blocker**: Single-line `file:` syntax NOT working
   - Tested: `prompt: file:~/path.md You are a writer...`
   - Result: Lectic sees path as literal text, doesn't load file content
   - Hypothesis: Needs multiline YAML with `|` indicator (UNTESTED)

4. **Proposed syntax** (needs verification):
   ```yaml
   prompt: |
     file:~/SecondBrain/context.md

     You are a design writer...
   ```

### Lazy.nvim Plugin Loading
1. **`init` vs `config` sections**:
   - `init`: Runs immediately on startup (before plugin loads)
   - `config`: Runs when plugin actually loads (on filetype trigger)

2. **Dashboard availability**: Functions called from dashboard must be in `init` section
   - Example: `CreateNewLecticFile()` must be global and defined in `init`
   - File location: `lua/plugins/lectic.lua`

## Open Questions

1. **E-book Plugin**: Which plugin for Kindle/Apple Books export? Research needed.
2. **Ghost Integration**: Custom plugin or script-based workflow?
3. **Citation Format**: Preferred format for different outputs? BibTeX? Pandoc-citeproc?
4. **Template Storage**: Persona templates now in `lua/plugins/lectic.lua` (solved)
5. **Search Preview**: Popup window or split buffer for previews?
6. **Keymaps**: Specific bindings to remove from current config?
7. **`file:` prefix syntax**: What is the correct YAML format for Lectic to load file contents?

## Reference Files

### Current Configuration
- Main config: `~/.config/nvim` (branch: `nvim-custom`)
- Old config: `~/.config/nvim:main`
- Which-key: `lua/plugins/which-key.lua`
- Dashboard: `lua/plugins/snacks/dashboard.lua`
- Lectic: `lua/plugins/lectic.lua`

### Reference Configs
- LazyVim: `~/nvim-config-refs/lazyvim/`
- Ben's neotex: `~/nvim-config-refs/neotex/`

### Second Brain
- Root: `~/SecondBrain/`
- Projects: `~/SecondBrain/1-Projects/`
- Areas: `~/SecondBrain/2-Areas/`
- Zettelkasten: `~/SecondBrain/3-Zettelkasten/`
- Resources: `~/SecondBrain/4-Resources/`
- Archive: `~/SecondBrain/5-Archive/`
- Literature: `~/SecondBrain/Literature/`

## Notes

- User is not a neovim expert - prioritize simplicity and clear documentation
- Previous work was lost - ensure all decisions are documented
- Configuration should be maintainable and understandable
- Focus on actual workflow needs, not complexity for its own sake
