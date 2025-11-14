# Neovim Configuration - Project Context

**Last Updated**: 2025-11-13
**Owner**: Nathan Heintz
**Purpose**: Writing and publishing-focused Neovim configuration

---

## What This Config Is

A Neovim configuration optimized for:
- **Writing workflow**: Zettelkasten note-taking, AI-assisted writing, markdown composition
- **Publishing**: LaTeX with VimTeX, markdown presentations with Deckset, document conversion with Pandoc
- **Knowledge management**: Obsidian vault integration, Lectic AI conversations
- **Development**: Ghost theme development (HTML/Handlebars), general coding with LSP

**NOT academic LaTeX-focused** (unlike Ben's original NeoTex config this was forked from)

---

## Tools We USE

### AI & Writing
- **Lectic** - AI writing assistant with 12 persona modes (single-party, NOT multi-party)
- **Obsidian.nvim** - Obsidian vault integration with wiki-link completion
- **Render-markdown.nvim** - Live markdown rendering
- **Markdown-preview.nvim** - Browser preview

### Publishing
- **VimTeX** - LaTeX compilation and viewing
- **Deckset** - Markdown presentations (you actively use this)
- **Pandoc** - Document conversion (md → docx, pdf, html, etc.)

### Development
- **LSP** - lua-language-server, typescript, etc.
- **Treesitter** - Syntax highlighting
- **Blink.cmp** - Completion engine with smart per-filetype sources
- **LuaSnip** - Snippet engine

### File Management & Git
- **Neo-tree** - File explorer
- **Telescope** - Fuzzy finder
- **LazyGit** (via Snacks.nvim) - Git interface
- **Gitsigns** - Git signs in gutter

### UI & Navigation
- **Which-key** - Command palette (with Kitty terminal bug patch)
- **Bufferline** - Buffer tabs
- **Snacks.nvim** - Dashboard, zen mode, notifications
- **Nightfox** - Color schemes (carbonfox, terafox, nightfox - auto-switch based on cwd)

### Plugin Management
- **Lazy.nvim** - Plugin manager with lazy loading

---

## Tools We DON'T Use

- **Avante** - NOT used (you use Lectic instead)
- **NixOS tools** - NOT on NixOS (you're on macOS)
- **Harpoon** - Removed from config
- **Kanban** - Removed from config

---

## Directory Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── core/               # Core configuration
│   │   ├── options.lua     # Vim options (folding, colorscheme autocmds, etc.)
│   │   ├── keymaps.lua     # Non-leader keymaps
│   │   └── functions.lua   # Utility functions
│   ├── bootstrap.lua       # Lazy.nvim setup
│   └── plugins/            # Plugin configurations
│       ├── lsp/            # LSP-related plugins
│       │   └── blink-cmp.lua  # Completion config with toggles
│       ├── snacks/         # Snacks.nvim components
│       │   └── dashboard.lua
│       ├── which-key.lua   # All leader keybindings
│       ├── lectic.lua      # Lectic personas and functions
│       ├── colorscheme.lua # Nightfox plugin
│       └── *.lua           # Individual plugin configs
├── after/
│   └── ftplugin/           # Filetype-specific settings
├── snippets/               # Custom LuaSnip snippets
├── templates/              # LaTeX templates
├── README.md               # Main config documentation
├── CHEATSHEET.md           # User-facing keybinding reference
├── cheatsheet-readme/      # Supplementary docs (Lectic, LazyGit, Deckset, generic Vim)
└── .claude/                # This documentation system
```

---

## Key Configuration Details

### Leader Key
`<Space>` - Used for all main commands

### Which-Key Menu Structure
```
<leader>w - WINDOW (splits)
<leader>c - CODE (LSP features)
<leader>a - ACTIONS (misc utilities)
<leader>f - FIND (Telescope)
<leader>g - GIT (LazyGit, Gitsigns)
<leader>m - MARKDOWN & WRITING (Lectic, zen, toggles)
  <leader>mp - Persona switching (12 personas)
  <leader>ms - Surround
  <leader>mt - Toggles (completion, folding)
<leader>s - SESSIONS
<leader>p - PUBLISHING (VimTeX, Pandoc)
<leader>r - RUN (reload, diagnostics)
<leader>t - TEMPLATES
```

### Lectic Configuration
- **Mode**: Single-party only (multi-party broken in beta6)
- **Personas**: 12 total (Consultant, Marketing, Finance, Product, Researcher, Writer, Editor, Designer, Scholar, Scribe, Homie, Nomad)
- **Switching**: `<leader>mp` submenu to switch personas
- **Context**: Add via markdown links in document body (NOT frontmatter)
- **File creation**: `<leader>mn` creates with Homie persona by default
- **Model**: claude-3-7-sonnet

### Completion Toggles
- Buffer completion: OFF by default in markdown, ON elsewhere
- Obsidian completion: Toggle with `<leader>mto`
- Snippet completion: Toggle with `<leader>mtx`

### Colorscheme Auto-Switching
Based on current working directory (see `lua/core/options.lua`):
- `~/.config` → carbonfox
- `~/SecondBrain` → terafox
- `~/ghostdev` → nightfox
- Default → terafox

### Known Bugs & Patches
- **Which-key + Kitty terminal**: Space key in submenus triggers dashboard actions
- **Fix**: Auto-patch on VimEnter treats Space as Escape (see `lua/plugins/which-key.lua`)
- **Bug report**: `.claude/bug-reports/which-key-space-feedkeys.md`

---

## Workflow Preferences

### Collaborative & Incremental
- Work in dialogue, not batch automation
- Discuss approaches before implementing
- Show proposed changes for approval
- Implement step-by-step with user reviewing each change

### Review Before Action
- User approves all write/edit operations
- User can reject and provide alternative direction
- No aggressive changes without discussion

### Context-Aware
- Agent should check existing implementation before assuming
- Agent should reference global documentation (README, GLOBAL_SUMMARY_LOG)
- Agent should understand broader config context

### Documentation Standards
- Follow NVIM_STANDARDS.md for coding conventions
- Update session logs after each approved task batch
- Update plans at phase breaks
- Commit at phase completions
- Update README/CHEATSHEET when projects complete

---

## File Locations Quick Reference

**Keybindings**: `lua/plugins/which-key.lua`
**Dashboard**: `lua/plugins/snacks/dashboard.lua`
**Lectic personas**: `lua/plugins/lectic.lua`
**Colorscheme**: `lua/plugins/colorscheme.lua`
**Completion**: `lua/plugins/lsp/blink-cmp.lua`
**Core options**: `lua/core/options.lua`
**Auto-formatter**: `lua/plugins/conform.lua` (format-on-save disabled, manual `<leader>af`)

---

## Common Patterns

### Adding a New Keybinding
1. Edit `lua/plugins/which-key.lua`
2. Add to appropriate menu group
3. Update CHEATSHEET.md
4. Reload config with `<leader>rr`

### Adding a New Plugin
1. Create `lua/plugins/plugin-name.lua`
2. Return plugin spec with lazy.nvim format
3. Restart nvim or run `:Lazy install`

### Modifying Lectic Personas
1. Edit `lua/plugins/lectic.lua`
2. Update `all_personas` table (line 228)
3. Update which-key persona menu if adding new persona

---

## Terminal & Shell

- **Terminal**: Kitty (with enhanced keyboard protocol)
- **Shell**: Fish
- **OS**: macOS (Darwin 24.1.0)

---

## Projects Directory Structure

**Main vault**: `~/SecondBrain/` (Obsidian vault)
**Ghost themes**: `~/ghostdev/`
**Config**: `~/.config/nvim/`

---

## Important Context

- You forked from Ben's NeoTex config but have diverged significantly
- You removed most Ben-specific features (NixOS, Avante, heavy LaTeX focus)
- You focus on writing/zettelkasten/publishing workflow
- You actively use Deckset for presentations
- You prefer collaborative dialogue over automated batch execution
- You want reliable incremental documentation to prevent work loss
