return {
  "mustache/vim-mustache-handlebars",
  lazy = true,
  ft = { "handlebars", "mustache", "hbs" },
  init = function()
    vim.g.mustache_abbreviations = 1  -- Enable abbreviations
  end,
}
