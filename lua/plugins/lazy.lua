return {
  "kdheepak/lazygit.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",  -- You already have this installed
  },
  config = function()
    vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { silent = true, desc = "Open LazyGit" })
  end,
}
