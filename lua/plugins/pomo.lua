return {
  "epwalsh/pomo.nvim",
  version = "0.7.0",  -- Recommended, use latest release instead of latest commit
  lazy = true,
  cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
  dependencies = {
    -- Optional, but highly recommended if you want to use the "Default" timer
    "rcarriga/nvim-notify",
  },
  opts = {
  -- How often the notifiers are updated.
  update_interval = 1000,

  -- Configure the default notifiers to use for each timer.
  -- You can also configure different notifiers for timers given specific names, see
  -- the 'timers' field below.
  notifiers = {
    -- The "Default" notifier uses 'vim.notify' and works best when you have 'nvim-notify' installed.
    {
      name = "Default",
      opts = {
        -- With 'nvim-notify', when 'sticky = true' you'll have a live timer pop-up
        -- continuously displayed. If you only want a pop-up notification when the timer starts
        -- and finishes, set this to false.
        sticky = true,

        -- Configure the display icons:
        title_icon = "󱎫",
        text_icon = "󰄉",
        -- Replace the above with these if you don't have a patched font:
        -- title_icon = "⏳",
        -- text_icon = "⏱️",
      },
    },

    -- The "System" notifier sends a system notification when the timer is finished.
    -- Available on MacOS and Windows natively and on Linux via the `libnotify-bin` package.
    { name = "System" },

    -- You can also define custom notifiers by providing an "init" function instead of a name.
    -- See "Defining custom notifiers" below for an example 👇
    -- { init = function(timer) ... end }
  },

  -- Override the notifiers for specific timer names.
  -- timers = {
    -- For example, use only the "System" notifier when you create a timer called "Break",
    -- e.g. ':TimerStart 2m Break'.
    -- Break = {
    --  { name = "System" },
  -- },

  -- You can optionally define custom timer sessions.
  sessions = {
    -- Example session configuration for a session called "pomodoro".
    shorties = {
      { name = "Work", duration = "25m" },
      { name = "Short Break", duration = "5m" },
      { name = "Work", duration = "25m" },
      { name = "Short Break", duration = "5m" },
      { name = "Work", duration = "25m" },
      { name = "Long Break", duration = "15m" },
    },

    forties = {
      { name = "Work", duration = "40m" },
      { name = "Short Break", duration = "10m" },
      { name = "Work", duration = "40m" },
      { name = "Long Break", duration = "20m" },
      { name = "Work", duration = "40m" },
      { name = "Short Break", duration = "10m" },
      { name = "Work", duration = "40m" },
      { name = "Long Break", duration = "20m" },
    },

    hours = {
      { name = "Work", duration = "50m" },
      { name = "Break", duration = "10m" },
      { name = "Work", duration = "50m" },
      { name = "Long Break", duration = "20m" },
      { name = "Work", duration = "50m" },
      { name = "Break", duration = "10m" },
      { name = "Work", duration = "50m" },
      { name = "Long Break", duration = "20m" },
    },
  },
}
}
