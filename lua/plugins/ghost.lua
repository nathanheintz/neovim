return {
  -- Plugins for Ghost theme development
  -- Note: Color highlighting now handled by mini.hipatterns in mini.lua
  {
    "windwp/nvim-autopairs",  -- Auto close HTML tags and brackets
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
      -- Add specific rules for Handlebars if needed
    end,
  },
  {
    "mattn/emmet-vim",  -- Emmet for HTML & CSS expansion
    ft = { "html", "css", "handlebars", "hbs" },
    init = function()
      vim.g.user_emmet_settings = {
        ["handlebars"] = {
          extends = "html",
        },
      }
    end,
  },
}
