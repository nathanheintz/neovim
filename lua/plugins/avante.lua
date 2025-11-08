return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- Using latest version to get the most recent fixes
  
  -- Explicitly checking for Neovim 0.10.1+ compatibility
  cond = function()
    if vim.fn.has("nvim-0.10.1") == 0 then
      vim.notify("Avante requires Neovim 0.10.1 or later", vim.log.levels.WARN)
      return false
    end
    return true
  end,
  
  init = function()
    -- Set recommended vim option for best Avante view compatibility
    -- Views can only be fully collapsed with the global statusline
    vim.opt.laststatus = 3

    -- Define provider models (moved to global scope for reuse)
    -- IMPORTANT: Keep claude-sonnet-4-20250514 as the first model
    _G.provider_models = {
      claude = {
        "claude-sonnet-4-20250514",     -- Claude 4 (current)
        "claude-3-7-sonnet-20250219",   -- Claude 3.7
        "claude-3-5-sonnet-20241022",   -- Claude 3.5 (legacy)
      },
      -- Commented out - OpenAI models
      -- openai = {
      --   "gpt-4o",
      --   "gpt-4-turbo",
      --   "gpt-4",
      --   "gpt-3.5-turbo",
      -- },
      -- Commented out - Gemini models
      -- gemini = {
      --   "gemini-2.5-pro-preview-03-25",
      --   "gemini-2.0-flash",
      -- }
    }

    -- Require the support module if you have one
    -- If you don't have avante-support.lua, you can remove these lines
    local has_support, avante_support = pcall(require, "plugins.ai.avante-support")
    
    if has_support then
      -- Initialize state with the settings from our support module
      local settings = avante_support.init()

      -- Add additional autocmd to enforce model after fully loaded
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyDone",
        callback = function()
          vim.defer_fn(function()
            local ok, avante = pcall(require, "avante")
            if ok then
              local lazy_settings = avante_support.init()
              local model_config = lazy_settings

              -- Try different methods to override config
              local success = pcall(function()
                if avante.config and avante.config.override then
                  avante.config.override(model_config)
                  return true
                end
              end)

              if not success then
                success = pcall(function()
                  if type(avante.override) == "function" then
                    avante.override(model_config)
                    return true
                  end
                end)
              end

              if not success then
                pcall(function()
                  local config_module = require("avante.config")
                  if config_module and config_module.override then
                    config_module.override(model_config)
                  end
                end)
              end

              _G.avante_first_open = true
            end
          end, 1000)
        end
      })

      -- Add VimEnter event to enforce model configuration
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.defer_fn(function()
            local ok, avante = pcall(require, "avante")
            if ok then
              local vim_settings = avante_support.init()
              local model_config = vim_settings

              local success = pcall(function()
                if avante.config and avante.config.override then
                  avante.config.override(model_config)
                  return true
                end
              end)

              if not success then
                success = pcall(function()
                  if type(avante.override) == "function" then
                    avante.override(model_config)
                    return true
                  end
                end)
              end

              if not success then
                pcall(function()
                  local config_module = require("avante.config")
                  if config_module and config_module.override then
                    config_module.override(model_config)
                  end
                end)
              end
            end
          end, 300)
        end
      })

      -- Set up Avante commands using the support module
      avante_support.setup_commands()
    end

    -- Create autocmd for Avante buffer-specific mappings
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "AvanteInput", "Avante" },
      callback = function()
        -- Show model notification on first window open in a session
        local filetype = vim.bo.filetype
        if _G.avante_first_open and filetype == "Avante" then
          _G.avante_first_open = false

          vim.defer_fn(function()
            if has_support and avante_support.show_model_notification then
              avante_support.show_model_notification()
            end
          end, 100)
        end

        -- Set up buffer keymaps if you have a global function for this
        if _G.set_avante_keymaps then
          _G.set_avante_keymaps()
        end

        vim.opt_local.scrolloff = 999
      end
    })
  end,
  
  opts = function()
    -- Default configuration following the new migration structure
    local config = {
      -- Project-specific instructions file
      instructions_file = "avante.md",
      
      -- Mode: "agentic" enables autonomous AI behavior
      mode = "agentic",
      
      -- Primary provider
      provider = "claude",
      
      -- Auto-suggestions provider (disabled below, but you could use a cheaper provider here)
      auto_suggestions_provider = "claude",
      
      -- NEW STRUCTURE: All provider configurations under 'providers' field
      providers = {
        -- Claude configuration (ACTIVE)
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-20250514",  -- Claude 4
          timeout = 60000,  -- 60 seconds
          
          -- STRICT TOKEN LIMITS to control API usage
          extra_request_body = {
            temperature = 0.1,
            max_tokens = 4096,  -- Conservative limit (Claude 4 supports up to 20480+)
            top_p = 0.95,
          },
          
          -- Disable automatic tool usage for safety
          disable_tools = {
            "file_creation",
            "git_operations",
            "system_commands",
            "file_modifications",
          },
        },
        
        -- OpenAI configuration (COMMENTED OUT)
        -- openai = {
        --   endpoint = "https://api.openai.com/v1",
        --   api_key_name = "OPENAI_API_KEY",
        --   model = "gpt-4o",
        --   timeout = 60000,
        --   
        --   extra_request_body = {
        --     temperature = 0.1,
        --     max_tokens = 4096,
        --     top_p = 0.95,
        --   },
        --   
        --   disable_tools = {
        --     "file_creation",
        --     "git_operations",
        --     "system_commands",
        --     "file_modifications",
        --   },
        -- },
        
        -- Gemini configuration (COMMENTED OUT)
        -- gemini = {
        --   endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
        --   api_key_name = "GEMINI_API_KEY",
        --   model = "gemini-2.5-pro-preview-03-25",
        --   
        --   extra_request_body = {
        --     temperature = 0.1,
        --     max_tokens = 8192,
        --   },
        --   
        --   disable_tools = {
        --     "file_creation",
        --     "git_operations",
        --     "system_commands",
        --     "file_modifications",
        --   },
        -- },
      },
      
      -- System prompt
      system_prompt = 
        "You are an expert mathematician, logician and computer scientist with deep knowledge of Neovim, Lua, and programming languages. Provide concise, accurate responses with code examples when appropriate. For mathematical content, use clear notation and step-by-step explanations. IMPORTANT: Never create files, make git commits, or perform system changes without explicit permission. Always ask before suggesting any file modifications or system operations. Only use the SEARCH/REPLACE blocks to suggest changes.",
      
      -- Dual boost disabled (would use two providers simultaneously)
      dual_boost = {
        enabled = false,
        first_provider = "claude",
        second_provider = "openai",
        prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
        timeout = 60000,
      },
      
      -- Fallback disabled
      fallback = {
        enabled = false,
        model = "claude-sonnet-4-20250514",
        auto_retry = false,
      },
      
      -- Behavior settings
      behaviour = {
        enable_claude_text_editor_tool_mode = true,
        enable_cursor_planning_mode = false,
        auto_suggestions = false,  -- DISABLED as requested
        auto_suggestions_respect_ignore = true,
        auto_set_highlight_group = false,
        auto_set_keymaps = false,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = true,
        minimize_diff = true,
        preserve_state = true,
        require_confirmation_for_actions = true,  -- Safety: require confirmation
        disable_file_creation = true,             -- Safety: no auto file creation
        disable_git_operations = true,            -- Safety: no auto git ops
        respect_enter_key = true,
        use_cwd_as_project_root = false,
      },

      -- Token counting configuration
      token_counting = {
        enabled = true,              -- Track token usage
        show_in_status_line = false,
      },
      
      -- Keymaps
      mappings = {
        diff = {
          ours = "o",
          theirs = "t",
          all_theirs = "a",
          both = "b",
          cursor = "c",
          next = "<C-j>",
          prev = "<C-k>",
        },
        suggestion = {
          accept = "<C-l>",
          next = "<C-j>",
          prev = "<C-k>",
          dismiss = "<C-h>",
        },
        jump = {
          next = "n",
          prev = "N",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-l>",
        },
        sidebar = {
          apply_all = "A",
          apply_cursor = "a",
          switch_windows = "<Tab>",
          reverse_switch_windows = "<S-Tab>",
        },
      },
      
      -- Hints disabled
      hints = { enabled = false },
      
      -- Window configuration
      windows = {
        position = "right",
        wrap = true,
        width = 40,
        sidebar_header = {
          enabled = true,
          align = "left",
          rounded = false,
        },
        input = {
          rounded = true,
          prefix = "󰭹 ",
          height = 8,
        },
        edit = {
          border = "rounded",
          start_insert = true,
        },
        ask = {
          floating = false,
          start_insert = true,
          border = "rounded",
          focus_on_apply = "ours",
        },
      },
      
      -- Highlights
      highlights = {
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
      },
      
      -- Diff settings
      diff = {
        autojump = true,
        list_opener = "copen",
        override_timeoutlen = 500,
      },
    }

    return config
  end,
  
  -- Build command (conditional based on OS)
  build = function()
    if vim.fn.has("win32") == 1 then
      return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    else
      return "make"
    end
  end,
  
  -- Dependencies
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-tree/nvim-web-devicons",
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    
    -- Optional: Prettier markdown rendering in Avante chat (COMMENTED OUT)
    -- {
    --   'MeanderingProgrammer/render-markdown.nvim',
    --   opts = {
    --     file_types = { "markdown", "Avante" },
    --   },
    --   ft = { "markdown", "Avante" },
    -- },
  },
}
