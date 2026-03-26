return {
  "L3MON4D3/LuaSnip",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("luasnip").config.setup({
      region_check_events = "CursorMoved",
    })
    require("luasnip.loaders.from_snipmate").load({ paths = "~/.config/nvim/snippets/" })
    require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets/" })
  end
}
