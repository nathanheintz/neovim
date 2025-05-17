return {
  -- Plugins for Ghost theme development
  {
    "norcalli/nvim-colorizer.lua",  -- Color preview in CSS files
    config = function()
      require("colorizer").setup({
        "css";
        "scss";
        "html";
        "handlebars";
        "hbs";
      })
    end,
  },
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
