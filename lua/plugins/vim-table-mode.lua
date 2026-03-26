  return {
    "dhruvasagar/vim-table-mode",
    ft = { "markdown", "lectic.markdown" },
    init = function()
      vim.g.table_mode_corner = "|"  -- use | corners (markdown style)                                                                                       
    end
  }
