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
      icons = { "• ", "◦ ", "▸ ", "▹ " },
    },
  },
  config = function(_, opts)
    require("render-markdown").setup(opts)

    local function apply_heading_highlights()
      vim.schedule(function()
        local colorscheme = vim.g.colors_name or ""
        local ok, palette_mod = pcall(require, "nightfox.palette")

        if ok and colorscheme:match("fox") then
          local p = palette_mod.load(colorscheme)

          -- Foreground: orange → pale orange → maroon → blue → grey-blue → muted
          -- Mirrors neo-tree directory color hierarchy in terafox
          local fgs = {
            p.orange and p.orange.base,
            p.orange and p.orange.base,
            p.red    and p.red.base,
            p.blue   and p.blue.base,
            p.blue   and p.blue.dim or p.fg3,
            p.fg3,
          }

          -- Backgrounds: graduated from most to least prominent using palette bg levels
          local bgs = {
            nil,     -- H1: no background
            p.bg4,   -- H2
            p.bg4,   -- H3
            p.bg3,   -- H4
            p.bg2,   -- H5
            p.bg1,   -- H6: nearly invisible bg
          }

          for i = 1, 6 do
            if fgs[i] then
              local hl = { fg = fgs[i], bold = i <= 2 }
              vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i, hl)
              -- Also override treesitter heading groups so the text color matches
              vim.api.nvim_set_hl(0, "@markup.heading." .. i .. ".markdown", hl)
            end
            vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i .. "Bg", {
              bg = bgs[i] or "NONE",
            })
          end
          return
        end

        -- Fallback for non-nightfox themes: link to treesitter heading groups
        for i = 1, 6 do
          vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i, {
            link = "@markup.heading." .. i .. ".markdown",
          })
        end
      end)
    end

    apply_heading_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_heading_highlights })
  end,
}
