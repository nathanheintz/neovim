return {
  "stevearc/resession.nvim",
  opts = {
    -- Session directory
    dir = "session",

    -- Auto-save configuration (disabled - manual save preferred)
    autosave = {
      enabled = false,
      interval = 60,
      notify = false,
    },

    -- Extensions
    extensions = {
      quickfix = {},
    },
  },
  config = function(_, opts)
    local resession = require("resession")
    resession.setup(opts)

    -- Auto-save session on VimLeavePre if a session is loaded
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        if resession.get_current() then
          resession.save(resession.get_current(), { notify = false })
        end
      end,
    })
  end,
}
