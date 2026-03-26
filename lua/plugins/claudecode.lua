return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  cmd = { "ClaudeCode", "ClaudeCodeFocus", "ClaudeCodeSend", "ClaudeCodeAdd", "ClaudeCodeSelectModel", "ClaudeCodeDiffAccept", "ClaudeCodeDiffDeny", "ClaudeCodeTreeAdd" },
  config = true,
  keys = {
    -- Add file from neo-tree (ft-specific, handled here rather than which-key)
    {
      "<leader>cs",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "add file to claude",
      ft = { "neo-tree" },
    },
  },
}
