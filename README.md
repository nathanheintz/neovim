# Neovim Configuration

A second brain and zettelkasten Neovim configuration optimized for AI-assisted note taking, writing, and publishing and [Ghost](https://github.com/TryGhost/Ghost) theme development. Key plugins include: [Obsidian](https://github.com/obsidian-nvim/obsidian.nvim), [Lectic AI](https://github.com/gleachkr/Lectic), and [LaTeX](https://github.com/lervag/vimtex).

## Overview
This configuration prioritizes:
- **Writing workflow**: Zen mode, smart completion, spell checking
- **Note-taking**: Obsidian vault integration with wiki-link completion
- **AI assistance**: Lectic writing assistant with obsidian-compatible frontmatter support
- **Publishing**: LaTeX with VimTeX, markdown presentations
- **Development**: Ghost theme development (HTML/CSS/Handlebars/JS)

## Features
### Writing & Note-Taking
- Zen mode for distraction-free writing (Snacks.nvim)
- Speech-to-text dictation with [vocal.nvim](https://github.com/kyza0d/vocal.nvim) (local Whisper model, fully offline)
- Markdown rendering and preview
- Smart per-filetype completion (blink.cmp)
- Obsidian vault integration with wiki-link completion
- Lectic AI assistance with 12 personas:
  - **Business Personas**: Consultant, Marketing, Finance, Product
  - **Writing Personas**: Researcher, Writer, Editor
  - **Workshop Design Personas**: Designer, Scholar, Scribe
  - **Homie**: A helpful generalist (philosopher, psychologist, designer, writer)
  - **Nomad**: Travel planner & digital nomadism expert
  - Switch personas mid-conversation with <leader>mp and select your persona - frontmatter will update, preserving Obsidian fields and previous conversation
  - Context files added to conversation via simple markdown link syntax.  

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
- Color schemes auto-switch based on cwd - see `lua/core/options.lua`

## Known Issues & Patches
### Which-Key + Kitty Terminal Bug
**Issue**: When using Kitty terminal, pressing `<Space>` (leader key) while a which-key menu is open causes corrupted key handling. The space keypress gets converted to the first-tier menu character (e.g., pressing `<leader>a<Space>` executes dashboard action `a` instead of closing the menu).
**Root Cause**: Kitty's enhanced keyboard protocol sends special terminal codes that get corrupted when which-key uses `nvim_replace_termcodes()` + `nvim_feedkeys()` to handle unmapped keys.
**Fix**: This config includes an automatic patch (applied via `vim.schedule()` when which-key loads) that modifies which-key's `state.lua` to treat `<Space>` the same as `<Esc>` - closing the menu cleanly instead of attempting to feed the key back.

**Location**: `lua/plugins/which-key.lua` lines 71-99

**Behavior**: Pressing `<Space>` while any which-key menu is open will now close the menu (same as pressing `<Esc>`).

**Known Issue**: After running `:Lazy update` to update which-key, the compiled bytecode cache may prevent the patch from taking effect. If Space starts causing issues again after an update:
1. Delete the cache file: `rm ~/.cache/nvim/luac/%2fUsers%2fnathanheintz%2f.local%2fshare%2fnvim%2flazy%2fwhich-key.nvim%2flua%2fwhich-key%2fstate.luac`
2. Restart nvim

**Future**: Auto-deletion of cache file after patching is commented out at lines 88-91, pending testing.

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

*Writing & AI*:
- `<leader>mz` - Toggle zen mode (focus/unfocus window)
- `<leader>md` - Dictate (speech-to-text)
- `<leader>mn` - Create new Lectic file (Homie)
- `<leader>ml` - Run Lectic on current file
- `<leader>mc` - Insert context link
- `<leader>mp` - Switch Lectic persona

*Search & Navigation* (Second Brain):
- `<leader>ff` - Find files in entire Second Brain
- `<leader>fb` - Grep entire Second Brain
- `<leader>fz` - Grep zettelkasten
- `<leader>fl` - Grep literature notes
- `<leader>fd` - Dev search submenu (cwd, config)
- `<leader>e` - Toggle file explorer

*Window & Sessions*:
- `<leader>wl/wh/wj/wk` - Split window (right/left/below/above)
- `<leader>wx` - Close window
- `<leader>ss/sl` - Save/load session
- `Ctrl+h/j/k/l` - Navigate windows

*Git*:
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
- **vocal.nvim** - Speech-to-text dictation (local Whisper model)
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
- **nightfox.nvim** - Color schemes (carbonfox, terafox, nightfox)
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
This configuration includes a `.claude/` documentation system for planning and implementing changes.

In claude code, run `/init` with the nvim config as the cwd to initialize the workflow. The agent will: 
  - Review project context files 
  - Abide by session protocols
  - Build and design collaboratively with the user
  - Summarize, document and commit work progressively to prevent work loss

See `.claude/SESSION_PROTOCOL.md` for complete documentation system guide.

## License
MIT License - feel free to use and modify for your own configuration.

## Acknowledgments
- Originally forked and customized based on [Ben's neotex config](https://github.com/benbrastmckie/.config)
