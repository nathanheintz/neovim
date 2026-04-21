# Neovim Configuration

A second brain and zettelkasten Neovim configuration optimized for AI-assisted note taking, writing, and publishing and [Ghost](https://github.com/TryGhost/Ghost) theme development. Key plugins include: [Obsidian](https://github.com/obsidian-nvim/obsidian.nvim), [Lectic AI](https://github.com/gleachkr/Lectic), and [LaTeX](https://github.com/lervag/vimtex).

## Overview
This configuration prioritizes:
- **Writing workflow**: Zen mode, smart completion, spell checking, Pomodoro timer
- **Note-taking**: Obsidian vault integration with wiki-link completion
- **AI assistance**: Lectic writing assistant with obsidian-compatible frontmatter support
- **Publishing**: LaTeX with VimTeX, markdown presentations
- **Development**: Ghost theme development (HTML/CSS/Handlebars/JS)

## Features
### Writing & Note-Taking
- Zen mode for distraction-free writing (Snacks.nvim)
- Speech-to-text dictation with [vocal.nvim](https://github.com/kyza0d/vocal.nvim) (local Whisper model, fully offline)
- Markdown rendering and preview
- Dynamic section folding via nvim-ufo — folds update as you type, fold/unfold with `<leader>mf`
- Smart per-filetype completion (blink.cmp)
- Obsidian vault integration with wiki-link completion
- Lectic AI assistance with 13 personas in true multi-party mode (v0.0.3):
  - **Business**: Consultant, Marketing, Finance, Product
  - **Research & Writing**: Researcher (with paper_search MCP tool), Writer, Editor
  - **Workshop & Design**: Designer, Scholar, Scribe
  - **News & Intelligence**: Newshound (live RSS feed scanning + full article fetch — see below)
  - **General**: Homie, Traveler
  - All personas defined globally in `~/.config/lectic/lectic.yaml` (active via `LECTIC_CONFIG` Fish env var) — frontmatter only needs `name: Scholar` (Scholar is default)
  - Switch personas mid-conversation with `<leader>mp` — inserts `:ask[Name]` directive at cursor
  - Context files added to conversation via markdown link syntax in document body

### Newshound: Live News Briefing
The Newshound persona scans curated RSS feeds and reads full articles to produce sourced geopolitical briefings. Powered by two exec tools:
- **`scan-news`** (`~/.local/bin/scan-news`) — fetches 10 curated feeds concurrently, matches keywords with word-boundary regex, returns title/date/source/URL/excerpt. Feeds: Guardian, Intercept, Drop Site, Al Jazeera, Grayzone, +972, Crisis Group, WaPo, DoD Contracts, State Dept.
- **`fetch-page`** (`~/.local/bin/fetch-page`) — fetches any URL and returns stripped article text (up to 50k chars). Both use a dedicated Python virtualenv at `~/.local/share/scan-news-env`.

Full feed library (35+ sources) curated in `~/SecondBrain/4-Resources/RSS/newshound-feeds.opml`. Switch to Newshound with `<leader>mpn`.

### LaTeX Publishing
- VimTeX integration with forward/inverse search
- LaTeX-specific snippets via LuaSnip
- Omni-completion for citations and references
- PDF compilation and viewing
- Document templates: Personal Letter, Professional Letter (with letterhead), Simple Book

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
**Issue**: When using Kitty terminal, pressing `<Space>` while a which-key menu is open causes corrupted key handling — the space keypress triggers a dashboard action instead of closing the menu.

**Root Cause**: Kitty's enhanced keyboard protocol sends special terminal codes that get corrupted when which-key uses `nvim_replace_termcodes()` + `nvim_feedkeys()` to handle unmapped keys.

**Fix**: This config applies an in-memory monkey-patch to `which-key.state.check()` that treats `<Space>` the same as `<Esc>`, closing the menu cleanly. The patch runs every time which-key loads and never modifies any plugin files on disk.

**Location**: `lua/plugins/which-key.lua`

**Behavior**: Pressing `<Space>` while any which-key menu is open closes the menu (same as `<Esc>`). The initial `<Space>` keypress that opens menus is unaffected.

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
5. **Install the Lectic binary** (required for Lectic AI):
   ```bash
   curl -fsSL https://raw.githubusercontent.com/gleachkr/lectic/main/install.sh | sh
   ```
   To update the binary in future, rerun the same command.
## Key Mappings

See [CHEATSHEET.md](CHEATSHEET.md) for complete keybinding reference.

**Leader key**: `<Space>`

**Quick reference**:

*Writing & AI*:
- `<leader>mz` - Toggle zen mode (focus/unfocus window)
- `<leader>at` - Pomodoro timer submenu (start, pause, resume, stop, sessions)
- `<leader>md` - Dictate (speech-to-text)
- `<leader>mn` - Create new Lectic file (Scholar)
- `<leader>mf` - Add Lectic frontmatter to existing Obsidian doc
- `<leader>ml` - Run Lectic on current file
- `<leader>mc` - Insert context link
- `<leader>mp` - Switch Lectic persona
- `<leader>mtt` - Toggle table mode (live markdown table editing)

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
- **pomo.nvim** - Pomodoro timer with lualine statusline integration and system notifications
- **vocal.nvim** - Speech-to-text dictation (local Whisper model)
- **obsidian.nvim** - Obsidian vault integration
- **render-markdown.nvim** - Live markdown rendering
- **markdown-preview.nvim** - Markdown preview in browser
- **vimtex** - LaTeX support (PDF viewer: Skim)

### Sessions
- **resession.nvim** - Session management (save/load/rename sessions per directory)

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
│   ├── snippets/           # Lua-native LuaSnip snippets
│   └── plugins/            # Plugin configurations
│       ├── lsp/            # LSP-related plugins
│       └── *.lua           # Individual plugin configs
├── after/
│   └── ftplugin/           # Filetype-specific settings
├── snippets/               # SnipMate-format snippets
├── templates/              # LaTeX document templates
└── .claude/                # Development workflow system
    ├── commands/           # Workflow commands (research, plan, implement)
    ├── agents/             # AI agent behaviors
    ├── specs/              # Implementation documentation
    └── docs/               # System documentation
```

## Claude Code Integration

This config runs claude code via the claudecode.nvim plugin with cwd-specific context loading allowing you to separate config development and zettelkasten maintenance/creative work. Shared global behavior, skills and memory persist across contexts.

**Context layers:**
- Global `~/.claude/CLAUDE.md` — master map; @imports universal behavior rules and profile
- `~/.config/nvim/CLAUDE.md` — this repo's full context, auto-loaded when CWD is here
- On-demand: plugin docs fetched via `Read` or `WebFetch` when working on a specific plugin

**Global infrastructure (`~/.claude/`):**
- `settings.json` — global read permissions; `autoMemoryDirectory` pointing to shared memory pool
- `skills/init/SKILL.md` — `/init` skill works from any CWD; loads project history and session protocol
- `agents/librarian.md` — vault operations: decomposing AI writing sessions into atomic Zettelkasten notes, suggesting directional links between notes (North/South = abstraction level, East/West = related concepts), and auditing the vault for orphaned or under-linked notes
- `agents/ghost-dev.md` — Ghost theme development specialist

See `.claude/SESSION_PROTOCOL.md` for git protocol and documentation standards.

## License
MIT License - feel free to use and modify for your own configuration.

## Acknowledgments
- Originally forked and customized based on [Ben's neotex config](https://github.com/benbrastmckie/.config)
