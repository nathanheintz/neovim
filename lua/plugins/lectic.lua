return {
  "gleachkr/Lectic",
  name = "lectic",
  version = false,
  lazy = true,
  ft = { "markdown", "lectic.markdown" },
  build = function()
    -- Change to the correct directory before running npm install
    local install_dir = vim.fn.stdpath('data') .. '/lazy/lectic'
    vim.fn.system('cd ' .. install_dir .. '/extra/lectic.nvim && npm install')
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
  end,

  config = function()
    -- Make sure the runtime path includes the correct subdirectory
    local plugin_dir = vim.fn.stdpath('data') .. '/lazy/lectic/extra/lectic.nvim'
    vim.opt.rtp:append(plugin_dir)

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

    -- Create a function to create a new Lectic file
    function _G.CreateNewLecticFile()
      -- Open a new buffer
      vim.cmd("enew")
      vim.cmd("setfiletype lectic.markdown")

      -- Create a welcome template
      local template = "---\n" ..
          "interlocutor:\n" ..
          "  name: Homie\n" ..
          "  prompt: You are an expert writing tutor helping with accessible nonfiction about internal arts, personal development, leadership, and philosophy.\n" ..
          "  provider: anthropic\n" ..
          "---\n\n" ..
          "<!-- Write your prompt below -->\n\n"

      -- Insert the template
      vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(template, "\n"))

      -- Prompt for save location
      local cwd = vim.fn.getcwd()
      vim.ui.input({
        prompt = "Save as: ",
        default = cwd .. "/" .. os.date("lectic-%Y-%m-%d.lec"),
        completion = "file"
      }, function(filepath)
        if filepath and filepath ~= "" then
          if not filepath:match("%.lec$") then
            filepath = filepath .. ".lec"
          end

          local ok, err = pcall(function()
            vim.cmd("write " .. vim.fn.fnameescape(filepath))
          end)

          if ok then
            vim.notify("Lectic file created: " .. filepath, vim.log.levels.INFO)
            vim.api.nvim_win_set_cursor(0, { 9, 0 })
          else
            vim.notify("Failed to save file: " .. err, vim.log.levels.ERROR)
          end
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
    vim.g.lectic_model = "claude-3-7-sonnet"

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
