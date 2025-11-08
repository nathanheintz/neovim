return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    -- Get lspconfig module
    local lspconfig = require("lspconfig")
    
    -- Get capabilities from cmp-nvim-lsp if available
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    if package.loaded["cmp_nvim_lsp"] then
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    end
    
    -- Create a filetype detection for handlebars
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = { "*.hbs", "*.handlebars" },
      callback = function()
        vim.bo.filetype = "handlebars"
      end,
    })
    
    -- Configure HTML server for Handlebars
    lspconfig.html.setup({
      capabilities = capabilities,
      filetypes = { "html", "handlebars", "hbs" },
      init_options = {
        configurationSection = { "html", "css", "javascript" },
        embeddedLanguages = {
          css = true,
          javascript = true
        },
      },
      -- Print debug info when HTML server attaches
      on_attach = function(client, bufnr)
        print("HTML LSP server attached to buffer " .. bufnr)
      end,
    })
    
    -- Also set up emmet-ls for Handlebars
    lspconfig.emmet_ls.setup({
      capabilities = capabilities,
      filetypes = { "html", "css", "scss", "javascript", "handlebars", "hbs" },
      -- Print debug info when Emmet server attaches
      on_attach = function(client, bufnr)
        print("Emmet LSP server attached to buffer " .. bufnr)
      end,
    })
  end,
}
