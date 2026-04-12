return {
  "gleachkr/Lectic",
  name = "lectic",
  version = "*",
  lazy = true,
  ft = { "markdown", "lectic.markdown" },
  build = function()
    vim.notify(
      "lectic updated! Also update the binary via terminal:\ncurl -fsSL https://raw.githubusercontent.com/gleachkr/lectic/main/install.sh | sh",
      vim.log.levels.WARN
    )
  end,
  init = function()
    -- Create the autocmd group early
    vim.api.nvim_create_augroup("Lectic", { clear = true })

    -- Add filetype detection for .lec files
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      group = "Lectic",
      pattern = "*.lec",
      callback = function()
        vim.bo.filetype = "lectic.markdown"
      end
    })

    -- Create a new Lectic file with Obsidian-compatible frontmatter.
    -- Scholar is the default persona; prompt/provider pulled from ~/Library/Preferences/lectic/lectic.yaml.
    function _G.CreateNewLecticFile()
      vim.cmd("enew")
      vim.cmd("setfiletype markdown")

      local template = table.concat({
        "---",
        "id:",
        "aliases: []",
        "tags: []",
        "interlocutor:",
        "  name: Scholar",
        "  prompt:",
        "---",
        "",
        "",
      }, "\n")
      vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(template, "\n"))

      local cwd = vim.fn.getcwd()
      local default_filename = cwd .. "/" .. os.date("%Y-%m-%d") .. ".md"
      vim.ui.input({
        prompt = "Save as: ",
        default = default_filename,
        completion = "file"
      }, function(filepath)
        if filepath and filepath ~= "" then
          if not filepath:match("%.md$") then
            filepath = filepath .. ".md"
          end
          local ok, err = pcall(function()
            vim.cmd("write " .. vim.fn.fnameescape(filepath))
          end)
          if ok then
            vim.notify("Lectic file created: " .. filepath, vim.log.levels.INFO)
            vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(0), 0 })
          else
            vim.notify("Failed to save file: " .. err, vim.log.levels.ERROR)
          end
        end
      end)
    end

    -- Add Scholar interlocutor fields to an existing document's frontmatter.
    -- Preserves all existing Obsidian fields (id, aliases, tags).
    -- Use <leader>mp to switch to other personas via :ask[Name] after this.
    function _G.AddLecticFrontmatter()
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

      local frontmatter_start, frontmatter_end
      if lines[1] == "---" then
        frontmatter_start = 1
        for i = 2, #lines do
          if lines[i] == "---" or lines[i] == "..." then
            frontmatter_end = i
            break
          end
        end
      end

      if not frontmatter_start or not frontmatter_end then
        vim.notify("No valid frontmatter found", vim.log.levels.ERROR)
        return
      end

      -- Collect Obsidian fields, skip any existing interlocutor block
      local obsidian_fields = {}
      local in_interlocutor = false
      for i = frontmatter_start + 1, frontmatter_end - 1 do
        local line = lines[i]
        if line:match("^interlocutor:") then
          in_interlocutor = true
        elseif in_interlocutor and line:match("^%s+") then
          -- skip
        else
          in_interlocutor = false
          table.insert(obsidian_fields, line)
        end
      end

      -- Build new frontmatter with Scholar appended
      local new_frontmatter = { "---" }
      for _, field in ipairs(obsidian_fields) do
        table.insert(new_frontmatter, field)
      end
      table.insert(new_frontmatter, "interlocutor:")
      table.insert(new_frontmatter, "  name: Scholar")
      table.insert(new_frontmatter, "  prompt:")
      table.insert(new_frontmatter, "---")

      vim.api.nvim_buf_set_lines(0, frontmatter_start - 1, frontmatter_end, false, new_frontmatter)
      vim.notify("Added Scholar interlocutor to frontmatter", vim.log.levels.INFO)
    end
  end,

  config = function()
    -- Make sure the runtime path includes the correct subdirectory
    local plugin_dir = vim.fn.stdpath('data') .. '/lazy/lectic/extra/lectic.nvim'
    vim.opt.rtp:append(plugin_dir)

    -- Start LSP for current buffer: the FileType event fires before the plugin
    -- loads on first open, so the autocmd in plugin/lsp.lua misses it.
    local ft = vim.bo.filetype
    if ft == "lectic" or ft == "lectic.markdown" or ft == "markdown.lectic" or ft == "markdown" then
      vim.lsp.start({
        name = 'lectic',
        cmd = { 'lectic', 'lsp' },
        root_dir = vim.fs.root(0, { ".git", "lectic.yaml" }) or vim.fn.getcwd(),
        single_file_support = true,
      })
    end

    -- Register FileType autocmd for subsequent buffer opens.
    -- plugin/lsp.lua is not sourced for dynamically-added rtp directories,
    -- so we replicate its autocmd here.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "lectic", "lectic.markdown", "markdown.lectic", "markdown" },
      callback = function()
        vim.lsp.start({
          name = 'lectic',
          cmd = { 'lectic', 'lsp' },
          root_dir = vim.fs.root(0, { ".git", "lectic.yaml" }) or vim.fn.getcwd(),
          single_file_support = true,
        })
      end,
    })

    -- Collapse folds after lectic LSP attaches and sends fold ranges.
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or client.name ~= "lectic" then return end

        local ft = vim.bo[args.buf].filetype

        -- .lec files only: close all folds, open the one at cursor.
        -- .md files: ufo handles folding via provider_selector (treesitter or LSP).
        if ft == "lectic.markdown" or ft == "lectic" then
          vim.defer_fn(function()
            if vim.api.nvim_buf_is_loaded(args.buf) then
              vim.api.nvim_buf_call(args.buf, function()
                vim.cmd("normal! zMzv")
              end)
            end
          end, 500)
        end
      end,
    })

    -- Create a global function to insert context link
    function _G.InsertContextLink()
      local line_num = vim.api.nvim_win_get_cursor(0)[1]
      local context_text = "[Context](/Users/nathanheintz/SecondBrain/)"
      vim.api.nvim_buf_set_lines(0, line_num, line_num, false, {context_text})
      vim.api.nvim_win_set_cursor(0, {line_num + 1, 43})
      vim.cmd("startinsert")
    end

    -- Insert an :ask[Name] directive at the current cursor position.
    -- Personas are defined globally in ~/Library/Preferences/lectic/lectic.yaml.
    -- :ask[Name] permanently switches the active interlocutor for all subsequent turns.
    function _G.SwitchLecticPersona(persona_name)
      local row = vim.api.nvim_win_get_cursor(0)[1]
      local directive = ":ask[" .. persona_name .. "] "
      vim.api.nvim_buf_set_lines(0, row, row, false, { directive })
      vim.api.nvim_win_set_cursor(0, { row + 1, #directive })
      vim.cmd("startinsert!")
    end

    -- Create a global function to submit current lectic section
    function _G.SubmitLecticSelection()
      -- Only run if we're in a lectic markdown buffer
      if vim.bo.filetype ~= "lectic.markdown" then
        vim.notify("This command only works in Lectic files (.lec)", vim.log.levels.WARN)
        return
      end

      -- Make sure the file is saved first
      if vim.bo.modified then
        vim.notify("Saving file before submitting to Lectic...", vim.log.levels.INFO)
        vim.cmd("write")
      end

      -- Get the visual selection using marks
      local selected_text = ""

      -- Check if visual marks exist in the buffer
      if vim.fn.getpos("'<")[2] > 0 and vim.fn.getpos("'>")[2] > 0 then
        -- Get start and end positions
        local start_pos = vim.fn.getpos("'<")
        local end_pos = vim.fn.getpos("'>")

        -- Convert to 0-indexed for API calls
        local start_line = start_pos[2] - 1
        local start_col = start_pos[3] - 1
        local end_line = end_pos[2] - 1
        local end_col = end_pos[3]

        -- Get the lines in the selection
        local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line + 1, false)

        if #lines > 0 then
          -- Process the selection based on whether it spans multiple lines
          if #lines == 1 then
            -- Single line selection
            selected_text = string.sub(lines[1], start_col + 1, end_col)
          else
            -- Multi-line selection
            -- Adjust first and last line for partial selection
            lines[1] = string.sub(lines[1], start_col + 1)
            lines[#lines] = string.sub(lines[#lines], 1, end_col)
            selected_text = table.concat(lines, "\n")
          end
        end
      end

      -- Check if we have a selection
      if selected_text == "" then
        vim.notify("No text selected. Please select text in visual mode first.", vim.log.levels.WARN)
        return
      end

      -- Format the selected text
      local formatted_selection = "Text Selection:\n" .. selected_text .. "\n"

      -- Prompt for user message
      vim.ui.input({
        prompt = "Add a message or question: ",
        completion = "buffer",
      }, function(user_message)
        if not user_message or user_message == "" then
          vim.notify("Operation cancelled - no message provided", vim.log.levels.WARN)
          return
        end

        -- Format the user message
        local formatted_message = "User Message:\n" .. user_message

        -- Combine selection and message
        local combined_content = formatted_selection .. "\n" .. formatted_message

        -- Append to the end of the document
        local line_count = vim.api.nvim_buf_line_count(0)

        -- Check if the last line is empty
        local last_line = vim.api.nvim_buf_get_lines(0, line_count - 1, line_count, false)[1]
        local separator = (last_line and last_line ~= "") and "\n" or ""

        -- Add the content to the end of the buffer
        vim.api.nvim_buf_set_lines(0, line_count, line_count, false,
          vim.split(separator .. combined_content .. "\n", "\n"))

        -- Send the file to Lectic
        local ok, err = pcall(function()
          require("lectic.submit").submit_lectic()
        end)

        -- Handle errors
        if not ok then
          vim.notify("Error submitting to Lectic: " .. tostring(err), vim.log.levels.ERROR)
        else
          vim.notify("Selection and message submitted to Lectic", vim.log.levels.INFO)
          -- Move cursor to the end
          local content_lines = vim.split(combined_content, "\n")
          vim.api.nvim_win_set_cursor(0, { line_count + #content_lines, 0 })
        end
      end)
    end

    -- Register the Lectic command
    vim.api.nvim_create_user_command(
      'Lectic',
      function(opts)
        local start_line = opts.line1
        local end_line = opts.line2
        require("lectic.submit").submit_lectic(start_line, end_line)
      end,
      {
        range = "%",
        desc = "Process buffer with Lectic AI",
      }
    )

    -- Configure Lectic
    vim.g.lectic_model = "claude-sonnet-4-6"

    -- Lectic file settings
    vim.api.nvim_create_autocmd("FileType", {
      group = "Lectic",
      pattern = "lectic.markdown",
      callback = function()
        vim.opt_local.conceallevel = 2
        vim.opt_local.concealcursor = "nc"

        -- Apply markdown keymaps if available
        if _G.set_markdown_keymaps then
          _G.set_markdown_keymaps()
        end
      end
    })
  end,

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter"
  }
}
