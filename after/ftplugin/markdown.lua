require("nvim-surround").buffer_setup({
  surrounds = {
    -- ["e"] = {
    --   add = function()
    --     local env = require("nvim-surround.config").get_input ("Environment: ")
    --     return { { "\\begin{" .. env .. "}" }, { "\\end{" .. env .. "}" } }
    --   end,
    -- },
    ["b"] = {
      add = { "**", "**" },
      find = "**.-**",
      delete = "^(**)().-(**)()$",
    },
    ["i"] = {
      add = { "_", "_" },
      find = "_.-_",
      delete = "^(_)().-(_)()$",
    },
  },
})

-- prevents markdown from changing tabs to 4 spaces
-- vim.g.markdown_recommended_style = 0

-- Set up folding based on Treesitter (folds at markdown headers)
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt_local.foldlevel = 99  -- Start with all folds open
