local api = vim.api

-- Set special buffers as fixed and map 'q' to close
api.nvim_create_autocmd(
  "FileType",
  {
    pattern = { "man", "help", "qf", "lspinfo", "infoview", "NvimTree" }, -- "startuptime",
    callback = function(ev)
      -- Set the window as fixed
      vim.wo.winfixbuf = true
      -- Map q to close
      vim.keymap.set("n", "q", ":close<CR>", { buffer = ev.buf, silent = true })
    end,
  }
)

-- Restore UI elements when entering buffers (but not dashboard)
api.nvim_create_autocmd({"TabEnter", "BufEnter", "WinEnter"}, {
  callback = function()
    -- Check if nvim-tree is visible in any window
    local nvim_tree_visible = false
    for _, win in pairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == "NvimTree" then
        nvim_tree_visible = true
        break
      end
    end
    
    -- Only restore UI if we have a real file buffer
    if vim.bo.filetype ~= "snacks_dashboard" and vim.bo.buftype == "" then
      vim.opt.showtabline = 2
      vim.opt.laststatus = 3
    -- Hide UI when in dashboard (but show statusline if nvim-tree is visible)
    elseif vim.bo.filetype == "snacks_dashboard" then
      vim.opt.showtabline = 0
      vim.opt.laststatus = nvim_tree_visible and 3 or 0
    end
  end,
})

-- Force statusline when nvim-tree buffer is created
api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "NvimTree" then
      vim.opt.laststatus = 3
    end
  end,
})

-- Handle Avante help markdown file specifically
api.nvim_create_autocmd(
  "BufEnter",
  {
    pattern = "*/avante.nvim.md",
    callback = function(ev)
      vim.bo[ev.buf].filetype = "help"  -- Set filetype to help
      vim.wo.winfixbuf = true  -- Set as fixed buffer
      vim.keymap.set("n", "q", ":close<CR>", { buffer = ev.buf, silent = true })
    end,
  }
)

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  pattern = { "term://*" }, -- use term://*toggleterm#* for only ToggleTerm
  command = "lua set_terminal_keymaps()",
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPre", "BufNewFile", "FileType" }, {
  pattern = { "*.md", "markdown" },  -- Also add "markdown" for FileType event
  command = "lua set_markdown_keymaps()",
})

-- Ensure .hbs files are detected as handlebars
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.hbs", "*.handlebars" },
  callback = function()
    vim.bo.filetype = "handlebars"
    -- Manually start LSP if not already started
    vim.cmd("LspStart html")
    vim.cmd("LspStart emmet_ls")
  end,
})
