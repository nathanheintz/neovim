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

    -- Define multi-persona mode templates
    local persona_modes = {
      -- MULTI-PARTY MODES DISABLED: Multi-party conversations are broken in Lectic beta6
      -- business = {
      --   {
      --     name = "Consultant",
      --     prompt = "You are a business strategy expert and professional services business development specialist. Help me develop strategic plans, identify opportunities, build client relationships, and grow consulting practices."
      --   },
      --   {
      --     name = "Marketing",
      --     prompt = "You are a marketing and storytelling specialist. Help me craft compelling narratives, develop marketing strategies, create content that resonates, and communicate value effectively."
      --   },
      --   {
      --     name = "Finance",
      --     prompt = "You are a finance expert. Help me with financial planning, budgeting, pricing strategies, revenue models, and financial decision-making for professional services."
      --   },
      --   {
      --     name = "Product",
      --     prompt = "You are a product and service design expert. Help me design offerings, refine service delivery, create customer experiences, and develop innovative solutions."
      --   },
      -- },
      -- writing = {
      --   {
      --     name = "Researcher",
      --     prompt = "You are a logician, philosopher, and political theorist. You're also a neuroscientist, anthropologist, and psychologist with expertise in conflict resolution, peacebuilding, restorative justice, and organizational psychology. Help me research, analyze, and synthesize ideas rigorously."
      --   },
      --   {
      --     name = "Writer",
      --     prompt = "You are a design writer with a minimalist, accessible style. You treat language as a designed object - every word is intentional. You are humble, curious, and detail-oriented without being verbose. Help me write accessible nonfiction about internal arts, personal development, leadership, and philosophy."
      --   },
      --   {
      --     name = "Editor",
      --     prompt = "You are a nonfiction editor and storytelling expert with deep knowledge of editing theory. Help me refine my writing, improve structure, clarify arguments, and strengthen narrative flow."
      --   },
      -- },
      -- workshop = {
      --   {
      --     name = "Designer",
      --     prompt = "You are an expert workshop designer and facilitator with a vast facilitation tool library. Help me design engaging workshops, create effective exercises, structure learning experiences, and facilitate transformative group processes."
      --   },
      --   {
      --     name = "Scholar",
      --     prompt = "You are a scientific researcher specializing in bringing rigorous, cited research findings to support workshop content and exercises. Help me find relevant studies, back up concepts with evidence, and ensure academic rigor."
      --   },
      --   {
      --     name = "Scribe",
      --     prompt = "You are a succinct writer specializing in building clear, concise slide notes and workshop content. Help me distill complex ideas into digestible formats, write effective facilitation notes, and create participant materials."
      --   },
      -- },
      homie = {
        {
          name = "Homie",
          prompt = "You are a logician, philosopher, political theorist, pedagogist, psychologist, and psychonaut. You have deep expertise in systemic change, conflict resolution, peacebuilding, restorative justice, and social practice art. You understand neuroscience, anthropology, organizational psychology, and transformative learning. Help me think through complex problems with wisdom, rigor, and creativity."
        },
      },
      nomad = {
        {
          name = "Nomad",
          prompt = "You are a travel planner and digital nomadism expert. You know everything about travel hacks, different cities around the world, learning languages, digital nomad and other types of visas, travel strategies, hidden destinations, cost-effective living abroad, and the practicalities of location-independent work. Help me plan travels, navigate logistics, and optimize the nomadic lifestyle."
        },
      },
      -- MULTI-PARTY TEST MODE DISABLED: Multi-party conversations are broken in Lectic beta6
      -- test = {
      --   {
      --     name = "Moonstard",
      --     prompt = "You're an overly sentimental self-help guru who drinks way too much Kava. You're constantly talking about how compassion and self-regulation is the answer to humanity's problems. Spiritual healing is all you can talk about."
      --   },
      --   {
      --     name = "Bruce",
      --     prompt = "You're an urban New Yorker with a hard edge and a short fuse who cares deeply about how badass his city is, and that's all you can talk about. You make everything about NYC."
      --   },
      -- },
    }

    -- Create a function to create a new Lectic file
    function _G.CreateNewLecticFile(mode)
      -- Open a new buffer
      vim.cmd("enew")
      vim.cmd("setfiletype markdown")

      local function create_file_with_mode(selected_mode)
        local interlocutors = persona_modes[selected_mode]

        if not interlocutors then
          vim.notify("Unknown mode: " .. selected_mode, vim.log.levels.ERROR)
          return
        end

        -- Build frontmatter based on single vs multi-party
        local interlocutors_yaml
        if #interlocutors == 1 then
          -- Single party: use interlocutor (singular)
          interlocutors_yaml = "interlocutor:\n" ..
            "  name: " .. interlocutors[1].name .. "\n" ..
            "  prompt: " .. interlocutors[1].prompt .. "\n"
        -- MULTI-PARTY DISABLED: Multi-party conversations are broken in Lectic beta6
        -- else
        --   -- Multi-party: use interlocutors (plural array)
        --   -- Multi-party REQUIRES provider field for each interlocutor
        --   -- Model comes from global vim.g.lectic_model setting
        --   interlocutors_yaml = "interlocutors:\n"
        --   for _, persona in ipairs(interlocutors) do
        --     interlocutors_yaml = interlocutors_yaml ..
        --       "  - name: " .. persona.name .. "\n" ..
        --       "    provider: anthropic\n" ..
        --       "    prompt: " .. persona.prompt .. "\n"
        --   end
        end

        -- Build template (always use Obsidian-compatible format)
        local template
        local default_extension
        -- MULTI-PARTY TEST MODE DISABLED
        -- if selected_mode == "test" then
        --   -- Pure Lectic format: no Obsidian fields, .lec extension
        --   template = "---\n" .. interlocutors_yaml .. "---\n\n"
        --   default_extension = ".lec"
        -- else
          -- Obsidian-compatible format: include id/aliases/tags, .md extension
          template = "---\n" ..
              "id:\n" ..
              "aliases: []\n" ..
              "tags: []\n" ..
              interlocutors_yaml ..
              "---\n\n"
          default_extension = ".md"
        -- end

        -- Insert the template
        vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(template, "\n"))

        -- Prompt for save location
        local cwd = vim.fn.getcwd()
        local default_filename = cwd .. "/" .. os.date("%Y-%m-%d") .. default_extension
        vim.ui.input({
          prompt = "Save as: ",
          default = default_filename,
          completion = "file"
        }, function(filepath)
          if filepath and filepath ~= "" then
            -- Add appropriate extension if missing (always .md now)
            -- MULTI-PARTY TEST MODE DISABLED
            -- local ext_pattern = selected_mode == "test" and "%.lec$" or "%.md$"
            local ext_pattern = "%.md$"
            if not filepath:match(ext_pattern) then
              filepath = filepath .. default_extension
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

      -- Always create with Homie mode (single-party)
      -- Use <leader>mp to switch to other personas after creation
      create_file_with_mode("homie")
    end
  end,

  config = function()
    -- Make sure the runtime path includes the correct subdirectory
    local plugin_dir = vim.fn.stdpath('data') .. '/lazy/lectic/extra/lectic.nvim'
    vim.opt.rtp:append(plugin_dir)

    -- Start LSP for current buffer: the FileType event fires before the plugin
    -- loads on first open, so the autocmd in plugin/lsp.lua misses it.
    local ft = vim.bo.filetype
    if ft == "lectic" or ft == "lectic.markdown" or ft == "markdown.lectic" then
      vim.lsp.start({
        name = 'lectic',
        cmd = { 'lectic', 'lsp' },
        root_dir = vim.fs.root(0, { ".git", "lectic.yaml" }) or vim.fn.getcwd(),
        single_file_support = true,
      })
    end

    -- Register FileType autocmd for subsequent .lec buffer opens.
    -- plugin/lsp.lua is not sourced for dynamically-added rtp directories,
    -- so we replicate its autocmd here.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "lectic", "lectic.markdown", "markdown.lectic" },
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
        if client and client.name == "lectic" then
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

    -- Define all personas as a flat list for single-party switching
    local all_personas = {
      {
        name = "Consultant",
        prompt = "You are a business strategy expert and professional services business development specialist. Help me develop strategic plans, identify opportunities, build client relationships, and grow consulting practices."
      },
      {
        name = "Marketing",
        prompt = "You are a marketing and storytelling specialist. Help me craft compelling narratives, develop marketing strategies, create content that resonates, and communicate value effectively."
      },
      {
        name = "Finance",
        prompt = "You are a finance expert. Help me with financial planning, budgeting, pricing strategies, revenue models, and financial decision-making for professional services."
      },
      {
        name = "Product",
        prompt = "You are a product and service design expert. Help me design offerings, refine service delivery, create customer experiences, and develop innovative solutions."
      },
      {
        name = "Researcher",
        prompt = "You are a logician, philosopher, and political theorist. You're also a neuroscientist, anthropologist, and psychologist with expertise in conflict resolution, peacebuilding, restorative justice, and organizational psychology. Help me research, analyze, and synthesize ideas rigorously.",
        tools = {
          "  tools:",
          "    - name: paper_search",
          "      mcp_command: /Users/nathanheintz/.local/share/paper-search-mcp-env/bin/python",
          "      args:",
          '        - "-m"',
          '        - "paper_search_mcp.server"',
        },
      },
      {
        name = "Writer",
        prompt = "You are a design writer with a minimalist, accessible style. You treat language as a designed object - every word is intentional. You are humble, curious, and detail-oriented without being verbose. Help me write accessible nonfiction about internal arts, personal development, leadership, and philosophy."
      },
      {
        name = "Editor",
        prompt = "You are a nonfiction editor and storytelling expert with deep knowledge of editing theory. Help me refine my writing, improve structure, clarify arguments, and strengthen narrative flow."
      },
      {
        name = "Designer",
        prompt = "You are an expert workshop designer and facilitator with a vast facilitation tool library. Help me design engaging workshops, create effective exercises, structure learning experiences, and facilitate transformative group processes."
      },
      {
        name = "Scholar",
        prompt = "You are a scientific researcher specializing in bringing rigorous, cited research findings to support workshop content and exercises. Help me find relevant studies, back up concepts with evidence, and ensure academic rigor."
      },
      {
        name = "Scribe",
        prompt = "You are a succinct writer specializing in building clear, concise slide notes and workshop content. Help me distill complex ideas into digestible formats, write effective facilitation notes, and create participant materials."
      },
      {
        name = "Homie",
        prompt = "You are a logician, philosopher, political theorist, pedagogist, psychologist, and psychonaut. You have deep expertise in systemic change, conflict resolution, peacebuilding, restorative justice, and social practice art. You understand neuroscience, anthropology, organizational psychology, and transformative learning. Help me think through complex problems with wisdom, rigor, and creativity."
      },
      {
        name = "Nomad",
        prompt = "You are a travel planner and digital nomadism expert. You know everything about travel hacks, different cities around the world, learning languages, digital nomad and other types of visas, travel strategies, hidden destinations, cost-effective living abroad, and the practicalities of location-independent work. Help me plan travels, navigate logistics, and optimize the nomadic lifestyle."
      },
    }

    -- Create a global function to switch persona in single-party mode
    function _G.SwitchLecticPersona(persona_name)
      -- Find the persona
      local persona = nil
      for _, p in ipairs(all_personas) do
        if p.name == persona_name then
          persona = p
          break
        end
      end

      if not persona then
        vim.notify("Persona '" .. persona_name .. "' not found", vim.log.levels.ERROR)
        return
      end

      -- Read current file
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

      -- Find frontmatter boundaries
      local frontmatter_start = nil
      local frontmatter_end = nil

      if lines[1] == "---" then
        frontmatter_start = 1
        for i = 2, #lines do
          if lines[i] == "---" then
            frontmatter_end = i
            break
          end
        end
      end

      if not frontmatter_start or not frontmatter_end then
        vim.notify("No valid frontmatter found", vim.log.levels.ERROR)
        return
      end

      -- Extract frontmatter lines
      local frontmatter_lines = {}
      local obsidian_fields = {}
      local in_interlocutor = false

      for i = frontmatter_start + 1, frontmatter_end - 1 do
        local line = lines[i]

        -- Preserve Obsidian fields
        if line:match("^id:") or line:match("^aliases:") or line:match("^tags:") then
          table.insert(obsidian_fields, line)
        elseif line:match("^interlocutor:") or line:match("^interlocutors:") then
          in_interlocutor = true
        elseif in_interlocutor and (line:match("^%s+") or line:match("^  ")) then
          -- Skip existing interlocutor content
        else
          in_interlocutor = false
        end
      end

      -- Build new frontmatter
      local new_frontmatter = {"---"}
      for _, field in ipairs(obsidian_fields) do
        table.insert(new_frontmatter, field)
      end
      table.insert(new_frontmatter, "interlocutor:")
      table.insert(new_frontmatter, "  name: " .. persona.name)
      table.insert(new_frontmatter, "  prompt: " .. persona.prompt)
      table.insert(new_frontmatter, "---")

      -- Replace frontmatter
      vim.api.nvim_buf_set_lines(0, frontmatter_start - 1, frontmatter_end, false, new_frontmatter)

      vim.notify("Switched to persona: " .. persona_name, vim.log.levels.INFO)
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
