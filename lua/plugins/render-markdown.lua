return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "lectic.markdown" },
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  opts = {
    enabled = true,
    file_types = { "markdown", "lectic.markdown" },
    render_modes = { "n", "c" }, -- Render in normal and command mode
    heading = {
      enabled = true,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },
    code = {
      enabled = true,
      style = "normal",
      left_pad = 2,
      right_pad = 2,
    },
    bullet = {
      enabled = true,
      icons = { "●", "○", "◆", "◇" },
    },
  },
}
