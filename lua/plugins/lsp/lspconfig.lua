return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    -- blink.cmp provides LSP capabilities natively (replaces cmp-nvim-lsp)
    local default = require('blink.cmp').get_lsp_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.HINT] = "󰠠",
          [vim.diagnostic.severity.INFO] = "",
        },
      },
    })

    -- configure python server
    vim.lsp.config.pyright = {
      capabilities = default,
    }
    vim.lsp.enable('pyright')

    -- configure texlab (LaTeX LSP) server
    vim.lsp.config.texlab = {
      capabilities = default,
      settings = {
        texlab = {
          build = {
            onSave = true,
          },
          chktex = {
            onEdit = false,
            onOpenAndSave = false,
          },
          diagnosticsDelay = 300,
        },
      },
    }
    vim.lsp.enable('texlab')

    -- configure lua server (with special settings)
    vim.lsp.config.lua_ls = {
      capabilities = default,
      settings = {
        Lua = {
          -- make the language server recognize "vim" global
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            -- make language server aware of runtime files
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    }
    vim.lsp.enable('lua_ls')

    -- configure html server with enhanced handlebars support
    vim.lsp.config.html = {
      capabilities = default,
      filetypes = { "html", "handlebars", "hbs" },
      init_options = {
        configurationSection = { "html", "css", "javascript" },
        embeddedLanguages = {
          css = true,
          javascript = true
        },
        provideFormatter = true,
      },
      settings = {
        html = {
          format = {
            templating = true,
            wrapLineLength = 120,
            wrapAttributes = 'auto',
          },
          hover = {
            documentation = true,
            references = true
          },
        }
      }
    }
    vim.lsp.enable('html')

    -- configure emmet_ls for enhanced HTML/Handlebars editing
    vim.lsp.config.emmet_ls = {
      capabilities = default,
      filetypes = { "html", "handlebars", "hbs", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
      init_options = {
        html = {
          options = {
            ["bem.enabled"] = true,
          },
        },
      }
    }
    vim.lsp.enable('emmet_ls')
  end,
}
