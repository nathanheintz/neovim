# Maintenance Log - Nvim Config

**Purpose**: Track small fixes, updates, and maintenance tasks outside of main feature development.

---

## 2025-11-10: LSP Config Migration

**Issue**: Deprecation warning when opening files:
```
The `require('lspconfig')` "framework" is deprecated, use vim.lsp.config
(see :help lspconfig-nvim-0.11) instead.
Feature will be removed in nvim-lspconfig v3.0.0
```

**Root cause**: Using old lspconfig API (`lspconfig["server"].setup()`) instead of new Neovim 0.11+ built-in API.

**Solution**: Migrated to `vim.lsp.config.*` and `vim.lsp.enable()` API.

**File modified**: `lua/plugins/lsp/lspconfig.lua`

**Changes**:
- Removed: `local lspconfig = require("lspconfig")`
- Changed all server configs from:
  ```lua
  lspconfig["server"].setup({
    capabilities = default,
    settings = {...}
  })
  ```
- To:
  ```lua
  vim.lsp.config.server = {
    capabilities = default,
    settings = {...}
  }
  vim.lsp.enable('server')
  ```

**Servers migrated**:
- pyright
- texlab
- lua_ls
- html
- emmet_ls

**Status**: ✅ Complete - deprecation warning resolved

---

## 2025-11-11: Completion Toggles & Snippet Cleanup

**Issue**: "Massive strings of related words" appearing in markdown completion from buffer completion pulling words from all open Second Brain files. Also, old "lectic" snippet with outdated Ben's config triggering on single character "e".

**Root cause**:
1. Buffer completion enabled by default in markdown files
2. Old lectic snippet with multi-party frontmatter (deprecated)
3. Snippets triggering after only 1 character

**Solution**: Implemented completion toggles and cleaned up snippets.

**Files modified**:
- `lua/plugins/lsp/blink-cmp.lua`
- `lua/plugins/which-key.lua`
- `snippets/markdown.snippets`

**Changes**:

1. **Added completion toggle functions** (blink-cmp.lua lines 30-52):
   - `_G.toggle_buffer_completion()` - Toggle buffer completion
   - `_G.toggle_obsidian_completion()` - Toggle Obsidian completion
   - `_G.toggle_luasnip_completion()` - Toggle snippet completion
   - Global variables store state: `vim.g.blink_buffer_enabled`, etc.

2. **Modified buffer provider** (blink-cmp.lua lines 142-155):
   - OFF by default in markdown/lectic.markdown files
   - ON by default in other file types (code files)
   - Respects toggle state

3. **Modified snippets provider** (blink-cmp.lua line 164):
   - Changed `min_keyword_length` from 1 to 3
   - Snippets now require 3 characters before triggering
   - Respects toggle state

4. **Modified obsidian provider** (blink-cmp.lua line 179):
   - Respects toggle state

5. **Updated which-key toggles** (which-key.lua lines 359-368):
   - Removed `<leader>mtc` - toggle spell completion (not needed, use Ctrl-s)
   - Kept `<leader>mtb` - toggle buffer completion
   - Kept `<leader>mto` - toggle obsidian completion
   - Kept `<leader>mtx` - toggle snippet completion

6. **Deleted old lectic snippet** (markdown.snippets):
   - Removed outdated multi-party frontmatter snippet
   - Replaced with empty template for future snippets

**Default behavior on nvim start**:
- ✅ LSP: ON
- ✅ Path: ON
- ✅ Snippets: ON (but requires 3 chars)
- ✅ Obsidian: ON (markdown only)
- ❌ Buffer: OFF in markdown, ON in code files

**Toggle keybindings** (`<leader>mt`):
- `b` - Toggle buffer completion
- `o` - Toggle Obsidian completion
- `x` - Toggle snippet completion

**Status**: ✅ Complete - buffer completion noise eliminated, snippets cleaned up

**Documentation**: See `.claude/specs/008_completion_toggles/` for full analysis and implementation log
