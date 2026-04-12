return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require('lualine').setup({
      options = {
        icons_enabled = true,
        theme = vim.g.colors_name or 'terafox',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {
            "Avante",
            "AvanteInput",
            "AvanteAsk",
            "AvanteEdit"
          },
          winbar = {
            "Avante",
            "AvanteInput",
            "AvanteAsk",
            "AvanteEdit"
          },
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = {
          -- { require('mcphub.extensions.lualine') },
          -- 'encoding',
          -- 'fileformat',
          'filetype', function()
        local ok, pomo = pcall(require, "pomo")
        if not ok then
          return ""
        end

        local timer = pomo.get_first_to_finish()
        if timer == nil then
          return ""
        end

        local secs = timer:time_remaining()
        local mins = math.floor(secs / 60) 
        local s = secs % 60               
          return string.format("󰄉 %d:%02d",
        mins, s)
      end,
      },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {}
   

      })
    vim.api.nvim_create_autocmd("ColorScheme", {                   
    callback = function()               
      require('lualine').setup({ options = { theme = vim.g.colors_name } })
    end,
  })
end,
} 
