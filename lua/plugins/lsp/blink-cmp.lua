return {
  {
    "saghen/blink.compat",
    version = "2.*",
    lazy = true,
    opts = {
      impersonate_nvim_cmp = true,
    },
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "saghen/blink.compat",
      "L3MON4D3/LuaSnip",
      "micangl/cmp-vimtex",
    },
    config = function(_, opts)
      require('blink.cmp').setup(opts)

      -- LaTeX omnifunc setup
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "tex",
        callback = function()
          vim.bo.omnifunc = 'vimtex#complete#omnifunc'
        end,
      })

      -- Initialize completion toggle states
      -- Buffer starts OFF (will be off in markdown, on in other files via enabled function)
      -- Obsidian and snippets start ON
      vim.g.blink_buffer_enabled = false
      vim.g.blink_obsidian_enabled = true
      vim.g.blink_snippets_enabled = true

      -- Global toggle functions for completion sources
      function _G.toggle_buffer_completion()
        vim.g.blink_buffer_enabled = not vim.g.blink_buffer_enabled
        local status = vim.g.blink_buffer_enabled and "enabled" or "disabled"
        vim.notify("Buffer completion " .. status, vim.log.levels.INFO)
      end

      function _G.toggle_obsidian_completion()
        vim.g.blink_obsidian_enabled = not vim.g.blink_obsidian_enabled
        local status = vim.g.blink_obsidian_enabled and "enabled" or "disabled"
        vim.notify("Obsidian completion " .. status, vim.log.levels.INFO)
      end

      function _G.toggle_luasnip_completion()
        vim.g.blink_snippets_enabled = not vim.g.blink_snippets_enabled
        local status = vim.g.blink_snippets_enabled and "enabled" or "disabled"
        vim.notify("Snippet completion " .. status, vim.log.levels.INFO)
      end
    end,

    opts = {
      -- Use LuaSnip for snippets
      snippets = {
        preset = 'luasnip'
      },

      keymap = {
        preset = 'default',
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = {
          'snippet_forward',
          'select_and_accept',
          'fallback'
        },
        ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
      },

      appearance = {
        kind_icons = {
          Text = "󰦨",
          Method = "",
          Function = "󰊕",
          Constructor = "",
          Field = "󰅪",
          Variable = "󱃮",
          Class = "",
          Interface = "",
          Module = "",
          Property = "",
          Unit = "",
          Value = "󰚯",
          Enum = "",
          Keyword = "",
          Snippet = "",
          Color = "󰌁",
          File = "",
          Reference = "",
          Folder = "",
          EnumMember = "",
          Constant = "󰀫",
          Struct = "",
          Event = "",
          Operator = "󰘧",
          TypeParameter = "",
        }
      },

      sources = {
        -- Default sources for most file types
        default = { 'lsp', 'path', 'snippets', 'buffer' },

        -- Smart per-filetype defaults
        per_filetype = {
          -- Markdown/Lectic: writing-focused completion
          markdown = { 'lsp', 'path', 'buffer', 'snippets', 'obsidian' },
          ['lectic.markdown'] = { 'lsp', 'path', 'buffer', 'snippets' },

          -- LaTeX: VimTeX + snippets priority
          tex = { 'lsp', 'snippets', 'omni', 'path', 'buffer' },

          -- Code files: full completion
          lua = { 'lsp', 'path', 'snippets', 'buffer' },
          python = { 'lsp', 'path', 'snippets', 'buffer' },
          javascript = { 'lsp', 'path', 'snippets', 'buffer' },
          html = { 'lsp', 'path', 'snippets', 'buffer' },
          css = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        providers = {
          lsp = {
            name = 'lsp',
            enabled = true,
            max_items = 100,
            min_keyword_length = 1,
          },
          path = {
            name = 'path',
            enabled = true,
            max_items = 20,
            min_keyword_length = 1,
          },
          buffer = {
            name = 'buffer',
            enabled = function()
              -- Buffer completion OFF by default in markdown files
              local is_markdown = vim.bo.filetype == 'markdown' or vim.bo.filetype == 'lectic.markdown'
              if is_markdown then
                return vim.g.blink_buffer_enabled == true
              end
              -- ON by default in other file types
              return vim.g.blink_buffer_enabled ~= false
            end,
            max_items = 8,
            min_keyword_length = 2,
          },
          snippets = {
            name = 'snippets',
            enabled = function()
              return vim.g.blink_snippets_enabled ~= false
            end,
            max_items = 10,
            min_keyword_length = 3,
            transform_items = function(ctx, items)
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
              local content = before_cursor
              content = content:gsub("^%s+", "")          -- strip leading whitespace
              content = content:gsub("^%d+[%.%)]%s*", "") -- strip "1. " or "1) "
              content = content:gsub("^[%-%*%+]%s*", "")  -- strip "- " / "* " / "+ "
              -- Must be the first word on the line
              if content:find("%s") then return {} end
              -- Prefix match only (no fuzzy): label must start with what's typed
              local keyword = content:lower()
              local filtered = {}
              for _, item in ipairs(items) do
                if item.label:lower():sub(1, #keyword) == keyword then
                  table.insert(filtered, item)
                end
              end
              return filtered
            end,
          },
          omni = {
            name = 'omni',
            enabled = function()
              return vim.bo.filetype == 'tex' and vim.bo.omnifunc ~= ''
            end,
            async = true,
            timeout_ms = 5000,
            max_items = 50,
            min_keyword_length = 0,
            score_offset = 100,
          },
          obsidian = {
            name = 'obsidian',
            module = 'blink.compat.source',
            enabled = function()
              return vim.bo.filetype == 'markdown' and vim.g.blink_obsidian_enabled ~= false
            end,
            min_keyword_length = 2,
            max_items = 20,
          },
          cmdline = {
            name = 'cmdline',
            min_keyword_length = function(ctx)
              -- Only show completions when typing 2+ character commands (before first space)
              if ctx.mode == 'cmdline' and string.find(ctx.line, ' ') == nil then
                return 2
              end
              return 0
            end
          },
        },
      },

      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          }
        },
        trigger = {
          prefetch_on_insert = true,
          show_on_keyword = true,
          show_on_trigger_character = true,
        },
        menu = {
          max_height = 15,
          auto_show = function()
            -- Disable auto-show in zen mode
            return not vim.g.zen_mode_enabled
          end,
          draw = {
            columns = {
              { 'kind_icon' },
              { 'label', 'label_description', gap = 1 }
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 250,
        },
        ghost_text = {
          enabled = false,
        },
      },

      cmdline = {
        enabled = true,
        completion = {
          menu = {
            auto_show = true,
          },
          trigger = {
            show_on_blocked_trigger_characters = {},
            show_on_x_blocked_trigger_characters = {}
          }
        },
        sources = function()
          local type = vim.fn.getcmdtype()
          if type == '/' or type == '?' then
            return {} -- Disable for search
          elseif type == ':' then
            return { 'cmdline', 'path' }
          end
          return {}
        end,
        keymap = {
          preset = 'default',
          ['<C-k>'] = { 'select_prev', 'fallback' },
          ['<C-j>'] = { 'select_next', 'fallback' },
          ['<CR>'] = { 'accept_and_enter', 'fallback' },
          ['<C-e>'] = { 'hide', 'fallback' },
          ['<Tab>'] = { 'select_and_accept', 'fallback' },
        },
      },
    }
  }
}
