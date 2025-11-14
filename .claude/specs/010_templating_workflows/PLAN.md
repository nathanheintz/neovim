# Implementation Plan: Templating Workflows

**Created**: 2025-11-14
**Status**: Not Started
**Complexity**: 5/10 (Medium)
**Estimated Duration**: 3-4 hours

---

## Executive Summary

This plan implements a comprehensive template system for Neovim that allows quick insertion of document templates into the current buffer. Templates will cover Obsidian note types (Zettelkasten, Knowledge Library, Case Studies), LaTeX document types (books, papers, presentations), and writing formats (blog posts, Instagram captions, etc.). A dedicated `<leader>t` which-key menu will provide organized access to all templates.

---

## Project Goals

### Primary Objectives
1. **Template Insertion System**: Function to insert template file contents at cursor position
2. **Which-Key Templates Menu**: Organized `<leader>t` menu for all template types
3. **Obsidian Templates**: Zettelkasten notes, Literature notes, Knowledge Library entries, Case Studies
4. **LaTeX Templates**: Books, academic papers, presentations, poems, Instagram posts
5. **Metadata Handling**: Auto-populate fields like date, ID, filename where applicable

### Secondary Objectives
- Template variables ({{DATE}}, {{TITLE}}, etc.) with auto-substitution
- Template snippets integration (leverage existing LuaSnip)
- Preview templates before insertion
- Custom template creation workflow

---

## Current State

**What Works**:
- LaTeX templates exist in `~/.config/nvim/templates/` directory
- LuaSnip snippet engine installed
- Which-key menu system in place
- `<leader>t` currently shows "TEMPLATES" but minimal functionality

**What's Missing**:
- Function to insert template file contents into current buffer
- Organized template directory structure
- Templates for Obsidian note types
- Which-key menu organization for templates
- Metadata auto-population

**Existing Templates**:
- `templates/obsidian/zettelkasten-note.md` - Basic zettelkasten structure (just created)
- `templates/*.tex` - LaTeX templates (need to audit what exists)

---

## Technical Approach

### Template Insertion Function

Create a Lua function that:
1. Reads template file from `~/.config/nvim/templates/`
2. Processes template variables ({{DATE}}, {{TITLE}}, etc.)
3. Inserts content at cursor position (or replaces buffer if empty)
4. Moves cursor to first placeholder/edit point

```lua
function InsertTemplate(template_path)
  local template_file = vim.fn.stdpath('config') .. '/templates/' .. template_path
  local lines = vim.fn.readfile(template_file)

  -- Process variables
  for i, line in ipairs(lines) do
    line = line:gsub('{{DATE}}', os.date('%Y-%m-%d'))
    line = line:gsub('{{DATETIME}}', os.date('%Y-%m-%d %H:%M'))
    line = line:gsub('{{FILENAME}}', vim.fn.expand('%:t:r'))
    lines[i] = line
  end

  -- Insert at cursor or replace buffer
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_buf_set_lines(0, cursor_pos[1] - 1, cursor_pos[1] - 1, false, lines)
end
```

### Template Directory Structure

```
templates/
├── obsidian/
│   ├── zettelkasten-note.md
│   ├── literature-note.md
│   ├── knowledge-library-entry.md
│   ├── case-study.md
│   └── project-note.md
├── latex/
│   ├── book.tex
│   ├── academic-paper.tex
│   ├── presentation.tex
│   ├── poem.tex
│   └── instagram-post.tex
├── writing/
│   ├── blog-post.md
│   ├── newsletter.md
│   └── social-media.md
└── README.md (explains template system)
```

### Template Variables

Support these substitution patterns:
- `{{DATE}}` - Current date (YYYY-MM-DD)
- `{{DATETIME}}` - Current date and time
- `{{FILENAME}}` - Current file name without extension
- `{{CURSOR}}` - Placeholder for cursor position after insertion
- `{{TITLE}}` - Prompt user for title

---

## Implementation Phases

### Phase 1: Core Template System (1-2 hours)

**Objective**: Build the template insertion function and basic menu structure.

**Tasks**:
- [ ] Create `InsertTemplate()` function in `lua/core/functions.lua`
  - Read template file from templates directory
  - Process template variables (DATE, DATETIME, FILENAME)
  - Insert at cursor position
  - Handle errors gracefully (missing template file)

- [ ] Add `<leader>t` which-key menu structure
  - Edit `lua/plugins/which-key.lua`
  - Create "TEMPLATES" group
  - Add submenus: Obsidian, LaTeX, Writing

- [ ] Test template insertion
  - Create test template file
  - Insert into empty buffer
  - Insert into existing buffer at cursor
  - Verify variable substitution

**Success Criteria**:
- Function successfully inserts template content
- Variables are properly substituted
- Cursor positioned appropriately after insertion
- No errors with missing files (graceful handling)

**Files Modified**:
- `lua/core/functions.lua` - InsertTemplate() function
- `lua/plugins/which-key.lua` - Templates menu structure

---

### Phase 2: Obsidian Templates (1 hour)

**Objective**: Create templates for all Obsidian note types.

**Tasks**:
- [ ] Audit Second Brain vault structure
  - Identify all note types currently used
  - Document required frontmatter fields
  - Note any special formatting needs

- [ ] Create Zettelkasten note template
  - Already created: `templates/obsidian/zettelkasten-note.md`
  - Add date auto-population
  - Add ID generation (timestamp-based?)

- [ ] Create Literature note template
  - Frontmatter: citekey, author, source, tags
  - Body: Summary, Key Quotes, My Notes sections

- [ ] Create Knowledge Library entry template
  - Structure for Methods+Tools library
  - Frontmatter: category, tags, related-methods
  - Body: Overview, When to Use, Examples

- [ ] Create Case Study template
  - Frontmatter: client, date, tags, outcome
  - Body: Problem, Approach, Results, Lessons

- [ ] Add templates to which-key menu
  - `<leader>to` - Obsidian submenu
  - `<leader>toz` - Zettelkasten note
  - `<leader>tol` - Literature note
  - `<leader>tok` - Knowledge Library entry
  - `<leader>toc` - Case Study

**Success Criteria**:
- All Obsidian note types have templates
- Templates include proper frontmatter
- Variables auto-populate (date, filename)
- All accessible via which-key menu

**Files Created**:
- `templates/obsidian/literature-note.md`
- `templates/obsidian/knowledge-library-entry.md`
- `templates/obsidian/case-study.md`

**Files Modified**:
- `lua/plugins/which-key.lua` - Obsidian templates submenu

---

### Phase 3: LaTeX Templates (1 hour)

**Objective**: Create and organize LaTeX document templates.

**Tasks**:
- [ ] Audit existing LaTeX templates
  - Check what's in `templates/` directory
  - Test if they compile
  - Note any missing types

- [ ] Create/update LaTeX templates
  - Book template (chapters, ToC, etc.)
  - Academic paper template (abstract, sections, bibliography)
  - Presentation template (Beamer slides)
  - Poem template (verse environment)
  - Instagram post template (custom dimensions)

- [ ] Add LaTeX-specific variable support
  - `{{TITLE}}` - Document title
  - `{{AUTHOR}}` - Author name (from git config?)
  - `{{DATE}}` - Current date

- [ ] Add templates to which-key menu
  - `<leader>tl` - LaTeX submenu
  - `<leader>tlb` - Book
  - `<leader>tlp` - Academic paper
  - `<leader>tls` - Presentation (slides)
  - `<leader>tlv` - Poem (verse)
  - `<leader>tli` - Instagram post

**Success Criteria**:
- All LaTeX templates compile successfully
- Templates include common packages/setup
- Variables properly substituted
- Accessible via which-key menu

**Files Created/Modified**:
- Various `templates/latex/*.tex` files
- `lua/plugins/which-key.lua` - LaTeX templates submenu

---

### Phase 4: Writing Templates & Enhancements (1 hour)

**Objective**: Add writing templates and enhance template system.

**Tasks**:
- [ ] Create writing templates
  - Blog post template (frontmatter, structure)
  - Newsletter template (sections, CTAs)
  - Social media template (character limits, hashtags)

- [ ] Add advanced variable support
  - `{{CURSOR}}` - Placeholder for cursor after insertion
  - `{{TITLE|prompt}}` - Prompt user for value
  - Interactive variable replacement

- [ ] Create template selection menu
  - If multiple templates for same type, show picker
  - Telescope integration for template browser?

- [ ] Add template documentation
  - Create `templates/README.md` explaining system
  - Document how to create new templates
  - List all available templates and variables

- [ ] Add templates to which-key menu
  - `<leader>tw` - Writing submenu
  - `<leader>twb` - Blog post
  - `<leader>twn` - Newsletter
  - `<leader>tws` - Social media

**Success Criteria**:
- Writing templates available and functional
- Advanced variables work (CURSOR, TITLE prompts)
- Documentation complete
- User can create custom templates easily

**Files Created**:
- `templates/writing/*.md` files
- `templates/README.md`

**Files Modified**:
- `lua/core/functions.lua` - Enhanced InsertTemplate()
- `lua/plugins/which-key.lua` - Writing templates submenu

---

### Phase 5: Integration & Testing (30 min)

**Objective**: Test all templates and integrate with existing workflows.

**Tasks**:
- [ ] Test all templates end-to-end
  - Obsidian templates in Second Brain vault
  - LaTeX templates compile successfully
  - Writing templates in various contexts

- [ ] Test edge cases
  - Empty buffer vs cursor insertion
  - Missing template files
  - Invalid variable syntax
  - Very large templates

- [ ] Integration with existing features
  - Test with Lectic personas (does frontmatter work?)
  - Test with Obsidian.nvim (wikilinks, vault detection)
  - Test with VimTeX (compilation, viewing)

- [ ] Update documentation
  - Add "Templates" section to README.md
  - Document all templates in CHEATSHEET.md
  - Include template menu structure

**Success Criteria**:
- All templates tested and working
- Edge cases handled gracefully
- Integration with existing features works
- Documentation complete

**Files Modified**:
- `README.md` - Templates section
- `CHEATSHEET.md` - Template keybindings

---

## Keybinding Structure

### Proposed `<leader>t` Menu

```
<leader>t - TEMPLATES
  o - Obsidian templates
    z - Zettelkasten note
    l - Literature note
    k - Knowledge Library entry
    c - Case Study
    p - Project note

  l - LaTeX templates
    b - Book
    p - Academic paper
    s - Presentation (slides)
    v - Poem (verse)
    i - Instagram post

  w - Writing templates
    b - Blog post
    n - Newsletter
    s - Social media
```

---

## Template Examples

### Zettelkasten Note
```markdown
---
id: {{DATETIME}}
aliases: []
tags: []
created: {{DATE}}
---

## Idea:
{{CURSOR}}

## Tags:


## Sources:


## West: Similar


## East: Opposite


## North: Theme/Questions


## South: What does this lead to?

```

### Academic Paper (LaTeX)
```latex
\documentclass[12pt,letterpaper]{article}

\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{amsmath,amssymb}
\usepackage{graphicx}
\usepackage[margin=1in]{geometry}
\usepackage{biblatex}

\title{{{TITLE}}}
\author{{{AUTHOR}}}
\date{{{DATE}}}

\begin{document}

\maketitle

\begin{abstract}
{{CURSOR}}
\end{abstract}

\section{Introduction}


\section{Methods}


\section{Results}


\section{Discussion}


\printbibliography

\end{document}
```

---

## Risk Assessment

### Low Risk
- **Template file management**: Simple file operations
  - **Mitigation**: Clear directory structure, README documentation

- **Variable substitution**: Basic string replacement
  - **Mitigation**: Test with various variable combinations

### Medium Risk
- **Cursor positioning**: May not work perfectly in all cases
  - **Mitigation**: Fallback to end of inserted content if {{CURSOR}} not found

- **LaTeX compilation**: Templates may not compile if missing packages
  - **Mitigation**: Include package installation notes in template comments

---

## Success Metrics

- ✓ Can insert any template with single keystroke from which-key menu
- ✓ Variables auto-populate correctly (date, filename, etc.)
- ✓ All Obsidian note types have templates
- ✓ All LaTeX document types have templates
- ✓ Templates integrate smoothly with existing workflows
- ✓ User can easily create custom templates

---

## Future Enhancements

Ideas for future iterations:
- Snippet-style placeholders with tab-stops
- Template versioning/variants
- Project-specific template directories
- Template inheritance (base + variations)
- AI-assisted template generation via Lectic

---

**Plan Status**: Ready for Implementation
**Next Session**: Phase 1 - Core Template System
