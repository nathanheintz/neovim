# Neovim Configuration Structure

**Last Updated**: 2025-11-10

## Quick Reference

**Looking for specific code?**
- Keybindings → `lua/plugins/which-key.lua`
- Dashboard shortcuts → `lua/plugins/snacks/dashboard.lua`
- Lectic personas → `lua/plugins/lectic.lua` (init section)
- Colorscheme → `lua/plugins/colorscheme.lua`
- Plugin list → All `.lua` files in `lua/plugins/`

## Directory Structure

```
~/.config/nvim/
├── init.lua                           # Entry point (loads core + bootstrap)
├── lua/
│   ├── bootstrap.lua                  # Lazy.nvim setup
│   ├── core/                          # Core vim settings
│   │   ├── options.lua
│   │   ├── keymaps.lua
│   │   └── functions.lua
│   └── plugins/                       # Plugin configurations
│       ├── lectic.lua                 # Lectic AI + personas
│       ├── which-key.lua              # Keybinding menus
│       ├── colorscheme.lua            # Theme
│       ├── obsidian.lua               # Obsidian integration
│       ├── snacks.lua                 # Snacks.nvim main config
│       ├── snacks/
│       │   └── dashboard.lua          # Dashboard config
│       ├── lsp/                       # LSP-related plugins
│       │   ├── lspconfig.lua
│       │   ├── mason.lua
│       │   └── blink-cmp.lua
│       └── ... (other plugin files)
├── after/
│   └── ftplugin/                      # Filetype-specific settings
├── snippets/                          # Custom snippets
└── .claude/                           # Development workflow
    ├── commands/                      # Workflow commands
    ├── agents/                        # AI agent behaviors
    ├── specs/                         # Implementation docs
    │   └── 001_neovim_second_brain/
    │       ├── SPEC.md                # Full specification
    │       └── SESSION_LOG.md         # Change history
    └── docs/                          # System documentation
```

## How It Works

### 1. Startup Flow

```
Neovim starts
    ↓
init.lua runs
    ↓
Loads lua/core/ (options, keymaps, functions)
    ↓
Loads lua/bootstrap.lua
    ↓
bootstrap.lua sets up Lazy.nvim
    ↓
Lazy imports lua/plugins/ and lua/plugins/lsp/
    ↓
Each plugin file is loaded
```

### 2. Plugin Loading with Lazy.nvim

Each file in `lua/plugins/*.lua` is a plugin specification:

```lua
return {
  "author/plugin-name",
  lazy = true,              -- Don't load immediately
  ft = { "markdown" },      -- Load for these filetypes

  init = function()
    -- Runs IMMEDIATELY on startup
    -- Use for: keybindings, global functions, commands
  end,

  config = function()
    -- Runs ONLY when plugin loads
    -- Use for: plugin setup, autocmds, filetype settings
  end,
}
```

**Key difference**:
- `init` = runs at startup (even if plugin lazy-loads)
- `config` = runs when plugin actually loads

### 3. Where Different Things Live

| What | Where | Why |
|------|-------|-----|
| Global functions (like `CreateNewLecticFile`) | Plugin's `init` section | Need to be available before plugin loads |
| Plugin setup/configuration | Plugin's `config` section | Only needed when plugin loads |
| Which-key menus | `lua/plugins/which-key.lua` | All keybindings in one place |
| Dashboard shortcuts | `lua/plugins/snacks/dashboard.lua` | Dashboard-specific config |
| Filetype settings | `after/ftplugin/` | Runs after filetype detected |

## Example: Lectic Plugin

**File**: `lua/plugins/lectic.lua`

```lua
return {
  "gleachkr/Lectic",
  lazy = true,
  ft = { "markdown", "lectic.markdown" },

  init = function()
    -- Persona functions defined here
    -- Available immediately on startup
    -- Dashboard can call CreateNewLecticFile()
    function _G.CreateNewLecticFile(persona)
      -- ... persona template code ...
    end
  end,

  config = function()
    -- Plugin setup happens here
    -- Only runs when opening markdown file
    require("lectic").setup()
  end,
}
```

## Common Tasks

### Adding a New Plugin

1. Create `lua/plugins/plugin-name.lua`
2. Add plugin spec:
```lua
return {
  "author/plugin-name",
  config = function()
    require("plugin-name").setup({
      -- your settings
    })
  end
}
```
3. Restart Neovim or run `:Lazy sync`

### Adding a Keybinding

Edit `lua/plugins/which-key.lua`:
```lua
["<leader>x"] = { "<cmd>SomeCommand<CR>", "description" }
```

### Adding Dashboard Shortcut

Edit `lua/plugins/snacks/dashboard.lua`:
```lua
{ icon = " ", key = "x", desc = "My Action", action = ":MyCommand" }
```

### Changing Colorscheme

Edit `lua/plugins/colorscheme.lua`:
```lua
return {
  "author/colorscheme-name",
  priority = 1000,
  config = function()
    vim.cmd("colorscheme theme-name")
  end,
}
```

## Debugging

### Check if plugin loaded
```vim
:Lazy
```

### Check loaded modules
```vim
:lua print(vim.inspect(package.loaded))
```

### Check if function exists
```vim
:lua print(CreateNewLecticFile)
```

### Reload config
```vim
:source $MYVIMRC
" or restart Neovim
```

## Documentation System

All changes are tracked in `.claude/specs/001_neovim_second_brain/`:
- `SPEC.md` - Full specification and requirements
- `SESSION_LOG.md` - Chronological change history
- Each session documents: goals, changes, decisions, next steps

See [.claude/docs/getting-started.md](getting-started.md) for workflow documentation.
