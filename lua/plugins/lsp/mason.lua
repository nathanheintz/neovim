return {
  "williamboman/mason.nvim",
  ft = { "py", "html", "handlebars", "hbs", "js", "ts", "lua", "css", "scss", "sass", "json" },
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- Define a replacement for the missing vim.lsp.enable function
    -- Use a more silent replacement that doesn't show popups
    if not vim.lsp.enable then
      vim.lsp.enable = function(server_name)
        -- This is a no-op replacement that doesn't cause errors
        -- Using the lowest notification level to avoid popup spam
        -- vim.notify("Ignoring call to missing vim.lsp.enable for " .. server_name, vim.log.levels.TRACE)
      end
    end
    
    -- Basic mason setup
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })
    
    -- Simple mason-lspconfig setup
    require("mason-lspconfig").setup({
      ensure_installed = {
        "pyright",
        "html",
        "cssls",
        "jsonls",
        "emmet_ls",
      },
      automatic_installation = true,
    })
    
    -- Set up formatters and linters
    require("mason-tool-installer").setup({
      ensure_installed = {
        "stylua",
        "isort",
        "black",
        "pylint",
      },
    })
  end,
}
