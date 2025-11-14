# Neovim Configuration Standards

This document defines coding and documentation standards for the nvim configuration. All `/plan`, `/implement`, and `/document` commands reference these standards.

## Code Standards

### Lua Code Style

**Formatting**:
- Indentation: 2 spaces, expandtab
- Line length: 100 characters (soft limit)
- Naming: `snake_case` for variables and functions
- File naming: `kebab-case.lua` for plugin configs

**Structure**:
```lua
-- Plugin configuration template
return {
  "author/plugin-name",
  event = { "BufRead", "BufNewFile" },  -- Lazy load when appropriate
  dependencies = {
    "dependency/plugin",
  },
  config = function()
    require('plugin').setup({
      -- Configuration here
    })
  end,
  opts = {
    -- Options here
  }
}
```

**Comments**:
- Use `--` for single-line comments
- Add section headers for major blocks
- Document non-obvious behavior

### Configuration Organization

**Plugin Files**:
- Location: `lua/plugins/`
- LSP plugins: `lua/plugins/lsp/`
- Group related functionality in single files
- Use lazy.nvim's lazy loading appropriately

**Core Files**:
- Options: `lua/core/options.lua`
- Keymaps: `lua/core/keymaps.lua`
- Functions: `lua/core/functions.lua`
- Bootstrap: `lua/bootstrap.lua`

## Documentation Standards

### README.md (Project Root)

**Purpose**: Document current state of the configuration

**Required Sections**:
```markdown
# Neovim Configuration

## Overview
Brief description of this config's purpose

## Features
- Feature category 1
  - Specific feature
  - Specific feature
- Feature category 2

## Installation
How to install and set up

## Plugin List
Organized by category with brief descriptions

## Key Mappings
Link to CHEATSHEET.md for details

## Configuration
Notable configuration decisions
```

**Style**:
- Present tense ("provides", not "will provide")
- No temporal markers ("now supports" → "supports")
- No emojis
- UTF-8 encoding only

### CHEATSHEET.md (Project Root)

**Purpose**: Document how to use features (keybindings, commands, workflows)

**Structure**:
```markdown
# Nvim Configuration Cheatsheet

## Leader Key Menus

### MENU NAME (<leader>x)
| Key | Command | Description |
|-----|---------|-------------|
| <leader>xa | command() | Action description |

## Special Workflows

### Workflow Name
1. Step one
2. Step two
```

**Style**:
- Tables for keybindings
- Step-by-step for workflows
- Group by functionality
- Keep synchronized with actual which-key configuration

### Commit Messages

**Format**:
```
<type>: <short summary>

<optional detailed description>
```

**Types**:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation only
- `refactor:` - Code refactoring
- `chore:` - Maintenance tasks

**Examples**:
```
feat: add Obsidian wiki-link completion

Configure obsidian provider via blink.compat for nvim-cmp source
```

```
fix: correct zen mode backdrop opacity

Change blend from 100 to 0 (0 = opaque, 100 = transparent)
```

## Writing-Specific Standards

### Filetype-Specific Settings

**Markdown** (`markdown`, `lectic.markdown`):
- Spell check: enabled
- Concealment: level 2 for lectic, level 0 for regular markdown
- Completion: context-aware (disable in zen mode)
- Wrap: enabled with linebreak

**LaTeX** (`tex`):
- VimTeX integration required
- Omni-completion via VimTeX
- Snippet priority over LSP

### Zen Mode Configuration

**When Active**:
- No completion menu
- No line numbers
- No status line
- Spell checking enabled
- Centered text (90 width)
- Full backdrop opacity (blend = 0)

**Global Variable**:
```lua
vim.g.zen_mode_enabled = true  -- Set by Snacks.nvim
```

Used by blink.cmp to disable completion:
```lua
menu = {
  auto_show = function()
    return not vim.g.zen_mode_enabled
  end,
}
```

## Plugin-Specific Standards

### Lectic

**Frontmatter**:
- Compatible with Obsidian frontmatter
- Lectic fields: `interlocutor`, `memories`
- Obsidian fields: `id`, `aliases`, `tags`
- No gaps or commented sections (causes Obsidian to overwrite)

**Filetype**: `lectic.markdown` for `.lec` files

### Obsidian

**Auto-loading**: Manual via `:Lazy load obsidian` (not auto-loaded)

**Completion**: Via blink.compat wrapper
```lua
providers = {
  obsidian = {
    name = 'obsidian',
    module = 'blink.compat.source',
    enabled = function()
      return vim.bo.filetype == 'markdown'
    end,
  },
}
```

### Blink.cmp

**Per-Filetype Sources**:
```lua
per_filetype = {
  markdown = { 'lsp', 'path', 'buffer', 'snippets', 'obsidian' },
  ['lectic.markdown'] = { 'lsp', 'path', 'buffer', 'snippets' },
  tex = { 'lsp', 'snippets', 'omni', 'path', 'buffer' },
}
```

**Provider Configuration**: All nvim-cmp sources must use blink.compat wrapper

## Testing Standards

### Before Committing

**Required Checks**:
- [ ] Neovim loads without errors
- [ ] Affected plugins load correctly
- [ ] Keybindings work as expected
- [ ] No breaking changes to existing workflows

**For Plugin Changes**:
- [ ] Test with actual use case (open file, trigger completion, etc.)
- [ ] Verify lazy loading still works
- [ ] Check for error messages in `:messages`

### Error Handling

**If errors occur**:
1. Read the full error message
2. Check file paths and require statements
3. Verify plugin is installed (`:Lazy`)
4. Test in isolation if needed
5. Document workarounds in commit message

## Development Workflow

### Adding New Features

1. **Research** (if needed): Use `/research` to investigate approaches
2. **Plan**: Use `/plan` to create structured implementation plan
3. **Implement**: Use `/implement` to execute plan with incremental docs
4. **Document**: Use `/document` to update README and cheatsheet

### Modifying Existing Features

1. Check current behavior first
2. Update plan if one exists (`/revise`)
3. Make changes incrementally
4. Test after each change
5. Update documentation

## Reference

**Commands**: See `.claude/commands/` for workflow definitions

**Agents**: See `.claude/agents/` for specialized behaviors

**Examples**: See `.claude/specs/*/summaries/` for implementation patterns
