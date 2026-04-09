return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  event = "BufReadPost",
  config = function()
    -- ufo requires these to be set
    vim.o.foldcolumn = "0"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    require("ufo").setup({
      provider_selector = function(_, filetype, _)
        if filetype == "markdown" then
          return { "treesitter" }
        elseif filetype == "lectic.markdown" or filetype == "lectic" then
          return { "lsp" }
        end
        return { "treesitter", "indent" }
      end,
    })

    -- Namespace for virtual blank lines above H1 headings in z1 fold view.
    local h1_padding_ns = vim.api.nvim_create_namespace('ufo_h1_padding')

    function _G.ClearFoldPadding()
      local bufnr = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_clear_namespace(bufnr, h1_padding_ns, 0, -1)
    end

    -- Buffer-local fold mode toggle (treesitter ↔ LSP).
    -- Writing mode (default): ufo treesitter provider, heading-based folds.
    -- Research mode: ufo detached, native vim.lsp.foldexpr() for Lectic code-block folds.
    function _G.ToggleFoldMode()
      local bufnr = vim.api.nvim_get_current_buf()
      local mode = vim.b[bufnr].ufo_fold_mode or "treesitter"
      if mode == "treesitter" then
        vim.b[bufnr].ufo_fold_mode = "lsp"
        require('ufo').detach(bufnr)
        vim.cmd('normal! zR')  -- open all folds for clean state before switching
        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'
        vim.wo.foldlevel = 0
        vim.cmd('normal! zx')
        vim.notify("Fold mode: LSP (research)", vim.log.levels.INFO)
      else
        vim.b[bufnr].ufo_fold_mode = "treesitter"
        vim.cmd('normal! zR')  -- open all folds for clean state before switching
        require('ufo').attach(bufnr)
        vim.notify("Fold mode: treesitter (writing)", vim.log.levels.INFO)
      end
    end

    -- Fold all sections deeper than `level` heading depth; keep shallower sections open.
    -- Uses treesitter (section) nodes — does NOT change foldlevel, so InsertLeave won't collapse.
    -- When level == 1: adds a virtual blank line above each H1 for visual breathing room.
    function _G.FoldToHeadingLevel(level)
      vim.cmd('normal! zR')  -- open all first for clean state
      local bufnr = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_clear_namespace(bufnr, h1_padding_ns, 0, -1)
      local ok, parser = pcall(vim.treesitter.get_parser, bufnr, 'markdown')
      if not ok or not parser then return end
      local root = parser:parse()[1]:root()
      local query = vim.treesitter.query.parse('markdown', '(section) @s')
      local win = vim.api.nvim_get_current_win()
      local cursor_save = vim.api.nvim_win_get_cursor(win)
      local sections = {}
      local h1_lines = {}
      for _, node in query:iter_captures(root, bufnr, 0, -1) do
        local lnum = node:start() + 1
        local text = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1] or ''
        local heading_level = #(text:match('^(#+)') or '')
        if heading_level > level then
          table.insert(sections, lnum)
        end
        if level == 1 and heading_level == 1 then
          table.insert(h1_lines, lnum)
        end
      end
      -- Close deepest → shallowest so parent folds close after children
      for i = #sections, 1, -1 do
        vim.api.nvim_win_set_cursor(win, { sections[i], 0 })
        pcall(vim.cmd, 'normal! zc')
      end
      -- Add virtual blank line above each H1 (skip first line — no room above it)
      for _, lnum in ipairs(h1_lines) do
        if lnum > 1 then
          vim.api.nvim_buf_set_extmark(bufnr, h1_padding_ns, lnum - 1, 0, {
            virt_lines_above = true,
            virt_lines = { { { '', 'Normal' } } },
          })
        end
      end
      vim.api.nvim_win_set_cursor(win, cursor_save)
    end

    -- Toggle only heading-section folds (leaves code block folds untouched).
    -- Queries treesitter for (section) nodes, closes deepest→shallowest,
    -- opens shallowest→deepest, so nested sections work correctly.
    function _G.ToggleHeadingFolds()
      local bufnr = vim.api.nvim_get_current_buf()
      local ok, parser = pcall(vim.treesitter.get_parser, bufnr, 'markdown')
      if not ok or not parser then return end

      local root = parser:parse()[1]:root()
      local query = vim.treesitter.query.parse('markdown', '(section) @s')
      local win = vim.api.nvim_get_current_win()
      local cursor_save = vim.api.nvim_win_get_cursor(win)

      -- Collect section start lines; foldclosed == -1 means the fold is open
      local lines = {}
      local any_open = false
      for _, node in query:iter_captures(root, bufnr, 0, -1) do
        local lnum = node:start() + 1  -- 0-indexed → 1-indexed
        table.insert(lines, lnum)
        if vim.fn.foldclosed(lnum) == -1 then
          any_open = true
        end
      end

      if any_open then
        -- Close: deepest → shallowest so parents close after children
        for i = #lines, 1, -1 do
          local lnum = lines[i]
          if vim.fn.foldclosed(lnum) == -1 then
            vim.api.nvim_win_set_cursor(win, { lnum, 0 })
            pcall(vim.cmd, 'normal! zc')
          end
        end
      else
        -- Open: shallowest → deepest so parents open before children
        for _, lnum in ipairs(lines) do
          if vim.fn.foldclosed(lnum) ~= -1 then
            vim.api.nvim_win_set_cursor(win, { lnum, 0 })
            pcall(vim.cmd, 'normal! zo')
          end
        end
      end

      vim.api.nvim_win_set_cursor(win, cursor_save)
    end
  end,
}
