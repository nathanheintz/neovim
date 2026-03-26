# Session Log: Publishing Workflows

**Project**: 004 - Publishing Workflows
**Created**: 2025-12-04

---

## Task Batch 1: LaTeX Setup & Template Creation

**Date**: 2025-12-04

### Discussion:
- User wanted to start working with LaTeX in Neovim
- Requested to test basic functionality (compile, view, context menu)
- Wanted to create templates from existing LaTeX documents in SecondBrain
- Three specific templates requested:
  - "Letters" → rename to "Personal Letter"
  - "Professional Letter" (with full address blocks)
  - "Simple Book Template"

### Implementation:

**1. Verified LaTeX Configuration**
- Confirmed VimTeX installed and configured (`lua/plugins/vimtex.lua:1`)
- VimTeX mappings disabled (`vim.g.vimtex_mappings_enabled = false`)
- Using Skim as PDF viewer
- No localleader key set (VimTeX uses leader key bindings instead)
- Existing which-key bindings confirmed working:
  - `<leader>pc` - Compile LaTeX
  - `<leader>pv` - View PDF
  - `<leader>pV` - VimTeX context menu (has bug, not working)
  - Other VimTeX commands available

**2. Tested Basic Functionality**
- User successfully created new .tex file
- Used Letter template
- Compiled successfully
- PDF opened in Skim viewer
- **Note**: VimTeX context menu (`<leader>pV`) not working - binding uses `<plug>(vimtex-context-menu)` but VimTeX mappings are disabled. User decided not needed for now.

**3. Created Three New Templates**

**PersonalLetter.tex** (`templates/PersonalLetter.tex`):
- Based on `~/SecondBrain/4-Resources/Tex-Templates/Letters/Letter.tex`
- EB Garamond font with microtype
- Right-aligned author/date header
- "Dear NAME," placeholder
- Clean, simple informal letter format
- A4 paper, 11pt font
- Custom margins (top: 1.25in, bottom: 1in, sides: 1.65in)

**ProfessionalLetter.tex** (`templates/ProfessionalLetter.tex`):
- Based on `~/SecondBrain/4-Resources/Tex-Templates/Professional Letter/letter-for-elan.tex`
- **Letterhead in top margin** using `fancyhdr` package
- User's name: "Nathan Heintz" (Large, bold)
- Contact info on second line with bullet separators:
  - 952 Flushing Avenue, Brooklyn NY 11206 • nathan@nathanheintz.com • +1 510 393 3705
- Horizontal rule separator below contact info
- Extended top margin (1.5in) to accommodate letterhead
- Palatino font
- Letterhead appears in header area, not document body
- Natural line spacing between contact info and hrule

**SimpleBook.tex** (`templates/SimpleBook.tex`):
- Based on `~/SecondBrain/4-Resources/Tex-Templates/Simple Book Template/Template Book Simple.tex`
- A5 book format with custom cover page environment
- EB Garamond font with custom typography
- Custom TOC styling with `titletoc` and `tocloft`
- Fancy headers/footers with `fancyhdr`
- Chapter/section structure pre-configured
- Includes placeholder chapters with blindtext
- Custom chapter and section formatting

**4. Added Templates to Which-Key Menu**
- Modified `lua/plugins/which-key.lua:258-260`
- Added three new template bindings under `<leader>t`:
  - `<leader>tp` - Personal letter
  - `<leader>tl` - Professional letter
  - `<leader>tb` - Simple book
- Replaced old `<leader>tl` binding that pointed to `Letter.tex`

**5. Refined Professional Letter Template**
- Initial version had letterhead in document body
- User correctly identified letterhead should be in top margin
- Refactored to use `fancyhdr` package
- Moved letterhead to `\fancyhead[L]` with minipage
- Increased top margin and set `headheight=50pt`
- Removed `[0.5em]` spacing before hrule for natural line spacing

### Files Modified:
- `/Users/nathanheintz/.config/nvim/templates/PersonalLetter.tex` (created)
- `/Users/nathanheintz/.config/nvim/templates/ProfessionalLetter.tex` (created, refined)
- `/Users/nathanheintz/.config/nvim/templates/SimpleBook.tex` (created)
- `/Users/nathanheintz/.config/nvim/lua/plugins/which-key.lua` (lines 258-260) - Added template bindings

### Testing:
- User tested basic LaTeX workflow: create → compile → view → SUCCESS
- Professional letter letterhead verified to be in margin area
- Spacing refined to user's preference

### Decisions:
- VimTeX context menu bug not addressed - user doesn't need it currently
- No localleader key set - using leader key bindings works well
- Letterhead uses fancyhdr to sit in top margin (proper letterhead style)
- Natural line spacing preferred over explicit spacing values

### Git Commit:
[not yet]

---

---

## Task Batch 2: Template Refinements - Professional Letter & Simple Book

**Date**: 2025-12-04

### Discussion:
- User tested professional letter template and discovered spacing issues
- Requested letterhead be moved to top margin (proper letterhead placement)
- Requested changes to book template: opening words style, chapter quotes, ISBN page
- Worked through LaTeX spacing concepts (`\vspace`, `\parskip`, paragraph breaks)
- Encountered limitation with auto-filling bold titles on copyright page

### Implementation:

**1. Professional Letter Template Refinements**

**Moved letterhead to top margin** (`templates/ProfessionalLetter.tex`):
- Added `fancyhdr` package for header control
- Increased top margin to 1.5in with `headheight=50pt`
- Moved letterhead to `\fancyhead[L]` using minipage
- Letterhead now in margin area, not document body
- User's name: "Nathan Heintz" (large, bold)
- Contact info with bullet separators: 952 Flushing Avenue, Brooklyn NY 11206 • nathan@nathanheintz.com • +1 510 393 3705
- Horizontal rule separator below contact
- Natural line spacing (removed `[0.5em]` for cleaner look)

**Updated letter content formatting**:
- Changed `\parskip` from 12pt to 6pt for tighter spacing
- Recipient format: `To: [Name]\\Organization\\Address...`
- `\vspace{2em}` before greeting
- `\vspace{1em}` after greeting and before closing
- Changed closing from "Sincerely," to "Warmly,"
- Signature: Nathan Heintz

**LaTeX spacing education provided**:
- Explained `\vspace{}` only works between paragraphs, not within
- Blank lines create new paragraphs in LaTeX
- `\parskip` adds automatic spacing between all paragraphs
- Combined with manual `\vspace{}` creates cumulative spacing

**2. Simple Book Template Enhancements**

**Added chapter opening words command** (`templates/SimpleBook.tex`):
- Created `\openingwords{text}` command for small caps chapter openings
- Uses `\noindent` and `\textsc{}` for traditional book typography
- Usage: `\openingwords{The first few words} continue normally...`
- Applied to all example chapters

**Changed chapter quote formatting**:
- Created `\chapterquote{text}` command
- Uses `quote` environment (indented from both sides)
- Italicized text (`\itshape`)
- Left-aligned (not centered)
- Traditional epigraph style for literature

**Added professional front matter**:

**Copyright/ISBN page** (following industry standards):
- Positioned at bottom of page (`\vspace*{\fill}`)
- Small font (`\footnotesize`)
- Left-aligned throughout (`\noindent` on every line, `\setlength{\parindent}{0pt}`)
- Elements included:
  - Book title (italic only, hardcoded - LaTeX limitation with bold in `\title{}`)
  - Copyright line with year and author (auto-filled from `\@author`)
  - "All rights reserved" statement
  - Publisher: Ground Center Internal Arts LLC with Brooklyn address
  - Rights statement (standard boilerplate)
  - ISBN numbers for paperback, ebook, hardcover (with proper line breaks)
  - First edition date
  - Design credits
  - Printing location

**Dedication page**:
- Positioned 1/3 down page (`\vspace*{0.33\textheight}`)
- Centered horizontally
- Large italic text: "Dedicated to my mother."
- No page number

**Front matter order** (verified against publishing standards):
1. Cover page (with series info)
2. Title page
3. Copyright/ISBN page (verso of title page)
4. Dedication page
5. Table of contents
6. Book content

**Auto-filling title and author**:
- Cover page uses `\@title` and `\@author` (requires `\makeatletter`/`\makeatother`)
- Title page uses `\maketitle`
- Copyright page uses `\@author` for auto-fill
- Copyright page title is hardcoded due to LaTeX limitation (can't strip `\textbf{}` from `\title{}` definition)

**Title page spacing adjustment**:
- Added `\setlength{\droptitle}{-2em}` to move title up
- Added `\preauthor{\begin{center}\large\vspace{-1em}}` to reduce gap between title and author
- Reduced spacing by ~50-66% as requested

**Bug fixes**:
- Fixed line breaks on copyright page (author name, publisher address)
- Fixed ISBN line breaks (moved `\\` before comments, not after)
- Added proper punctuation after author name

### Files Modified:
- `/Users/nathanheintz/.config/nvim/templates/ProfessionalLetter.tex` - Letterhead to margin, spacing refinements
- `/Users/nathanheintz/.config/nvim/templates/SimpleBook.tex` - Opening words, chapter quotes, ISBN page, dedication, front matter order, spacing

### Testing:
- User tested professional letter - letterhead placement correct
- User tested book template - front matter flows correctly
- Spacing verified as professional and clean

### Decisions:
- ISBN page title must be manually updated due to LaTeX limitation with bold in `\title{}` definition
- Letterhead in top margin follows publishing best practices
- Front matter order verified against multiple publishing sources
- 6pt `\parskip` provides good balance for letters
- Dedication at 1/3 page height (not centered) per user preference

### Git Commit:
[not yet]

---

## Task Batch 3: Screenplay Template with LaTeX Package Education

**Date**: 2025-12-11

### Discussion:
- User wanted to create a screenwriting LaTeX template for industry-standard screenplay formatting
- Requested educational approach: learn how LaTeX packages work rather than just copying code
- User wanted to understand the relationship between packages, document classes, and templates

### Implementation:

**1. Educational Exploration of LaTeX Packages**

**Explained LaTeX architecture**:
- **Package** = Collection of commands/formatting rules (loaded with `\usepackage{}`)
- **Document class** = Base document type (loaded with `\documentclass{}`)
- **Template** = Starter `.tex` file that loads packages/classes and sets up structure

**Example from existing templates**:
- Showed PersonalLetter.tex structure
- Demonstrated how `\usepackage{microtype}`, `\usepackage{graphicx}`, etc. load functionality
- Explained that packages provide commands you can then use in your document

**2. Researched Screenplay Formatting Standards**

**Industry standards verified** (via web search):
- Font: Courier 12pt (monospaced - 1 page = 1 minute screen time)
- Margins: 1.5" left, 1" right, 1" top/bottom
- Page numbering: Top right, 0.5" from top
- Specific dialogue positioning for professional formatting

**LaTeX screenplay package found**:
- Package name: `screenplay` (actually a document class)
- Version: v1.6 (2012/06/30) by John Pate
- CTAN location: https://ctan.org/pkg/screenplay
- Already installed locally: `/usr/local/texlive/2024/texmf-dist/tex/latex/screenplay/screenplay.cls`
- Documentation: `/usr/local/texlive/2024/texmf-dist/doc/latex/screenplay/screenplay.pdf`

**3. Reviewed Screenplay Package Documentation**

**Key commands identified from documentation** (screenplay.pdf pages 3-5):

*Title page*:
- `\title{}`, `\author{}`, `\address{}`
- `\coverpage` (full title page) or `\nicholl` (simple title)

*Scene headings*:
- `\intslug[time of day]{location}` - INT. LOCATION DAY
- `\extslug[time of day]{location}` - EXT. LOCATION DAY
- `\intextslug[]{}`, `\extintslug[]{}` - Combined INT./EXT.

*Dialogue*:
- `\begin{dialogue}[direction]{CHARACTER} ... \end{dialogue}`
- `\paren{text}` - Parentheticals within dialogue
- `\dialbreak[direction]{CHARACTER}` - Page break in dialogue

*Transitions and special*:
- `\fadein`, `\fadeout`, `\theend`
- `\centretitle{text}` - For flashbacks/dates
- `\intercut` - INTERCUT WITH:
- `\pov\ `, `\revert\ ` - Camera angles

**4. Created Comprehensive Screenplay Template**

**Created** `templates/Screenplay.tex`:
- Uses `\documentclass{screenplay}` (note: it's a class, not a package)
- Demonstrates ALL key screenplay commands
- Includes descriptive placeholders:
  - "Your Screenplay Title", "Your Name"
  - "Location name", "Action description of what happens in the scene"
  - "CHARACTER NAME", "What the character says as dialogue"
  - "emotional direction", "reaction or action"
- Shows proper structure: title page → fade in → scenes → dialogue → fade out → the end

**Educational approach in template**:
- Comments explain when to use `\coverpage` vs `\nicholl`
- Demonstrates basic dialogue vs. dialogue with direction
- Shows `\paren{}` usage within dialogue
- Examples of `\centretitle{}` for flashbacks
- POV and intercut examples with context
- Clear progression through typical screenplay structure

**5. Added Template to Which-Key Menu**

**Modified** `lua/plugins/which-key.lua:261`:
- Added `<leader>ts` - "screenplay" template binding
- Placed between SimpleBook and TherapeuticJournal templates
- Maintains consistent formatting with other template entries

### Files Modified:
- `/Users/nathanheintz/.config/nvim/templates/Screenplay.tex` (created) - Comprehensive screenplay template with all key commands
- `/Users/nathanheintz/.config/nvim/lua/plugins/which-key.lua` (line 261) - Added `<leader>ts` keybinding

### Testing:
- Package verified installed locally
- Documentation opened successfully in Skim
- Template created with industry-standard structure
- User to test: reload config → `<leader>ts` → compile → view PDF

### Decisions:
- Used `screenplay` document class (not a package - it's the document class itself)
- Chose `\coverpage` as default (full title page) with comment about `\nicholl` alternative
- Included descriptive placeholders rather than realistic content for maximum clarity
- Demonstrated all major commands in logical screenplay flow
- Used educational comments throughout for future reference

### Learning Outcomes:
- User now understands LaTeX package vs. class vs. template architecture
- Knows how to read LaTeX documentation (PDF opened in Skim)
- Can locate installed packages: `kpsewhich screenplay.cls`
- Can find documentation: `find /usr/local/texlive/2024/texmf-dist -name "*screenplay*"`
- Understands template = starter file that loads and uses package/class commands

### Git Commit:
[not yet]

---

## Task Batch 4: Coaching Agreement Template with Field Auto-Population

**Date**: 2025-12-12

### Discussion:
- User wanted LaTeX template for coaching agreements used in their coaching business
- Requested efficient workflow: define client fields once at top, auto-populate throughout document
- Emphasized importance: "creating a great many of them with my highly successful and growing coaching business"
- Source document: `~/SecondBrain/2-Areas/Coaching/NH-Coaching-Materials/Coaching-Agreement.md`
- User made changes to source and requested re-read before template creation

### Implementation:

**1. Analyzed Updated Source Document**

**Fields identified for auto-population**:
- `[Date]` - Agreement date (appears in header)
- `[First Name]` - Client's first name (greeting)
- `[Full Name]` - Client's full legal name (legal section)
- `[Start Date]` - Coaching start date
- `[Duration]` - Length of engagement (appears 3 times)
- `[Amount]` - Financial investment

**Document structure**:
- Header with title and date
- Congratulatory greeting using first name
- Structure of Coaching section
- Payment section
- Description of Coaching (legal)
- Coach-Client Relationship (enumerated subsections a-e)
- Scheduling & Cancellation
- Confidentiality
- Limited Liability
- How to Get the Most Out of Your Coaching Program
- Client signature lines

**2. Created Coaching Agreement Template**

**Created** `templates/CoachingAgreement.tex`:

**Field definition system**:
- Clearly marked section at top with comment borders
- Six `\newcommand{}` definitions for all variable fields
- User fills these once, they populate throughout document
- Example:
  ```latex
  % ============================================
  % FILL IN THESE FIELDS FOR EACH CLIENT
  % ============================================
  \newcommand{\agreementdate}{[Date]}
  \newcommand{\clientfirstname}{[First Name]}
  \newcommand{\clientfullname}{[Full Name]}
  \newcommand{\startdate}{[Start Date]}
  \newcommand{\duration}{[Duration]}
  \newcommand{\amount}{[Amount]}
  % ============================================
  ```

**Document formatting**:
- EB Garamond font (consistent with PersonalLetter template)
- Custom margins: 1.25in top, 1in bottom, 1.65in sides
- No page numbers (`\pagestyle{empty}`)
- Section and subsection formatting with `titlesec`
- No paragraph indentation, 6pt spacing between paragraphs

**Structure implementation**:
- Centered header with title, company name, date, and horizontal rule
- Opening greeting with `\clientfirstname`
- Section headings use `\section*{}` (unnumbered)
- Coach-Client Relationship subsections use enumerated list with (a), (b), etc.
- Client agreements use bullet point list
- Signature lines with underlined spaces for name, signature, date

**Auto-population examples**:
- "Congratulations \clientfirstname!" - uses first name
- "Our coaching officially begins in \startdate, and will have a duration of \duration" - uses start date and duration
- "Your financial investment for this \duration{} coaching agreement is \$\amount" - uses duration and amount with proper dollar sign
- "Coach Nathan Heintz and Client \clientfullname" - uses full legal name

**3. Added Template to Which-Key Menu**

**Modified** `lua/plugins/which-key.lua:262`:
- Added `<leader>tc` - "coaching agreement" template binding
- Placed between Screenplay and TherapeuticJournal templates
- Maintains consistent formatting with other template entries

### Files Modified:
- `/Users/nathanheintz/.config/nvim/templates/CoachingAgreement.tex` (created) - Comprehensive coaching agreement with 6 auto-populating fields
- `/Users/nathanheintz/.config/nvim/lua/plugins/which-key.lua` (line 262) - Added `<leader>tc` keybinding

### Testing:
- Template created with all 6 fields defined
- All field usages verified against source markdown
- User to test: reload config → create .tex file → `<leader>tc` → fill fields → compile → verify PDF

### Decisions:
- Used `\newcommand{}` approach for maximum clarity and ease of use
- Clearly marked field definition section with comment borders
- EB Garamond font matches other professional letter templates
- No page numbers appropriate for 2-page agreement document
- Enumerated lists (a-e) match legal document formatting standards
- `\duration{}` with braces ensures proper spacing when followed by text

### User Workflow:
1. Create new .tex file
2. `<leader>tc` to insert coaching agreement template
3. Edit 6 field definitions at top (between comment lines)
4. `<leader>pc` to compile LaTeX
5. `<leader>pv` to view PDF
6. All client information auto-populated throughout document

### Git Commit:
[not yet]

---

## Next Steps

**Immediate**:
- User to test coaching agreement template with real client information
- Test all five LaTeX templates in real-world usage (PersonalLetter, ProfessionalLetter, SimpleBook, Screenplay, CoachingAgreement)
- Decide if any additional templates needed from SecondBrain directory

**Remaining Phases** (from PLAN.md):
- Phase 1: Menu structure reorganization
- Phase 3: E-book publishing (EPUB/MOBI)
- Phase 4: Presentation workflows (Marp/Reveal.js)

**Not Needed** (per user decisions):
- MD → LaTeX conversion function
- Ghost publishing optimization
- Template selection function

---

## Task Batch N: vim-table-mode & render-markdown Improvements

**Date**: 2026-03-26

### Discussion:
- User wanted a live table editor for markdown (vim-table-mode)
- User wanted differentiated heading colors in render-markdown's normal-mode rendering
- User wanted smaller bullet icons with a trailing space
- User uses render-markdown primarily in terafox colorscheme (SecondBrain cwd)

### Implementation:

**1. vim-table-mode**

File: `lua/plugins/vim-table-mode.lua` (new file)

- Plugin: `dhruvasagar/vim-table-mode`
- Lazy-loaded for `markdown` and `lectic.markdown` filetypes
- `vim.g.table_mode_corner = "|"` for standard markdown table corners
- Added `<leader>mtt` keymap to toggle table mode
- Workflow: type `||` on TWO rows (header row + separator row) to build table structure
- Table mode recognizes existing markdown tables on activation

**Table rendering notes**:
- vim-table-mode adds a closing `|---|` row by default — this causes render-markdown to split the table visually (reads second separator as new header). Can be disabled per-table by removing the bottom row, or globally via `vim.g.table_mode_border = 0`.
- Multi-line cells not supported in markdown — but rows without horizontal dividers render as "grouped" blocks of text, which creates a wrapped-text appearance. Use em-dashes (`——`) in a normal data row as a visual separator within a column group.

**2. render-markdown.nvim: Bullet Icons**

Changed from large geometric shapes to smaller `• ◦ ▸ ▹` with trailing space for visual breathing room.

**3. render-markdown.nvim: Heading Colors**

- Problem: all H1–H6 used the same color; background banner barely differentiated between levels
- Solution: pull colors dynamically from nightfox palette API (`require("nightfox.palette").load(colorscheme)`) — auto-adapts to carbonfox, terafox, nightfox, nordfox without hardcoded hex values
- Foreground color map (terafox, mirrors neo-tree directory hierarchy):
  - H1: `orange.base` (bold, no background)
  - H2: `orange.base` (bold, `bg4` background banner)
  - H3: `red.base` (`bg4` background)
  - H4: `blue.base` (`bg3` background)
  - H5: `blue.dim` or `fg3` (`bg2` background)
  - H6: `fg3` (`bg1` background, nearly flush)
- Also override `@markup.heading.N.markdown` treesitter groups with the same hl — otherwise treesitter takes priority and text color doesn't match the icon color
- Fallback for non-nightfox themes: link to treesitter heading groups
- Re-applies on `ColorScheme` autocmd via `vim.schedule` (runs after render-markdown's own setup)

### Files Created/Modified:
- `lua/plugins/vim-table-mode.lua` — New plugin config (created)
- `lua/plugins/render-markdown.lua` — Bullet icons, heading color system, config→fn conversion
- `lua/plugins/which-key.lua` — Added `<leader>mtt` table mode toggle

### Decisions:
- vim-table-mode preferred over manual table formatting — works well with existing markdown tables
- Heading colors pulled from nightfox palette API rather than hardcoded hex (adapts to all cwd colorschemes)
- H1 has no background banner (stands alone with bold orange); H2 shares H3's banner color but has same orange text as H1
- Background gradient uses `sel1 → bg4 → bg4 → bg3 → bg2 → bg1` (removed sel1 for H1)

### Git Commit: cb7260e

---
