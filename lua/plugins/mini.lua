return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    -- Icons
    require('mini.icons').setup()

    -- Comment support
    require('mini.comment').setup({
      options = {
        ignore_blank_line = true,
      },
      mappings = {
        comment = 'gc',
        comment_line = 'gcc',
        comment_visual = 'gc',
        textobject = 'gc',
      },
    })

    -- Color highlighting (replacement for nvim-colorizer)
    require('mini.hipatterns').setup({
      highlighters = {
        -- Highlight hex color strings (#rrggbb) using that color
        hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
      },
    })
  end
}

