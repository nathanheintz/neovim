# Implementation Plan: Zettelkasten Refinement - Search & Citations

**Created**: 2025-11-11
**Status**: In Progress
**Complexity**: 6/10 (Medium-High)
**Estimated Duration**: 6-8 hours

## Executive Summary

This plan implements comprehensive search and citation workflows for the Second Brain vault system. The goal is to make it easy to search, preview, and link between notes in both the Zettelkasten and Literature vaults using Telescope-based search with live preview and seamless citation insertion.

## Project Goals

### Primary Objectives
1. **Search Functionality**: Four distinct search commands with live preview
   - Zettelkasten file name search
   - Zettelkasten content grep
   - Literature vault file name search
   - Literature vault content grep

2. **Citation Workflow**: Easy insertion of references and links
   - Insert wikilinks from Zettelkasten notes
   - Insert citations from Literature vault
   - Support both markdown and LaTeX citation formats

3. **Preview & Navigation**: Rich preview and easy navigation
   - Live markdown preview in Telescope picker
   - Quick navigation to referenced notes
   - Cross-vault linking support

### Secondary Objectives
- Explore tag-based search
- Implement note templates for new zettel creation
- Add backlink navigation
- Consider daily note integration

## Current State

**What Works**:
- Basic Telescope file finding with `<leader>ff`
- Basic Telescope grep with `<leader>fg`
- Obsidian.nvim installed (not fully configured)

**What's Missing**:
- Vault-specific search commands
- Live markdown preview in search results
- Citation insertion functions
- Cross-vault wikilink navigation
- Which-key menu organization for search

## Technical Approach

### Search Implementation

**Telescope-Based Solution**:
- Use `telescope.builtin.find_files` for file name searches
- Use `telescope.builtin.live_grep` for content searches
- Configure `search_dirs` parameter for vault-specific searches
- Add markdown preview configuration

**Why Telescope**:
- Already familiar to user
- Excellent preview support
- Highly customizable
- Consistent UX with existing workflow

### Citation Format Strategy

**Markdown Files**:
- Default to Obsidian wikilinks: `[[vault/note|display text]]`
- Support short form: `[[note]]` (Obsidian auto-resolves)

**LaTeX Files**:
- Detect `.tex` filetype
- Use BibTeX citation format: `\cite{key}`, `\citet{key}`, `\citep{key}`
- Prompt for citation style on insertion

**Auto-Detection**:
```lua
function get_citation_format()
  local filetype = vim.bo.filetype
  if filetype == "tex" then
    return "bibtex"
  else
    return "wikilink"
  end
end
```

### Preview Configuration

**Markdown Preview in Telescope**:
- Enable markdown preview for `.md` files
- Show first 20 lines or configurable limit
- Syntax highlighting in preview pane

## Implementation Phases

### Phase 1: Basic Search Functions (2-3 hours)

**Objective**: Implement four vault-specific search commands with preview.

**Tasks**:
- [x] Update current which-key for basic functionality
  - Review current `<leader>f` FIND menu in `lua/plugins/which-key.lua`
  - Remove unused or redundant commands
  - Add missing basic commands (current buffer grep, etc.)
  - Update icons for better visual organization
  - Ensure descriptions are clear and concise
  - Test all existing commands to verify they work

- [x] Create zettelkasten content search function
  - ~~Add `search_zettelkasten_grep()` to `lua/core/functions.lua`~~
  - ~~Use `telescope.live_grep` with `search_dirs = {"~/SecondBrain/3-Zettelkasten/"}`~~
  - Implemented directly in which-key.lua
  - Keybinding: `<leader>fz` (grep zettelkasten)
  - **Note**: Directory is `3-Zettelkasten` not `3-Zettelkasten`

- [x] Create literature content search function
  - ~~Add `search_literature_grep()` to `lua/core/functions.lua`~~
  - ~~Use `telescope.live_grep` with `search_dirs = {"~/SecondBrain/Literature/"}`~~
  - Implemented directly in which-key.lua
  - Keybinding: `<leader>fl` (grep lit notes)

- [ ] Create zettelkasten file search function
  - Add `search_zettelkasten_files()` to `lua/core/functions.lua`
  - Use `telescope.find_files` with `search_dirs = {"~/SecondBrain/3-Zettelkasten/"}`
  - Configure markdown preview
  - Keybinding: TBD (maybe `<leader>fzf` or submenu)

- [ ] Create literature file search function
  - Add `search_literature_files()` to `lua/core/functions.lua`
  - Use `telescope.find_files` with `search_dirs = {"~/SecondBrain/Literature/"}`
  - Configure markdown preview
  - Keybinding: TBD (maybe `<leader>flf` or submenu)

- [ ] Configure Telescope preview
  - Edit `lua/plugins/telescope.lua` or create telescope config
  - Enable markdown syntax highlighting in preview
  - Set preview window size and position
  - Test with various file types

- [x] Add which-key menu structure
  - ~~Edit `lua/plugins/which-key.lua`~~
  - ~~Organize under `<leader>f` (FIND menu)~~
  - Simplified: `<leader>fz` and `<leader>fl` are direct commands (not submenus)
  - Added descriptions for each command
  - Also added window management keybindings (`<leader>w` menu)
  - Fixed sort order to use "manual" instead of "alphanum"

**Success Criteria**:
- All four search commands return results
- Markdown preview shows in Telescope picker
- Preview includes syntax highlighting
- Search is fast (<500ms for typical vault)
- Which-key menu shows organized structure

**Files Modified**:
- `lua/core/functions.lua` - New search functions
- `lua/plugins/which-key.lua` - Keybindings and menu
- `lua/plugins/telescope.lua` - Preview configuration (if needed)

---

### Phase 2: Citation Insertion (2-3 hours)

**Objective**: Implement citation and wikilink insertion from search results.

**Tasks**:
- [ ] Create wikilink insertion function
  - Add `insert_zettelkasten_link()` to `lua/core/functions.lua`
  - Search zettelkasten with Telescope
  - On selection, extract filename
  - Insert at cursor: `[[3-Zettelkasten/filename]]`
  - Keybinding: `<leader>fzi` (find → zettelkasten → insert)

- [ ] Create citation insertion function
  - Add `insert_literature_citation()` to `lua/core/functions.lua`
  - Search literature with Telescope
  - Detect filetype (markdown vs LaTeX)
  - For markdown: Insert `[[Literature/filename|title]]`
  - For LaTeX: Extract citation key, insert `\cite{key}`
  - Keybinding: `<leader>fli` (find → literature → insert)

- [ ] Implement citation format detection
  - Add `get_citation_format()` helper function
  - Check `vim.bo.filetype`
  - Return "wikilink" or "bibtex"

- [ ] Add citation style selection for LaTeX
  - Create `select_citation_style()` function
  - Use `vim.ui.select` with options: `\cite{}`, `\citet{}`, `\citep{}`
  - Store user preference in `vim.g.citation_style`
  - Apply preference on next citation

- [ ] Extract citation keys from literature files
  - Add `extract_citation_key(filepath)` function
  - Read frontmatter for `citekey:` field
  - Fallback to filename if no citekey found
  - Handle BibTeX files if present

- [ ] Test citation workflow end-to-end
  - Create test note in zettelkasten
  - Insert literature citation
  - Verify wikilink format correct
  - Create test LaTeX document
  - Insert literature citation
  - Verify BibTeX format correct

**Success Criteria**:
- Can search and insert zettelkasten links
- Can search and insert literature citations
- Citations formatted correctly for markdown
- Citations formatted correctly for LaTeX
- Citation key extraction works
- User preference for citation style persists

**Files Modified**:
- `lua/core/functions.lua` - Citation functions
- `lua/plugins/which-key.lua` - Citation keybindings

---

### Phase 3: Navigation & Cross-Vault Linking (1-2 hours)

**Objective**: Enable seamless navigation between linked notes.

**Tasks**:
- [ ] Enhance wikilink following
  - Verify Obsidian.nvim `gf` mapping works
  - Test cross-vault navigation (Zettelkasten → Literature)
  - Test cross-vault navigation (Literature → Zettelkasten)
  - Add fallback if Obsidian.nvim fails

- [ ] Create custom follow-link function (if needed)
  - Add `follow_wikilink()` to `lua/core/functions.lua`
  - Parse wikilink under cursor
  - Resolve vault path (Zettelkasten vs Literature)
  - Open file in current or split window
  - Handle missing files gracefully

- [ ] Add backlink navigation
  - Add `show_backlinks()` function using Telescope
  - Search all vaults for wikilinks to current file
  - Show results in Telescope picker
  - Keybinding: `<leader>fb` (find → backlinks)

- [ ] Implement quick note creation
  - Add `create_zettel_from_selection()` function
  - Capture visual selection
  - Create new zettel with timestamp ID
  - Insert wikilink to new zettel in original file
  - Keybinding: `<leader>fzc` (find → zettelkasten → create)

- [ ] Configure Obsidian.nvim workspaces
  - Edit `lua/plugins/obsidian.lua`
  - Add Zettelkasten workspace configuration
  - Add Literature workspace configuration
  - Set notes_subdir for each workspace
  - Test `:ObsidianWorkspace` switching

**Success Criteria**:
- Can follow wikilinks across vaults
- Backlink search shows all references
- Can create new zettels from selection
- Obsidian.nvim workspaces configured
- Navigation is fast and intuitive

**Files Modified**:
- `lua/core/functions.lua` - Navigation functions
- `lua/plugins/obsidian.lua` - Workspace configuration
- `lua/plugins/which-key.lua` - Navigation keybindings

---

### Phase 4: Advanced Features & Refinement (1-2 hours)

**Objective**: Explore and implement additional helpful features.

**Tasks**:
- [ ] Implement tag search
  - Add `search_by_tags()` function
  - Use Telescope to search frontmatter tags
  - Show all notes with selected tag
  - Keybinding: `<leader>ft` (find → tags)

- [ ] Add recent notes search
  - Add `search_recent_notes()` function
  - Show notes sorted by modification time
  - Limit to last 20-30 notes
  - Keybinding: `<leader>fr` (find → recent)

- [ ] Implement full Second Brain search
  - Add `search_all_vaults()` function
  - Search across all SecondBrain directories
  - Exclude `.obsidian` folder
  - Keybinding: `<leader>fa` (find → all)

- [ ] Create note templates
  - Directory: `~/.config/nvim/templates/zettelkasten/`
  - Templates: `zettel.md`, `literature-note.md`, `project-note.md`
  - Add frontmatter fields: `id`, `aliases`, `tags`, `created`
  - Integrate with `create_zettel_from_selection()` function

- [ ] Add daily note integration (optional)
  - Use Obsidian.nvim daily notes feature
  - Configure daily note template
  - Keybinding: `<leader>fd` (find → daily note)

- [ ] Optimize search performance
  - Configure `file_ignore_patterns` in Telescope
  - Exclude `.obsidian`, `node_modules`, etc.
  - Test search speed with large vault

- [ ] Refine which-key menu organization
  - Review all search keybindings
  - Ensure logical grouping
  - Add helpful descriptions
  - Test menu UX

**Success Criteria**:
- Tag search works across vaults
- Recent notes shows correct order
- Full vault search excludes .obsidian
- Note templates available
- Search performance acceptable
- Which-key menu well-organized

**Files Created**:
- `~/.config/nvim/templates/zettelkasten/zettel.md`
- `~/.config/nvim/templates/zettelkasten/literature-note.md`
- `~/.config/nvim/templates/zettelkasten/project-note.md`

**Files Modified**:
- `lua/core/functions.lua` - Advanced search functions
- `lua/plugins/telescope.lua` - Performance optimization
- `lua/plugins/which-key.lua` - Menu refinement

---

### Phase 5: Testing & Documentation (1-2 hours)

**Objective**: Test all workflows end-to-end and document usage.

**Tasks**:
- [ ] Test all search commands
  - Zettelkasten file search
  - Zettelkasten content grep
  - Literature file search
  - Literature content grep
  - Tag search
  - Recent notes
  - Full vault search
  - Backlinks

- [ ] Test citation workflows
  - Insert zettelkasten link in markdown
  - Insert literature citation in markdown
  - Insert literature citation in LaTeX
  - Verify citation formats
  - Test citation key extraction

- [ ] Test navigation
  - Follow wikilinks in same vault
  - Follow wikilinks across vaults
  - Create new zettel from selection
  - Navigate via backlinks

- [ ] Test with different vault structures
  - Test with empty vaults
  - Test with nested directories
  - Test with various file types
  - Test with special characters in filenames

- [ ] Update documentation
  - Add "Zettelkasten Search" section to README
  - Document all search keybindings in CHEATSHEET
  - Create usage guide: `docs/zettelkasten-guide.md`
  - Document citation workflows
  - Add troubleshooting section

- [ ] Create which-key reference
  - Update `cheatsheet-readme/nvim-cheatsheet.md`
  - Add `<leader>fz` submenu documentation
  - Add `<leader>fl` submenu documentation
  - Include examples and workflows

**Success Criteria**:
- All search commands tested and working
- Citation workflows documented
- Navigation tested across vaults
- Edge cases handled gracefully
- Documentation accurate and complete
- User can follow guides successfully

**Files Modified**:
- `README.md` - Feature documentation
- `cheatsheet-readme/nvim-cheatsheet.md` - Keybinding reference

**Files Created**:
- `docs/zettelkasten-guide.md` - Usage guide

---

## Keybinding Structure

### Proposed Which-Key Menu

```
<leader>f - FIND
  f - Find project files
  g - Grep project content
  b - Buffers
  h - Help tags
  k - Keymaps
  r - Recent files
  s - Grep string under cursor
  t - Tags (new)
  a - All vaults (new)

  z - Zettelkasten submenu
    f - Find files
    g - Grep content
    i - Insert link
    c - Create zettel

  l - Literature submenu
    f - Find files
    g - Grep content
    i - Insert citation
```

**Alternative Compact Structure**:
```
<leader>f - FIND
  zf - Zettelkasten files
  zg - Zettelkasten grep
  zi - Zettelkasten insert
  zc - Zettelkasten create

  lf - Literature files
  lg - Literature grep
  li - Literature insert
```

**Decision**: Use submenu structure for better organization and discoverability.

## External Dependencies

### Required
- **Telescope.nvim** - Already installed
- **Obsidian.nvim** - Already installed, needs configuration
- **ripgrep** - For fast grep (likely already installed)

### Optional
- **fd** - Faster file finding (can fallback to find)
- **BibTeX parser** - If advanced citation features needed

## Risk Assessment

### Medium Risk
- **Obsidian.nvim dual-vault configuration**: May cause workspace conflicts
  - **Mitigation**: Test workspace switching thoroughly, document any limitations

- **Citation key extraction**: May fail for non-standard literature notes
  - **Mitigation**: Implement robust fallbacks, use filename if no citekey

- **Cross-vault navigation**: Wikilink resolution may be complex
  - **Mitigation**: Start simple with full paths, enhance gradually

### Low Risk
- **Telescope performance**: Should be fast enough for typical vaults
  - **Mitigation**: Add ignore patterns, test with large vaults

- **Keybinding conflicts**: New bindings may conflict with existing
  - **Mitigation**: Review existing bindings, use submenu structure

## Success Metrics

### Search Functionality
- ✓ All four vault searches return results in <500ms
- ✓ Preview shows correctly formatted markdown
- ✓ Search results sorted by relevance

### Citation Workflow
- ✓ Citation insertion takes <10 seconds
- ✓ 100% correct format for markdown and LaTeX
- ✓ Citation key extraction works for 90%+ of notes

### Navigation
- ✓ Wikilink following works across vaults
- ✓ Backlinks found in <2 seconds
- ✓ New zettel creation takes <5 seconds

### User Experience
- ✓ User can complete full workflow without documentation
- ✓ Which-key menu is intuitive and discoverable
- ✓ Error messages are helpful and actionable

## Open Questions

1. **Citation Key Format**:
   - Use frontmatter field `citekey:` or extract from filename?
   - **Recommendation**: Try frontmatter first, fallback to filename

2. **Note Templates**:
   - Store in nvim config or in vault itself?
   - **Recommendation**: Nvim config (easier to version control)

3. **Backlink Search**:
   - Should we cache backlinks for performance?
   - **Recommendation**: Start without caching, optimize if slow

4. **Daily Notes**:
   - Use Obsidian.nvim daily notes or custom implementation?
   - **Recommendation**: Use Obsidian.nvim if configured, optional feature

5. **Workspace Switching**:
   - Auto-detect workspace from file path or manual switching?
   - **Recommendation**: Auto-detect, with manual override

## Next Steps

**Immediate**:
1. Begin Phase 1: Implement four basic search functions
2. Test with real vault data
3. Gather user feedback on UX

**Future Considerations**:
- Graph view integration (if available via Obsidian.nvim)
- Fuzzy matching for citation keys
- Auto-completion for wikilinks in insert mode
- Integration with Lectic personas for note-taking

---

**Plan Status**: Ready for Implementation
**Next Session**: Phase 1 - Basic Search Functions
