# Implementation Plan: Publishing Workflows

**Created**: 2025-11-11
**Status**: Not Started
**Complexity**: 7/10 (High)
**Estimated Duration**: 6-8 hours

## Executive Summary

This plan implements comprehensive publishing workflows from Neovim to multiple output formats: LaTeX/PDF (academic), EPUB/MOBI (e-books), HTML presentations (Marp/Reveal.js), and Ghost.org (blogging). The system includes template selection, format conversion, preview, and platform-specific optimization.

## Project Goals

### Primary Objectives
1. **LaTeX Publishing**: Academic papers, books, presentations
2. **E-Book Publishing**: EPUB and MOBI export with metadata
3. **Presentation Export**: Marp and Reveal.js slides
4. **Ghost Publishing**: Blog-ready markdown optimization

### Secondary Objectives
- Quick format conversions (MD → Word, HTML, etc.)
- Template system for common document types
- Preview workflows for each output format
- Platform-specific optimization tools

## Current State

**What Works**:
- VimTeX installed for LaTeX editing
- Pandoc likely available for conversions
- LaTeX templates exist in `~/.config/nvim/templates/`
- Basic Pandoc conversions in which-key menu

**What's Missing**:
- Organized publishing menu structure
- E-book export with metadata
- Presentation export workflows
- Ghost markdown optimization
- Template selection system
- Preview functions

## Publishing Workflows

### Workflow 1: Academic Publishing (LaTeX → PDF)

**Use Case**: Research papers, academic articles, dissertations

**Steps**:
1. Start with markdown or select LaTeX template
2. Convert markdown → LaTeX (if needed)
3. Edit in LaTeX with VimTeX features
4. Compile to PDF
5. View PDF in viewer

**Required Tools**:
- VimTeX (installed)
- Pandoc (for MD → LaTeX conversion)
- LaTeX distribution (texlive/mactex)
- PDF viewer (zathura configured)

### Workflow 2: E-Book Publishing (MD → EPUB/MOBI)

**Use Case**: Self-publishing, e-book distribution

**Steps**:
1. Write in markdown
2. Add metadata (title, author, cover)
3. Export to EPUB via Pandoc
4. Preview EPUB
5. Convert EPUB → MOBI (for Kindle)

**Required Tools**:
- Pandoc (for EPUB export)
- Calibre (for MOBI conversion)
- EPUB reader (Books.app on macOS)

### Workflow 3: Presentation Creation (MD → Slides)

**Use Case**: Conference talks, lectures, workshops

**Steps**:
1. Write presentation in markdown with separator syntax
2. Choose format (Marp or Reveal.js)
3. Export to HTML/PDF
4. Preview in browser
5. Present or distribute

**Required Tools**:
- Pandoc (for Reveal.js)
- Marp CLI (for Marp slides)
- Web browser

### Workflow 4: Blog Publishing (MD → Ghost)

**Use Case**: Blog posts on Ghost.org platform

**Steps**:
1. Write in markdown with Obsidian features
2. Optimize for Ghost (convert wikilinks, clean frontmatter)
3. Copy to clipboard
4. Paste into Ghost editor
5. Publish

**Required Tools**:
- None (pure transformation)

## Implementation Phases

### Phase 1: Menu Structure & Quick Conversions (1-2 hours)

**Objective**: Reorganize publishing menu and add quick conversion functions.

**Tasks**:
- [ ] Redesign `<leader>p` publishing menu
  - Rename from "PANDOC" to "PUBLISHING"
  - Create logical submenu structure
  - Group by output type (LaTeX, E-book, Presentations, Ghost)

- [ ] Implement quick Pandoc conversions
  - Add `convert_to_word()` - `<leader>pw`
  - Add `convert_to_html()` - `<leader>ph`
  - Add `convert_to_markdown()` - `<leader>pm`
  - Use Pandoc with sensible defaults
  - Show notification on completion

- [ ] Move existing VimTeX commands
  - Move compile from `<leader>pc` (if exists)
  - Move view from `<leader>pv` (if exists)
  - Organize under LaTeX submenu

- [ ] Update which-key menu
  - Edit `lua/plugins/which-key.lua`
  - Add publishing menu structure
  - Add descriptions for each command

**Success Criteria**:
- Publishing menu well-organized
- Quick conversions work (Word, HTML, Markdown)
- VimTeX commands accessible
- Which-key shows clear menu structure

**Files Modified**:
- `lua/plugins/which-key.lua`
- `lua/core/functions.lua` (if needed for conversion functions)

---

### Phase 2: LaTeX Publishing Workflow (2-3 hours)

**Objective**: Implement LaTeX template selection and MD → LaTeX conversion.

**Tasks**:
- [ ] Create LaTeX template selection function
  - Add `select_latex_template()` to `lua/core/functions.lua`
  - Use `vim.ui.select` with template categories
  - Categories: Articles, Letters, Presentations
  - Templates: PhilPaper, HandOut, Letter, PhilBeamer
  - Copy template to new buffer, set filetype `tex`

- [ ] Implement markdown to LaTeX conversion
  - Add `convert_markdown_to_latex()` function
  - Use Pandoc: `pandoc %:p -o %:p:r.tex`
  - Add options for LaTeX engine (pdflatex, xelatex, lualatex)
  - Open resulting .tex file

- [ ] Add LaTeX compilation shortcuts
  - Verify VimTeX compile works: `:VimtexCompile`
  - Add `<leader>plc` - Compile current LaTeX
  - Add `<leader>plv` - View PDF
  - Add `<leader>plk` - Clean aux files

- [ ] Create LaTeX submenu in which-key
  - `<leader>pl` - LaTeX submenu
  - `<leader>pla` - Article template
  - `<leader>pll` - Letter template
  - `<leader>plp` - Presentation template
  - `<leader>plm` - Convert MD → LaTeX
  - `<leader>plc` - Compile
  - `<leader>plv` - View PDF
  - `<leader>plk` - Clean aux

**Success Criteria**:
- Can select and insert LaTeX templates
- MD → LaTeX conversion works
- VimTeX compilation works from menu
- PDF viewer opens correctly
- LaTeX submenu organized and functional

**Files Modified**:
- `lua/core/functions.lua` - Template selection
- `lua/plugins/which-key.lua` - LaTeX submenu

---

### Phase 3: E-Book Publishing Workflow (2-3 hours)

**Objective**: Implement EPUB/MOBI export with metadata.

**Tasks**:
- [ ] Create metadata extraction function
  - Add `extract_metadata()` to `lua/core/functions.lua`
  - Read frontmatter for: title, author, date, description
  - Fallback to prompts if missing
  - Return metadata table

- [ ] Implement EPUB export
  - Add `export_to_epub()` function
  - Call `extract_metadata()` for book info
  - Build Pandoc command with metadata flags:
    - `--metadata title="..."`
    - `--metadata author="..."`
    - `--toc` for table of contents
  - Command: `pandoc %:p -o %:p:r.epub --toc --metadata ...`
  - Notify on completion with file path

- [ ] Implement MOBI export
  - Add `export_to_mobi()` function
  - Check if Calibre installed: `which ebook-convert`
  - If missing, show install instructions
  - First export to EPUB
  - Then convert: `ebook-convert %:p:r.epub %:p:r.mobi`
  - Notify on completion

- [ ] Add EPUB preview function
  - Add `preview_epub()` function
  - Platform detection (macOS/Linux/Windows)
  - macOS: `open %:p:r.epub` (uses Books.app)
  - Linux: `xdg-open %:p:r.epub`
  - Notify which app opening

- [ ] Create e-book submenu
  - `<leader>pe` - E-book submenu
  - `<leader>pee` - Export to EPUB
  - `<leader>pem` - Export to MOBI (Kindle)
  - `<leader>pep` - Preview EPUB
  - `<leader>pei` - Edit metadata interactively

**Success Criteria**:
- EPUB export works with metadata
- MOBI conversion works (if Calibre installed)
- Metadata extracted from frontmatter
- EPUB preview opens in system reader
- Helpful error if tools missing

**Files Modified**:
- `lua/core/functions.lua` - E-book functions
- `lua/plugins/which-key.lua` - E-book submenu

**External Dependencies**:
- Pandoc (required)
- Calibre (optional, for MOBI)

---

### Phase 4: Presentation Publishing Workflow (1-2 hours)

**Objective**: Implement Marp and Reveal.js presentation export.

**Tasks**:
- [ ] Implement Marp export
  - Add `export_to_marp_html()` function
  - Check if Marp CLI installed: `which marp`
  - If missing, show install instructions: `npm install -g @marp-team/marp-cli`
  - Command: `marp %:p --html -o %:p:r.html`
  - Open in browser

- [ ] Add Marp PDF export
  - Add `export_to_marp_pdf()` function
  - Command: `marp %:p --pdf -o %:p:r.pdf`
  - Open PDF in viewer

- [ ] Implement Reveal.js export
  - Add `export_to_revealjs()` function
  - Use Pandoc: `pandoc %:p -t revealjs -s -o %:p:r-slides.html`
  - Add theme selection via `vim.ui.select`:
    - Themes: black, white, league, beige, sky, night, serif, simple, solarized
  - Add theme to command: `--variable theme=THEME`
  - Open in browser

- [ ] Create presentations submenu
  - `<leader>ps` - Presentations submenu
  - `<leader>psh` - Marp HTML
  - `<leader>psp` - Marp PDF
  - `<leader>psr` - Reveal.js
  - `<leader>psv` - Preview slides

**Success Criteria**:
- Marp export works (if installed)
- Reveal.js export works via Pandoc
- Theme selection works for Reveal.js
- Presentations open in browser
- Helpful error if Marp not installed

**Files Modified**:
- `lua/core/functions.lua` - Presentation functions
- `lua/plugins/which-key.lua` - Presentations submenu

**External Dependencies**:
- Marp CLI (optional)
- Pandoc (required for Reveal.js)

---

### Phase 5: Ghost Publishing Workflow (1 hour)

**Objective**: Optimize markdown for Ghost.org and copy to clipboard.

**Tasks**:
- [ ] Create Ghost optimization function
  - Add `optimize_for_ghost()` to `lua/core/functions.lua`
  - Remove Obsidian-specific frontmatter
  - Convert wikilinks to standard markdown:
    - `[[note]]` → `[note](link)`
    - `[[note|display]]` → `[display](link)`
  - Ensure image syntax correct
  - Save as new file or overwrite

- [ ] Add clipboard copy function
  - Add `copy_to_clipboard_for_ghost()` function
  - Run optimization first
  - Copy optimized markdown to system clipboard
  - Platform-specific clipboard commands:
    - macOS: `pbcopy`
    - Linux: `xclip -selection clipboard`
  - Notify "Copied to clipboard for Ghost"

- [ ] Create Ghost submenu
  - `<leader>pg` - Ghost submenu
  - `<leader>pgo` - Optimize for Ghost
  - `<leader>pgc` - Copy to clipboard
  - `<leader>pgt` - Test Ghost compatibility

**Success Criteria**:
- Ghost optimization removes Obsidian features
- Wikilinks converted to standard markdown
- Clipboard copy works on macOS/Linux
- User can paste directly into Ghost editor
- Optimized markdown renders correctly in Ghost

**Files Modified**:
- `lua/core/functions.lua` - Ghost optimization
- `lua/plugins/which-key.lua` - Ghost submenu

---

### Phase 6: Testing & User Training (1-2 hours)

**Objective**: Test all publishing workflows and create usage documentation.

**Tasks**:
- [ ] Test LaTeX workflow
  - Select article template
  - Edit LaTeX document
  - Compile to PDF
  - View PDF
  - Clean aux files

- [ ] Test e-book workflow
  - Write test markdown with metadata
  - Export to EPUB
  - Verify metadata in EPUB
  - Preview EPUB
  - Convert to MOBI (if Calibre installed)

- [ ] Test presentation workflows
  - Write test presentation in markdown
  - Export to Marp HTML
  - Export to Marp PDF
  - Export to Reveal.js with theme
  - Verify slides render correctly

- [ ] Test Ghost workflow
  - Write markdown with wikilinks
  - Optimize for Ghost
  - Copy to clipboard
  - Test paste (manually in Ghost if available)

- [ ] Test quick conversions
  - Convert MD to Word
  - Convert MD to HTML
  - Verify output files created

- [ ] Create publishing guide
  - File: `docs/publishing-guide.md`
  - Section: LaTeX Academic Publishing
  - Section: E-Book Creation
  - Section: Creating Presentations
  - Section: Publishing to Ghost
  - Include screenshots/examples

- [ ] Update main documentation
  - Add "Publishing Workflows" to README
  - Document all publishing keybindings in CHEATSHEET
  - Add external dependencies section
  - Include troubleshooting tips

- [ ] Test error handling
  - Try MOBI export without Calibre
  - Try Marp export without Marp CLI
  - Try conversions with invalid files
  - Verify helpful error messages

**Success Criteria**:
- All publishing workflows tested
- Documentation complete and accurate
- User can follow guides independently
- Error messages helpful
- External dependencies clearly documented

**Files Created**:
- `docs/publishing-guide.md`

**Files Modified**:
- `README.md`
- `cheatsheet-readme/nvim-cheatsheet.md`

---

## Publishing Menu Structure

```
<leader>p - PUBLISHING
  w - Convert to Word
  h - Convert to HTML
  m - Convert to Markdown

  l - LaTeX submenu
    a - Article template
    l - Letter template
    p - Presentation template
    m - Convert MD → LaTeX
    c - Compile
    v - View PDF
    k - Clean aux files

  e - E-book submenu
    e - Export to EPUB
    m - Export to MOBI
    p - Preview EPUB
    i - Edit metadata

  s - Presentations submenu
    h - Marp HTML
    p - Marp PDF
    r - Reveal.js
    v - Preview slides

  g - Ghost submenu
    o - Optimize for Ghost
    c - Copy to clipboard
    t - Test compatibility
```

## External Dependencies

### Required
- **Pandoc** - Format conversions
  - Install: `brew install pandoc` (macOS)
  - Verify: `pandoc --version`

- **LaTeX Distribution** - PDF compilation
  - macOS: MacTeX or BasicTeX
  - Install: `brew install --cask mactex`
  - Verify: `pdflatex --version`

### Optional
- **Calibre** - MOBI conversion
  - Install: `brew install --cask calibre`
  - Verify: `ebook-convert --version`

- **Marp CLI** - Presentation slides
  - Install: `npm install -g @marp-team/marp-cli`
  - Verify: `marp --version`

### Already Configured
- **VimTeX** - LaTeX editing
- **Zathura** - PDF viewer (configured)

## Risk Assessment

### Medium Risk
- **Tool Dependencies**: Missing tools break workflows
  - **Mitigation**: Check tool availability, show install instructions

- **Metadata Extraction**: May fail for non-standard frontmatter
  - **Mitigation**: Provide fallback prompts, use sensible defaults

### Low Risk
- **LaTeX Templates**: May need user customization
  - **Mitigation**: Provide good defaults, document customization

- **Ghost Optimization**: Edge cases in wikilink conversion
  - **Mitigation**: Handle common patterns, document limitations

## Success Metrics

### Workflow Completion
- ✓ LaTeX: Template → Edit → Compile → View
- ✓ E-book: Write → Export EPUB → Preview → Convert MOBI
- ✓ Presentations: Write → Export → Preview
- ✓ Ghost: Write → Optimize → Copy → Paste

### Performance
- ✓ EPUB export <5 seconds
- ✓ LaTeX compile <10 seconds (typical paper)
- ✓ Presentation export <3 seconds

### User Experience
- ✓ User completes first LaTeX paper without help
- ✓ User creates first e-book successfully
- ✓ User publishes to Ghost without issues
- ✓ Error messages guide user to solutions

## Open Questions

1. **LaTeX Templates**:
   - Customize existing templates or keep as-is?
   - **Recommendation**: Keep as-is, user can customize later

2. **E-Book Cover Images**:
   - Support cover image selection?
   - **Recommendation**: Document how to add manually, defer auto-selection

3. **Presentation Themes**:
   - Provide custom theme or use defaults?
   - **Recommendation**: Use defaults, document customization

4. **Ghost API**:
   - Integrate Ghost API for direct publishing?
   - **Recommendation**: No, clipboard workflow simpler

## Next Steps

**Immediate**:
1. Begin Phase 1: Menu structure and quick conversions
2. Test with real documents
3. Gather user feedback

**Future Enhancements**:
- Bibliography management integration
- Multi-file book compilation
- Custom LaTeX/Marp themes
- Ghost API integration (if requested)

---

**Plan Status**: Ready for Implementation
**Next Session**: Phase 1 - Menu Structure & Quick Conversions
