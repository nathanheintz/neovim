return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = {"markdown", "lectic.markdown"},
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    legacy_commands = false,
    ui = { enable = false },
    workspaces = {
      {
        name = "SecondBrain",
        path = "~/SecondBrain",
      },
    },
    completion = {
      min_chars = 2, -- blink.cmp auto-detected; no nvim_cmp compat needed
    },
    picker = {
      name = "snacks.pick",
    },
    templates = {
      folder = "4-Resources/Obsidian-Templates",
      date_format = "YYYY-MM-DD",
      time_format = "HH:mm",
    },
  },
}
