return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  event = "BufReadPost",
  config = function()
    -- ufo requires these to be set
    vim.o.foldcolumn = "0"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    require("ufo").setup({
      provider_selector = function(_, filetype, _)
        if filetype == "markdown" then
          return { "treesitter" }
        elseif filetype == "lectic.markdown" or filetype == "lectic" then
          return { "lsp" }
        end
        return { "treesitter", "indent" }
      end,
    })
  end,
}
