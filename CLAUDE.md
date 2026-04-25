# Neovim Configuration

**Purpose**: Writing and publishing-focused Neovim configuration.
**Forked from**: Ben's NeoTex config — diverged significantly. Not academic LaTeX-focused.

This config is the tool that drives the SecondBrain experience. Changes here have downstream
effects on vault behavior: rendering, keymaps, wiki-link completion, Lectic personas, and
bullet/checkbox behavior in ~/SecondBrain all originate here.

---

## On-Demand Context

When working on a plugin-specific issue, fetch that plugin's raw GitHub docs before advising.
Do not guess at API or configuration details.

- **Lectic docs**: `~/.config/nvim/cheatsheet-readme/lectic-docs-llms-full.md` — local copy.
  Use `Read` on this file. Do not WebFetch. "The Lectic docs" always means this file.
- **Lectic source**: `https://github.com/gleachkr/Lectic`
- **lectic.yaml**: Active config at `~/.config/lectic/lectic.yaml`, loaded via `LECTIC_CONFIG`
  set in Fish config (`set -gx LECTIC_CONFIG ~/.config/lectic/lectic.yaml`). The macOS default
  at `~/Library/Preferences/lectic/lectic.yaml` is stale and NOT read. Separate from this repo.

For deeper project history, run `/init` to load `GLOBAL_SUMMARY_LOG.md`.

---

## Tools We USE

### AI & Writing
- **Lectic** — AI writing assistant, 12 personas, `<leader>mp` switching
- **Obsidian.nvim** — vault integration, wiki-link completion
- **Render-markdown.nvim** — live markdown rendering
- **Markdown-preview.nvim** — browser preview (`<leader>mv`)

### Publishing
- **VimTeX** — LaTeX compilation and viewing
- **Deckset** — markdown presentations (actively used)
- **Pandoc** — document conversion (md → docx, pdf, html)

### Development
- **LSP** — lua-language-server, typescript, etc.
- **Treesitter** — syntax highlighting
- **Blink.cmp** — completion engine with per-filetype source toggles
- **LuaSnip** — snippet engine

### File Management & Git
- **Neo-tree** — file explorer
- **Telescope** — fuzzy finder
- **LazyGit** (via Snacks.nvim) — git interface
- **Gitsigns** — git signs in gutter

### UI & Navigation
- **Which-key** — command palette (with Kitty terminal bug patch)
- **Bufferline** — buffer tabs
- **Snacks.nvim** — dashboard, zen mode, notifications
- **Nightfox** — color schemes (carbonfox, terafox, nightfox — auto-switch by CWD)

### Plugin Management
- **Lazy.nvim** — plugin manager with lazy loading

---

## Tools We DON'T Use

- **Avante** — NOT used (Lectic is the AI writing tool)
- **NixOS tools** — NOT on NixOS (macOS only)
- **Harpoon** — removed
- **Kanban** — removed

---

## Directory Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── core/
│   │   ├── options.lua      # Vim options, colorscheme autocmds, folding
│   │   ├── keymaps.lua      # Non-leader keymaps
│   │   └── functions.lua    # Utility functions
│   ├── bootstrap.lua        # Lazy.nvim setup
│   ├── deprecated/          # Inactive plugins — do not edit
│   └── plugins/
│       ├── lsp/
│       │   └── blink-cmp.lua   # Completion config with toggles
│       ├── snacks/
│       │   └── dashboard.lua
│       ├── which-key.lua    # All leader keybindings
│       ├── lectic.lua       # Lectic personas, SwitchLecticPersona, keymaps
│       ├── colorscheme.lua  # Nightfox plugin
│       └── *.lua            # Individual plugin configs
├── after/
│   └── ftplugin/            # Filetype-specific settings
├── snippets/                # Custom LuaSnip snippets
├── templates/               # LaTeX templates
├── README.md                # Main config documentation
├── CHEATSHEET.md            # User-facing keybinding reference
├── cheatsheet-readme/       # Supplementary docs (Lectic, LazyGit, Deckset, Vim)
└── .claude/                 # Claude documentation system
    ├── GLOBAL_SUMMARY_LOG.md   # Full project history — load with /init
    ├── NVIM_STANDARDS.md       # Coding and documentation standards
    ├── SESSION_PROTOCOL.md     # Git protocol, documentation rules
    └── specs/                  # Per-project plans and reports
        ├── 000_maintenance_debug/
        │   └── MAINTENANCE_LOG.md  # Small fixes, tweaks, debug sessions
        └── NNN_other-projects/
```

---

## Key Configuration Details

### Leader Key
`<Space>` — used for all main commands

### Which-Key Menu Structure
```
<leader>w — WINDOW (splits)
<leader>c — CODE (LSP features)
<leader>a — ACTIONS (misc utilities)
<leader>f — FIND (Telescope)
<leader>g — GIT (LazyGit, Gitsigns)
<leader>m — MARKDOWN & WRITING (Lectic, zen, toggles)
  <leader>mp — Persona switching (12 personas)
  <leader>ms — Surround
  <leader>mt — Toggles (completion, folding)
<leader>s — SESSIONS
<leader>p — PUBLISHING
  <leader>pl — LATEX (VimTeX, latexindent)
  <leader>pc — CONVERT (Pandoc)
  <leader>pt — TEMPLATES
<leader>r — RUN (reload, diagnostics)
<leader>t — TIMERS (Pomodoro)
```

### Lectic Configuration (`lua/plugins/lectic.lua`)

**Plugin loading**: `ft = { "markdown", "lectic.markdown" }` — works in `.md` files (primary)
and `.lec` files. Never suggest changing filetype from `.md` to `.lec` as a fix.

**12 personas**: Consultant, Marketing, Finance, Product, Researcher, Writer, Editor,
Designer, Scholar, Scribe, Homie, Nomad

**Switching**: `<leader>mp[key]` — e.g. `<leader>mpr` = Researcher, `<leader>mpw` = Writer

**Current state**: True multi-party mode working as of 2026-04-12 (project 014). All 12 personas
defined in `~/.config/lectic/lectic.yaml` — the active Lectic system config (loaded via
`LECTIC_CONFIG` in Fish). `SwitchLecticPersona()` inserts `:ask[Name]` at cursor; no frontmatter
mutation. Frontmatter only needs `interlocutor: name: Scholar / prompt:` (empty prompt is fine
— Lectic pulls the full prompt from the system config).

**File creation**: `<leader>mn` creates new Lectic file with Scholar as default persona

**Model**: claude-3-7-sonnet

**Context**: added via markdown links in document body (NOT frontmatter)

**Frontmatter coexistence**: Obsidian and Lectic frontmatter coexist in the same `.md` files
without conflict. Obsidian fields: `id`, `aliases`, `tags`. Lectic fields: `interlocutor`,
`interlocutors`, `memories`. Neither plugin overwrites the other's fields — this is deliberate
and stable. Never remove, restructure, or suggest separating them.

**paper_search**: The Researcher persona has tools defined inline in `~/.config/lectic/lectic.yaml`
— `tools: - name: paper_search / mcp_command: ...`. No `kits:` block; tools go directly in the
persona entry. Do not inline the MCP config in frontmatter.

### Completion Toggles
- Buffer completion: OFF by default in markdown, ON elsewhere
- Obsidian completion: toggle with `<leader>mto`
- Snippet completion: toggle with `<leader>mtx`

### Colorscheme Auto-Switching (`lua/core/options.lua`)
- `~/.config` → carbonfox
- `~/SecondBrain` → terafox
- `~/ghostdev` → nightfox
- Default → terafox

### Known Bugs & Patches
- **Which-key + Kitty**: Space key in submenus triggers dashboard actions
- **Fix**: Auto-patch via `vim.schedule()` treats Space as Escape (`lua/plugins/which-key.lua:71-99`)
- **Cache issue**: After `:Lazy update`, may need to delete `~/.cache/nvim/luac/.../state.luac`
- **Bug report**: `.claude/specs/000_maintenance_debug/bug-reports/which-key-space-feedkeys.md`

---

## File Locations Quick Reference

| What | Where |
|---|---|
| All leader keybindings | `lua/plugins/which-key.lua` |
| Lectic personas + functions | `lua/plugins/lectic.lua` |
| Completion config | `lua/plugins/lsp/blink-cmp.lua` |
| Core options + colorscheme autocmds | `lua/core/options.lua` |
| Dashboard | `lua/plugins/snacks/dashboard.lua` |
| Colorscheme plugin | `lua/plugins/colorscheme.lua` |
| Auto-formatter | `lua/plugins/conform.lua` (format-on-save disabled, manual `<leader>af`) |

---

## Common Patterns

### Adding a New Keybinding
1. Edit `lua/plugins/which-key.lua`
2. Add to appropriate menu group
3. Update `CHEATSHEET.md`
4. Restart nvim

### Adding a New Plugin
1. Create `lua/plugins/plugin-name.lua`
2. Return plugin spec in lazy.nvim format
3. Restart nvim or run `:Lazy install`

### Modifying Lectic Personas
1. Edit `lua/plugins/lectic.lua`
2. Update `all_personas` table
3. Update which-key persona menu if adding a new persona

### Lazy.nvim: init vs config

```lua
return {
  "author/plugin-name",
  lazy = true,
  ft = { "markdown" },

  init = function()
    -- Runs at startup even if plugin hasn't loaded yet
    -- Use for: keybindings, global functions, commands
  end,

  config = function()
    -- Runs only when plugin actually loads
    -- Use for: plugin setup, autocmds, filetype settings
  end,
}
```

---

## Python Environment

- **Python**: Homebrew 3.13 (externally-managed)
- User packages: `~/Library/Python/3.13/lib/python/site-packages/`
- Install with: `pip3 install --user`

---

## Documentation Standards

Follow `.claude/NVIM_STANDARDS.md` for coding conventions. Run `/init` to load
`GLOBAL_SUMMARY_LOG.md` (full project history) and `SESSION_PROTOCOL.md` at session start.
