# Implementation Plan: Neovim Second Brain Configuration

**Created**: 2025-11-09
**Last Updated**: 2025-11-11
**Status**: In Progress
**Complexity**: 8/10 (High)
**Estimated Duration**: 12-16 hours

## Current Progress

**Completed**:
- ✅ Session 1: Which-Key Cleanup (2025-11-09)
- ✅ Session 2: Dashboard Cleanup (2025-11-09)
- ✅ Phase 2: Lectic Single-Party Persona System (2025-11-11)

**In Progress**:
- Phase 1: Foundation - Markdown & Search (Deferred)
- Phase 3: Dashboard & Which-Key Refinement (Partially done via Sessions 1-2)
- Phase 4: Publishing Workflows (Not started)
- Phase 5: Citation & Cross-Vault Integration (Not started)
- Phase 6: Testing & Documentation (Not started)

**Next Steps**:
- Implement Phase 1 when search functionality needed
- Continue with Phase 4 (Publishing) or Phase 5 (Citations) as priorities dictate

## Executive Summary

This plan implements a complete second-brain and coding environment in Neovim, integrating Obsidian zettelkasten workflows, Lectic AI personas, LaTeX publishing, and Ghost theme development support. The project requires careful configuration of multiple plugins, custom search functions, menu reorganization, and publishing workflows.

## Project Assessment

### Current State Analysis

**What's Already Done**:
- Basic Lectic integration functional (`lua/plugins/lectic.lua`)
- Obsidian plugin installed but needs dual-vault configuration
- Dashboard configured with basic shortcuts
- Which-key menus partially structured
- Zen mode working correctly
- LaTeX templates available in `~/.config/nvim/templates/`
- Markdown rendering active (needs disabling/reconfiguring)
- Second Brain vault structure confirmed at `~/SecondBrain/`

**What Needs Work**:
- Disable auto-rendering of markdown (render-markdown.nvim)
- Configure Obsidian.nvim for zettelkasten + Literature vaults
- Create custom search functions for both vaults
- Implement Lectic persona system with templates
- Reorganize which-key menus (`<leader>m`, `<leader>f`, `<leader>p`)
- Build LaTeX publishing workflow with template selection
- Implement e-book and presentation export
- Create Ghost.org publishing workflow
- Add citation insertion functionality

### Complexity Factors

1. **Plugin Configuration** (3/10): Most plugins are standard, well-documented
2. **Custom Functions** (7/10): Search, citation, template selection require custom Lua
3. **Integration Complexity** (9/10): Coordinating Obsidian + Lectic + Publishing workflows
4. **Testing Requirements** (8/10): Multiple workflows must work end-to-end
5. **Menu Design** (6/10): Reorganizing which-key menus requires careful planning

**Overall Complexity**: 8/10 - This is a high-complexity project requiring careful integration of multiple systems.

## Technical Approach

### Plugin Strategy

**Keep Existing**:
- `obsidian.nvim` - Well-maintained, supports multiple workspaces
- `telescope.nvim` - Excellent for custom searchers
- `vimtex` - Industry standard for LaTeX
- Pandoc integration via `toggleterm.nvim`

**New/Enhanced**:
- Custom Lua functions for vault searching
- Lectic persona template system
- Publishing workflow commands
- Enhanced which-key menus

**Disable/Reconfigure**:
- `render-markdown.nvim` - Set `enabled = false` for syntax-only highlighting

### Menu Organization Rationale

**`<leader>m` - MARKDOWN & WRITING**:
- Primary hub for writing-focused activities
- Lectic persona submenu (`<leader>mp`) for quick switching
- Citation submenu (`<leader>mc`) for research integration
- Keep existing folding/completion toggles

**`<leader>f` - FIND (Enhanced)**:
- Add `<leader>fz` - Search zettelkasten
- Add `<leader>fl` - Search literature vault
- Keep existing project/file search functions
- Maintain consistency with Telescope patterns

**`<leader>p` - PUBLISHING**:
- Repurpose from PANDOC to comprehensive PUBLISHING menu
- LaTeX submenu (`<leader>pl`) for academic publishing
- E-book submenu (`<leader>pe`) for Kindle/Apple Books
- Slides submenu (`<leader>ps`) for presentations
- Ghost submenu (`<leader>pg`) for blog publishing
- Keep essential Pandoc conversions at top level

### Search Implementation Approach

**Telescope-based Solution**:
1. Use `telescope.builtin.find_files` with `search_dirs` parameter
2. Create wrapper functions for zettelkasten and Literature vault
3. Add custom preview configuration for markdown files
4. Enable fuzzy matching on file names and content

**Why Not Obsidian.nvim Search**:
- Telescope provides more flexibility and consistency
- User already familiar with Telescope patterns
- Easier to customize preview and selection behavior

### Template System Design

**Lectic Persona Templates**:
- Store in `~/.config/nvim/templates/lectic/`
- Create one template per persona (writer, editor, researcher, business-coach)
- Include full frontmatter with `interlocutor`, `memories` paths
- Function to insert template and prompt for save location

**LaTeX Template Selection**:
- Use existing templates in `~/.config/nvim/templates/`
- Create selection menu via `vim.ui.select`
- Copy template content to new buffer with LaTeX filetype
- Categories: Articles, Books, Presentations, Letters

## Implementation Phases

### Phase 1: Foundation - Markdown & Search

**Objective**: Fix markdown rendering and implement vault search functionality.

**Status**: ⏸️ DEFERRED - Not yet started

**Tasks**:
- [ ] Disable markdown auto-rendering
  - Edit `lua/plugins/render-markdown.lua`
  - Set `enabled = false` or add conditional based on filetype
  - Test that markdown shows syntax highlighting only
  - Verify zen mode still works correctly

- [ ] Configure Obsidian.nvim for dual vaults
  - Edit `lua/plugins/obsidian.lua`
  - Add Literature vault to `workspaces` configuration
  - Configure `notes_subdir` and `templates` for each workspace
  - Test workspace switching with `:ObsidianWorkspace`

- [ ] Create zettelkasten search function
  - Add `search_zettelkasten()` to `lua/core/functions.lua`
  - Use `telescope.find_files` with `search_dirs = {"~/SecondBrain/3-Zettelkasten/"}`
  - Configure markdown preview in results
  - Add keymap `<leader>fz` in `lua/plugins/which-key.lua`

- [ ] Create literature vault search function
  - Add `search_literature()` to `lua/core/functions.lua`
  - Use `telescope.find_files` with `search_dirs = {"~/SecondBrain/Literature/"}`
  - Configure markdown preview in results
  - Add keymap `<leader>fl` in `lua/plugins/which-key.lua`

- [ ] Create project search function (all SecondBrain)
  - Add `search_second_brain()` to `lua/core/functions.lua`
  - Search all of `~/SecondBrain/` excluding `.obsidian`
  - Add keymap `<leader>fs` in which-key

**Success Criteria**:
- Markdown files show syntax coloring, not rendered elements
- Can search zettelkasten notes with preview
- Can search literature vault with preview
- Can search entire Second Brain
- All searches return results in Telescope picker

**Files Modified**:
- `lua/plugins/render-markdown.lua`
- `lua/plugins/obsidian.lua`
- `lua/core/functions.lua`
- `lua/plugins/which-key.lua`

**Note**: Phase 2 (Lectic) was completed first due to priority. Phase 1 can be implemented when search functionality becomes needed.

---

### Phase 2: Lectic Single-Party Persona System (COMPLETED)

**Objective**: Create switchable AI personas with single-party mode and context file loading.

**Status**: ✅ COMPLETED - Session 4 (2025-11-11)

**Implementation**:
- ✅ Created 12 personas in `lua/plugins/lectic.lua`
  - Business: Consultant, Marketing, Finance, Product
  - Writing: Researcher, Writer, Editor
  - Workshop: Designer, Scholar, Scribe
  - General: Homie, Nomad

- ✅ Implemented `InsertContextLink()` function
  - Inserts `[Context](/Users/nathanheintz/SecondBrain/)`
  - Positions cursor for path completion
  - Bound to `<leader>mc`

- ✅ Implemented `SwitchLecticPersona(persona_name)` function
  - Switches persona in current file
  - Preserves Obsidian frontmatter (`id`, `aliases`, `tags`)
  - Updates only `interlocutor.name` and `interlocutor.prompt`

- ✅ Modified `CreateNewLecticFile()` function
  - Always creates with Homie persona
  - Generates Obsidian-compatible frontmatter
  - Single-party format: `interlocutor:` (singular)

- ✅ Commented out multi-party code
  - Multi-party broken in Lectic beta6
  - `:ask[Name]` produces undefined errors
  - Code preserved for future when bug fixed

- ✅ Updated which-key persona menu
  - Created `<leader>mp` submenu with 12 personas
  - Added `<leader>mc` for context link insertion
  - Updated `<leader>mn` for file creation

**Success Criteria Met**:
- ✅ 12 personas available via which-key
- ✅ Persona switching preserves frontmatter
- ✅ Context file loading works via markdown links
- ✅ Files save with `.md` extension
- ✅ Lectic command processes files correctly
- ✅ Frontmatter compatible with Obsidian

**Files Modified**:
- `lua/plugins/lectic.lua` - Added persona system
- `lua/plugins/which-key.lua` - Added keybindings
- `cheatsheet-readme/lectic-cheatsheet.md` - Complete rewrite
- `README.md` - Updated quick reference

**Git Commits**:
- 065c7c6 - feat: implement single-party Lectic persona system
- 1d36eeb - chore: update configuration and documentation

---

### Phase 3: Dashboard & Which-Key Refinement (2-3 hours)

**Objective**: Redesign dashboard and reorganize which-key menus for new workflows.

**Tasks**:
- [ ] Update dashboard shortcuts
  - Edit `lua/plugins/snacks/dashboard.lua`
  - Add shortcut `z` - "Search Zettelkasten"
  - Add shortcut `l` - "New Lectic file with persona selection"
  - Update `f` - "Find" to show submenu preview
  - Add `p` - "Publishing" menu preview
  - Keep existing shortcuts: recent, config, git

- [ ] Reorganize `<leader>m` menu
  - Edit `lua/plugins/which-key.lua`
  - Group Lectic commands under `<leader>mp` (personas)
  - Create `<leader>mc` submenu for citations
  - Add `<leader>mcz` - "Search zettelkasten for citation"
  - Add `<leader>mcl` - "Search literature for citation"
  - Add `<leader>mci` - "Insert citation at cursor"
  - Keep existing: zen, folding, completion toggles

- [ ] Create comprehensive `<leader>p` publishing menu
  - Rename from "PANDOC" to "PUBLISHING"
  - Create `<leader>pl` LaTeX submenu:
    - `<leader>pla` - Article template
    - `<leader>plb` - Book template
    - `<leader>plp` - Presentation template
    - `<leader>pll` - Letter template
    - `<leader>plc` - Compile current LaTeX
    - `<leader>plv` - View PDF
  - Create `<leader>pe` E-book submenu:
    - `<leader>pek` - Export to Kindle (MOBI)
    - `<leader>pea` - Export to Apple Books (EPUB)
    - `<leader>pep` - Preview EPUB
  - Create `<leader>ps` Slides/Presentations submenu:
    - `<leader>psm` - Export to Marp
    - `<leader>psr` - Export to Reveal.js
    - `<leader>psp` - Preview slides
  - Create `<leader>pg` Ghost Publishing submenu:
    - `<leader>pgo` - Optimize markdown for Ghost
    - `<leader>pgu` - Copy to clipboard for Ghost
  - Keep at top level:
    - `<leader>pw` - Convert to Word
    - `<leader>ph` - Convert to HTML
    - `<leader>pm` - Convert to Markdown

- [ ] Enhance `<leader>f` find menu
  - Add `<leader>fz` - Search zettelkasten (already added in Phase 1)
  - Add `<leader>fl` - Search literature vault (already added in Phase 1)
  - Add `<leader>fs` - Search Second Brain (already added in Phase 1)
  - Keep existing project/buffer/grep functions

- [ ] Review and remove unused keymaps
  - Check `<leader>a` for unused actions
  - Remove deprecated keymaps (hardtime, mcp-hub already commented)
  - Keep essential: format, word count, vimtex actions
  - Document any removals

**Success Criteria**:
- Dashboard shows new shortcuts for zettelkasten and Lectic
- `<leader>m` menu organized with submenu structure
- `<leader>p` menu comprehensive with LaTeX, e-book, slides, Ghost
- `<leader>f` menu includes vault searches
- No broken/undefined keymaps
- Which-key displays clean, organized menus

**Files Modified**:
- `lua/plugins/snacks/dashboard.lua`
- `lua/plugins/which-key.lua`

---

### Phase 4: Publishing Workflows (4-5 hours)

**Objective**: Implement LaTeX, e-book, presentation, and Ghost publishing workflows.

**Tasks**:
- [ ] Implement LaTeX template selection
  - Add `select_latex_template()` to `lua/core/functions.lua`
  - Use `vim.ui.select` to present template options
  - Categories: Articles (PhilPaper, HandOut), Books (Root, SubFile), Presentations (PhilBeamer), Letters
  - Copy selected template to new buffer
  - Set filetype to `tex`
  - Prompt for save location

- [ ] Implement LaTeX conversion from markdown
  - Add `convert_md_to_latex()` to `lua/core/functions.lua`
  - Use Pandoc: `pandoc %:p -o %:p:r.tex`
  - Open resulting `.tex` file in new buffer
  - Allow template selection post-conversion

- [ ] Implement e-book export (EPUB)
  - Add `export_to_epub()` to `lua/core/functions.lua`
  - Use Pandoc: `pandoc %:p -o %:p:r.epub --toc`
  - Add metadata flags: `--metadata title="..."` prompt
  - Notify on completion with file path

- [ ] Implement e-book export (MOBI for Kindle)
  - Add `export_to_mobi()` to `lua/core/functions.lua`
  - Two-step: Pandoc to EPUB, then use Calibre ebook-convert
  - Command: `ebook-convert %:p:r.epub %:p:r.mobi`
  - Check if Calibre installed, notify if missing
  - Notify on completion

- [ ] Implement EPUB preview
  - Add `preview_epub()` to `lua/core/functions.lua`
  - Platform detection (macOS/Linux/Windows)
  - macOS: Use `open` command
  - Linux: Use `xdg-open` or `calibre`
  - Notify which app is being used

- [ ] Implement Marp presentation export
  - Add `export_to_marp()` to `lua/core/functions.lua`
  - Check if Marp CLI installed (`marp --version`)
  - Command: `marp %:p --html -o %:p:r.html`
  - Option for PDF: `marp %:p --pdf -o %:p:r.pdf`
  - Open resulting file in browser

- [ ] Implement Reveal.js export
  - Add `export_to_revealjs()` to `lua/core/functions.lua`
  - Use Pandoc: `pandoc %:p -t revealjs -s -o %:p:r-slides.html`
  - Add theme selection via `vim.ui.select`
  - Open in browser

- [ ] Implement Ghost markdown optimization
  - Add `optimize_for_ghost()` to `lua/core/functions.lua`
  - Format checks: Remove unsupported frontmatter
  - Convert wikilinks `[[link]]` to standard markdown
  - Ensure images use proper markdown syntax
  - Option to copy to clipboard or save as new file

- [ ] Create publishing commands
  - Add user commands for each publishing workflow
  - `:ExportEPUB`, `:ExportMOBI`, `:ExportMarp`, etc.
  - Document in which-key descriptions

**Success Criteria**:
- Can select and insert LaTeX templates
- Can convert markdown to LaTeX via Pandoc
- Can export markdown to EPUB and MOBI
- Can preview EPUB files in system reader
- Can export to Marp HTML/PDF
- Can export to Reveal.js HTML
- Can optimize markdown for Ghost
- All exports handle errors gracefully (missing tools)
- User receives clear notifications on success/failure

**Files Modified**:
- `lua/core/functions.lua`
- `lua/plugins/which-key.lua` (connect functions to keymaps)

**External Dependencies** (user must install):
- Pandoc (likely already installed)
- Calibre (for MOBI conversion)
- Marp CLI (optional, for presentation export)

---

### Phase 5: Citation & Cross-Vault Integration (2-3 hours)

**Objective**: Enable citation insertion from Literature vault and cross-vault linking.

**Tasks**:
- [ ] Implement citation search and insertion
  - Add `search_and_insert_citation()` to `lua/core/functions.lua`
  - Search Literature vault with Telescope
  - Show file preview in picker
  - On selection, extract title and create citation
  - Citation format: `[[Literature/filename|title]]` (Obsidian wikilink)
  - Alternative: Pandoc citation format `[@citationkey]` if BibTeX detected

- [ ] Add citation format selection
  - Detect file type: markdown vs LaTeX
  - For markdown: Use wikilink format
  - For LaTeX: Prompt for citation style (\citet, \citep, \cite)
  - Store user preference in vim.g variable

- [ ] Implement zettelkasten reference insertion
  - Add `search_and_insert_zettel_link()` to `lua/core/functions.lua`
  - Search zettelkasten notes with Telescope
  - On selection, insert wikilink: `[[3-Zettelkasten/notename]]`
  - Support both full path and short name formats

- [ ] Enhance Obsidian completion in markdown
  - Verify `obsidian.nvim` completion works in blink.cmp
  - Test wikilink completion (type `[[` to trigger)
  - Ensure completion includes both vaults
  - Update blink.cmp sources if needed

- [ ] Create cross-vault navigation helpers
  - Add function to follow wikilinks across vaults
  - Use `gf` or custom keymap to jump to linked note
  - Handle relative and absolute vault paths

**Success Criteria**:
- Can search Literature vault and insert citations
- Citations formatted correctly for markdown and LaTeX
- Can search zettelkasten and insert wikilinks
- Wikilink completion works in markdown files
- Can navigate between notes across vaults
- Citation workflow feels natural and fast

**Files Modified**:
- `lua/core/functions.lua`
- `lua/plugins/which-key.lua`
- `lua/plugins/obsidian.lua` (if completion needs adjustment)
- `lua/plugins/lsp/blink-cmp.lua` (if sources need adjustment)

---

### Phase 6: Testing & Documentation (2-3 hours)

**Objective**: Test all workflows end-to-end and update documentation.

**Tasks**:
- [ ] Test markdown rendering settings
  - Open markdown file, verify syntax highlighting only
  - Enter zen mode, verify no rendering
  - Exit zen mode, verify settings restored
  - Test with both `.md` and `.lec` files

- [ ] Test search workflows
  - Search zettelkasten, verify results and preview
  - Search literature vault, verify results and preview
  - Search entire Second Brain, verify filtering
  - Test from dashboard shortcuts
  - Test from which-key menu

- [ ] Test Lectic persona system
  - Load each persona template via which-key
  - Verify frontmatter is correct
  - Save to different locations
  - Run `:Lectic` on saved persona file
  - Test visual selection submission
  - Verify persona-specific prompts work

- [ ] Test LaTeX publishing workflow
  - Select LaTeX template via menu
  - Insert template into new buffer
  - Convert markdown to LaTeX
  - Compile LaTeX document (if VimTeX configured)
  - View PDF output

- [ ] Test e-book publishing workflow
  - Export markdown to EPUB
  - Verify EPUB metadata
  - Preview EPUB in system reader
  - Export EPUB to MOBI (if Calibre installed)
  - Verify MOBI file created

- [ ] Test presentation export
  - Export to Marp HTML (if Marp installed)
  - Export to Reveal.js HTML
  - Open presentations in browser
  - Verify slides render correctly

- [ ] Test Ghost publishing workflow
  - Optimize markdown for Ghost
  - Verify wikilinks converted
  - Verify frontmatter cleaned
  - Copy to clipboard
  - Paste into Ghost editor (manual test)

- [ ] Test citation workflows
  - Search Literature and insert citation
  - Verify citation format (markdown)
  - Search Literature and insert citation in LaTeX file
  - Verify citation format (LaTeX)
  - Search zettelkasten and insert wikilink
  - Navigate via wikilink (gf or custom keymap)

- [ ] Update README.md
  - Add "Second Brain Integration" section
  - Document zettelkasten and Literature vault search
  - Document Lectic persona system
  - Document publishing workflows (LaTeX, e-book, presentations, Ghost)
  - Document citation insertion
  - Update feature list

- [ ] Update CHEATSHEET.md
  - Add `<leader>m` menu with persona submenu
  - Add `<leader>f` menu with vault searches
  - Add `<leader>p` publishing menu (all submenus)
  - Add `<leader>mc` citation submenu
  - Document special workflows:
    - "Using Lectic Personas"
    - "Publishing to Ghost"
    - "Exporting to E-books"
    - "Creating Presentations"
  - Add external dependencies section

- [ ] Create user guide for complex workflows
  - File: `~/.config/nvim/docs/second-brain-guide.md`
  - Section: "Setting Up Your Second Brain"
  - Section: "Working with Lectic Personas"
  - Section: "Publishing Workflows"
  - Section: "Citation Management"
  - Section: "Troubleshooting"

- [ ] Test error handling
  - Try publishing without Pandoc (should show helpful error)
  - Try MOBI export without Calibre (should notify)
  - Try Marp export without Marp CLI (should notify)
  - Try searching with empty vaults (should handle gracefully)

**Success Criteria**:
- All workflows tested end-to-end with real files
- No errors in `:messages` or `:checkhealth`
- README reflects current state accurately
- CHEATSHEET shows all keybindings correctly
- User guide covers complex workflows
- Error messages are helpful and actionable
- External dependencies documented clearly

**Files Modified**:
- `README.md`
- `CHEATSHEET.md`

**Files Created**:
- `~/.config/nvim/docs/second-brain-guide.md`

---

## External Dependencies

### Required
- **Pandoc** - For format conversions (LaTeX, EPUB, HTML, etc.)
  - Install: `brew install pandoc` (macOS)
  - Verify: `pandoc --version`

### Optional
- **Calibre** - For MOBI (Kindle) conversion
  - Install: `brew install --cask calibre` (macOS)
  - Verify: `ebook-convert --version`

- **Marp CLI** - For presentation export
  - Install: `npm install -g @marp-team/marp-cli`
  - Verify: `marp --version`

- **Zathura** - PDF viewer (already configured for VimTeX)

### Not Required
- Ghost.org publishing will use clipboard copy (no API integration)
- Reveal.js export uses Pandoc (no separate install)
- EPUB preview uses system default apps

## Risk Assessment

### High Risk
- **Citation workflow complexity**: Multiple formats (wikilink vs BibTeX) may confuse users
  - **Mitigation**: Default to wikilinks in markdown, prompt for format in LaTeX

- **External tool dependencies**: Missing tools (Calibre, Marp) will break workflows
  - **Mitigation**: Check for tool availability, show helpful install instructions

### Medium Risk
- **Obsidian.nvim dual-vault configuration**: May cause plugin conflicts
  - **Mitigation**: Test workspace switching thoroughly, use manual loading

- **Template frontmatter compatibility**: Lectic and Obsidian may conflict
  - **Mitigation**: Use shared frontmatter fields, avoid gaps/comments

### Low Risk
- **Which-key menu reorganization**: Risk of breaking existing muscle memory
  - **Mitigation**: Keep most-used keymaps unchanged, document changes

- **Dashboard changes**: Minimal risk
  - **Mitigation**: Keep essential shortcuts, add new ones

## Open Questions & Decisions Needed

1. **Citation Format Preference**:
   - Default to Obsidian wikilinks or Pandoc citations?
   - **Recommendation**: Wikilinks for markdown, BibTeX for LaTeX (auto-detect)

2. **Template Storage**:
   - Store Lectic templates in `~/.config/nvim/templates/lectic/` or `~/SecondBrain/`?
   - **Recommendation**: Neovim config (easier to track in git)

3. **Search Preview Style**:
   - Show full file preview or just metadata?
   - **Recommendation**: Full preview (more useful for research)

4. **Ghost Publishing Method**:
   - Custom plugin, API integration, or simple clipboard copy?
   - **Recommendation**: Clipboard copy (simple, no auth complexity)

5. **E-book Metadata**:
   - Prompt for title/author every export or read from frontmatter?
   - **Recommendation**: Try frontmatter first, prompt as fallback

6. **Presentation Default**:
   - Prefer Marp or Reveal.js for presentations?
   - **Recommendation**: Offer both, Marp for simpler setup

## Success Metrics

### Phase 1 Success
- ✓ Markdown rendering disabled
- ✓ Zettelkasten search returns >10 results
- ✓ Literature search returns >5 results

### Phase 2 Success
- ✓ All 4 persona templates created
- ✓ Persona loading takes <5 seconds
- ✓ Frontmatter compatible with Obsidian

### Phase 3 Success
- ✓ Dashboard loads in <1 second
- ✓ Which-key menus show <300ms delay
- ✓ No broken keymaps in `:checkhealth`

### Phase 4 Success
- ✓ LaTeX template selection works
- ✓ EPUB export completes in <5 seconds
- ✓ Presentation export works (if tools installed)

### Phase 5 Success
- ✓ Citation insertion takes <10 seconds
- ✓ Wikilink navigation works across vaults

### Phase 6 Success
- ✓ All workflows tested with real content
- ✓ Documentation updated and accurate
- ✓ Zero errors in `:checkhealth`

## Estimated Timeline

| Phase | Description | Duration | Cumulative |
|-------|-------------|----------|------------|
| 1 | Foundation - Markdown & Search | 3-4 hours | 3-4 hours |
| 2 | Lectic Persona System | 3-4 hours | 6-8 hours |
| 3 | Dashboard & Which-Key | 2-3 hours | 8-11 hours |
| 4 | Publishing Workflows | 4-5 hours | 12-16 hours |
| 5 | Citation Integration | 2-3 hours | 14-19 hours |
| 6 | Testing & Documentation | 2-3 hours | 16-22 hours |

**Total Estimated Duration**: 16-22 hours (assume 2-3 sessions)

## Notes for Implementation

### Simplicity Principles
- User is not a neovim expert - keep solutions simple
- Prefer built-in vim functions over complex plugins
- Document all decisions (previous work was lost)
- Use clear, descriptive function names

### Testing Strategy
- Test each function immediately after writing
- Use `:messages` to check for errors
- Verify lazy loading doesn't break functionality
- Test both empty and populated vaults

### Documentation Style
- Follow `.claude/NVIM_STANDARDS.md`
- Present tense, no temporal markers
- No emojis in documentation
- Clear, concise descriptions

### Git Strategy
- Commit after each phase completion
- Include `🤖 Generated with [Claude Code](https://claude.com/claude-code)` in commit messages
- Tag commits with phase numbers

## References

### Configuration Files
- **Main config**: `~/.config/nvim` (branch: `nvim-custom`)
- **Which-key**: `lua/plugins/which-key.lua`
- **Dashboard**: `lua/plugins/snacks/dashboard.lua`
- **Lectic**: `lua/plugins/lectic.lua`
- **Obsidian**: `lua/plugins/obsidian.lua`
- **Functions**: `lua/core/functions.lua`

### Second Brain Structure
- **Root**: `~/SecondBrain/`
- **Zettelkasten**: `~/SecondBrain/3-Zettelkasten/`
- **Literature**: `~/SecondBrain/Literature/`
- **Projects**: `~/SecondBrain/1-Projects/`
- **Areas**: `~/SecondBrain/2-Areas/`
- **Resources**: `~/SecondBrain/4-Resources/`
- **Archive**: `~/SecondBrain/5-Archive/`

### LaTeX Templates
- **Location**: `~/.config/nvim/templates/`
- **Articles**: PhilPaper.tex, HandOut.tex, NiceArticle.tex
- **Books**: Root.tex, SubFile.tex
- **Presentations**: PhilBeamer.tex
- **Letters**: Letter.tex
- **Other**: Glossary.tex, MultipleAnswer.tex

### Plugin Documentation
- **Obsidian.nvim**: https://github.com/epwalsh/obsidian.nvim
- **Telescope.nvim**: https://github.com/nvim-telescope/telescope.nvim
- **Lectic**: https://github.com/gleachkr/Lectic
- **VimTeX**: https://github.com/lervag/vimtex
- **Pandoc**: https://pandoc.org/

### Publishing Tools
- **Marp**: https://marp.app/
- **Reveal.js**: https://revealjs.com/
- **Calibre**: https://calibre-ebook.com/
- **Ghost**: https://ghost.org/help/using-markdown/

---

## Appendix: Decision Log

### Why Disable render-markdown.nvim?
**Decision**: Set `enabled = false`
**Rationale**: User wants syntax highlighting only, not visual rendering
**Alternative Considered**: Configure to only render in certain modes
**Chosen Because**: Simpler, clearer user preference

### Why Telescope over Obsidian.nvim for Search?
**Decision**: Use Telescope for vault searches
**Rationale**: Consistency with existing workflow, more customizable
**Alternative Considered**: Use `:ObsidianSearch` command
**Chosen Because**: User already comfortable with Telescope

### Why Manual Obsidian Loading?
**Decision**: Keep `lazy = true`, load via `:Lazy load obsidian`
**Rationale**: Avoid conflicts with other markdown plugins
**Alternative Considered**: Auto-load on markdown filetype
**Chosen Because**: Better control, prevents startup issues

### Why Clipboard for Ghost Publishing?
**Decision**: Optimize and copy to clipboard, not API integration
**Rationale**: Simpler, no authentication, no API dependencies
**Alternative Considered**: Build Ghost API integration
**Chosen Because**: User workflow is already manual, keep it simple

### Why Pandoc for E-books?
**Decision**: Use Pandoc for EPUB, Calibre for MOBI
**Rationale**: Industry standard, well-documented, already installed
**Alternative Considered**: Use pure Lua solutions
**Chosen Because**: Pandoc is mature, handles metadata well

### Why Both Marp and Reveal.js?
**Decision**: Support both presentation formats
**Rationale**: Different use cases (Marp = simple, Reveal.js = advanced)
**Alternative Considered**: Choose one only
**Chosen Because**: Flexibility for user needs, minimal overhead

---

**Plan Status**: Ready for Implementation
**Next Step**: Begin Phase 1 - Foundation - Markdown & Search
