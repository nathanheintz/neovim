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
