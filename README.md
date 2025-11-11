# Neovim Configuration

A writing and publishing-focused Neovim configuration optimized for Lectic AI writing, Obsidian note-taking, LaTeX publishing, and Ghost theme development.

## Overview

This configuration prioritizes:
- **Writing workflow**: Zen mode, smart completion, spell checking
- **Note-taking**: Obsidian vault integration with wiki-link completion
- **AI assistance**: Lectic writing assistant with frontmatter support
- **Publishing**: LaTeX with VimTeX, markdown presentations
- **Development**: Ghost theme development (HTML/Handlebars)

## Features

### Writing & Note-Taking
- Zen mode for distraction-free writing (Snacks.nvim)
- Smart per-filetype completion (blink.cmp)
- Obsidian vault integration with wiki-link completion
- Lectic AI multiparty conversations with 5 persona modes:
  - **Business**: Consultant, Marketing, Finance, Product
  - **Writing**: Researcher, Writer, Editor
  - **Workshop**: Designer, Scholar, Scribe
  - **Homie**: Aspirational generalist (philosophy, conflict resolution, systemic change)
  - **Nomad**: Travel planner & digital nomadism expert
  - Switch personas mid-conversation with `:ask[Name]` directive
  - Context files via `prompt: file:/absolute/path` (use `file:` abbreviation for quick entry)
- Markdown rendering and preview
- Spell checking enabled by default

### LaTeX Publishing
- VimTeX integration with forward/inverse search
- LaTeX-specific snippets via LuaSnip
- Omni-completion for citations and references
- PDF compilation and viewing

### Development
- LSP support (lua-language-server, etc.)
- Treesitter syntax highlighting
- Neo-tree file explorer
- Git integration (Gitsigns, LazyGit via Snacks)
- Telescope fuzzy finding

### UI & Navigation
- Which-key command palette
- Bufferline tab management
- Snacks.nvim utilities (dashboard, notifications, zen)
- Gruvbox color scheme

## Installation

1. **Backup existing config**:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone this repository**:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

3. **Install dependencies**:
   - Neovim >= 0.9.0
   - Nerd Font (for icons)
   - ripgrep (for Telescope)
   - LaTeX distribution (for VimTeX)

4. **Launch Neovim**:
   ```bash
   nvim
   ```
   Lazy.nvim will automatically install plugins on first launch.

5. **Set up Lectic** (optional):
   ```bash
   cd ~/.local/share/nvim/lazy/lectic/extra/lectic.nvim
   npm install
   ```

## Key Mappings

See [CHEATSHEET.md](CHEATSHEET.md) for complete keybinding reference.

**Leader key**: `<Space>`

**Quick reference**:
- `<leader>e` - Toggle file explorer
- `<leader>mz` - Toggle zen mode
- `<leader>mn` - Create new Lectic file (Homie)
- `<leader>ml` - Run Lectic on current file
- `<leader>mc` - Insert context link
- `<leader>mp` - Switch Lectic persona
- `<leader>mt` - Toggles submenu (completion, folding)
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>gg` - Open LazyGit

## Plugin List

### Core
- **lazy.nvim** - Plugin manager with lazy loading
- **plenary.nvim** - Lua utility functions (dependency for many plugins)

### Completion & Snippets
- **blink.cmp** - Fast completion engine
- **blink.compat** - Compatibility layer for nvim-cmp sources
- **LuaSnip** - Snippet engine
- **friendly-snippets** - Community snippet collection

### LSP & Treesitter
- **nvim-lspconfig** - LSP configuration
- **nvim-treesitter** - Syntax highlighting and parsing
- **mason.nvim** - LSP/DAP/linter installer

### Writing & Note-Taking
- **Lectic** - AI writing assistant with frontmatter support
- **obsidian.nvim** - Obsidian vault integration
- **render-markdown.nvim** - Live markdown rendering
- **markdown-preview.nvim** - Markdown preview in browser
- **vimtex** - LaTeX support

### Navigation & UI
- **telescope.nvim** - Fuzzy finder
- **neo-tree.nvim** - File explorer
- **which-key.nvim** - Keybinding guide
- **snacks.nvim** - UI utilities (dashboard, zen, notifications)
- **bufferline.nvim** - Buffer tabs

### Git
- **gitsigns.nvim** - Git signs in gutter
- **snacks.nvim (lazygit)** - LazyGit integration

### Editing
- **nvim-surround** - Surround text objects
- **mini.comment** - Commenting
- **nvim-autopairs** - Auto-close brackets
- **nvim-ts-autotag** - Auto-close HTML tags

### Appearance
- **gruvbox.nvim** - Color scheme
- **lualine.nvim** - Statusline
- **mini.hipatterns** - Highlight color codes

## Configuration Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── core/               # Core configuration
│   │   ├── options.lua     # Vim options
│   │   ├── keymaps.lua     # Non-leader keymaps
│   │   └── functions.lua   # Utility functions
│   ├── bootstrap.lua       # Lazy.nvim setup
│   └── plugins/            # Plugin configurations
│       ├── lsp/            # LSP-related plugins
│       └── *.lua           # Individual plugin configs
├── after/
│   └── ftplugin/           # Filetype-specific settings
├── snippets/               # Custom LuaSnip snippets
└── .claude/                # Development workflow system
    ├── commands/           # Workflow commands (research, plan, implement)
    ├── agents/             # AI agent behaviors
    ├── specs/              # Implementation documentation
    └── docs/               # System documentation
```

## Development Workflow

This configuration includes a `.claude/` documentation system for planning and implementing changes. It prevents work loss by documenting progress incrementally.

**Quick workflow**:
1. `/research` - Investigate approaches
2. `/plan` - Create implementation plan
3. `/implement` - Execute plan with incremental docs
4. `/document` - Update README/CHEATSHEET

See [.claude/docs/getting-started.md](.claude/docs/getting-started.md) for complete documentation system guide.

## Configuration Philosophy

**Writing-First**: Completion is context-aware, disabling in zen mode for distraction-free writing.

**Lazy Loading**: Plugins load on-demand to maintain fast startup times.

**Standards-Based**: All changes follow documented standards in `.claude/NVIM_STANDARDS.md`.

**Incremental**: Changes are planned, implemented in phases, and documented comprehensively.

## License

MIT License - feel free to use and modify for your own configuration.

## Acknowledgments

- Based on initial fork from [Ben's neotex config](https://github.com/benbrastmckie/.config)
- Lectic AI writing system by Graham Leach-Krouse
- Claude Code documentation system inspired by Ben's `.claude/` workflow
