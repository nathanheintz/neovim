return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lspconfig = require("lspconfig")
    local capabilities = require('blink.cmp').get_lsp_capabilities()

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
      on_attach = function(client, bufnr)
        print("HTML LSP server attached to buffer " .. bufnr)
      end,
    })

    -- Also set up emmet-ls for Handlebars
    lspconfig.emmet_ls.setup({
      capabilities = capabilities,
      filetypes = { "html", "css", "scss", "javascript", "handlebars", "hbs" },
      on_attach = function(client, bufnr)
        print("Emmet LSP server attached to buffer " .. bufnr)
      end,
    })
  end,
}
