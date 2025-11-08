return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  -- ft = {"markdown", "lectic.markdown"}, -- load obsidian automatically in these filetypes (commented out to enable manual control)
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "SecondBrain",
        path = "~/SecondBrain", -- CHANGE THIS to your Obsidian vault path
      },
    },
    completion = {
      nvim_cmp = true, -- Works with blink.cmp via blink.compat
      min_chars = 2,
    },
    picker = {
      name = "telescope",
      telescope = {
        border = true,
        previewer = true,
      },
    },
    templates = {
      folder = "4-Resources/Obsidian-Templates", -- Relative path to your templates folder
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
    -- Additional options can be added here as needed
  },
}
