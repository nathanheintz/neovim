return {
  "kyza0d/vocal.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    keymap = nil, -- Using <leader>md from which-key instead
    recording_dir = vim.fn.expand("~/recordings"),
    delete_recordings = true,
    local_model = {
      enabled = true,
      model = "medium", -- Options: tiny, base, small, medium, large-v3-turbo
      path = vim.fn.expand("~/.cache/whisper"),
      python_path = "/opt/homebrew/bin/python3",
    },
  },
}
