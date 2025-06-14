return {
  "arakkkkk/kanban.nvim",
  
  -- Optional dependencies
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  
  -- Plugin configuration
  config = function()
    require("kanban").setup({
      markdown = {
        description_folder = "./", -- Optimized for your client workflow
        list_head = "## ",                  -- Column header format
      },
    })
  end,
}
