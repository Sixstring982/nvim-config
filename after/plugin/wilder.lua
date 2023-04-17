-- Wilder: Better wildmenu, with features like:
--
-- * Popup for LSP completions
-- * Completions for command mode

local wilder = require('wilder')

-- Enable Wilder for command mode and searching
wilder.setup({ modes = { ":", "/", "?" } })

-- Render Wilder as a popup menu
wilder.set_option(
  "renderer",
  wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
    highlighter = wilder.basic_highlighter(),
    pumblend = 17,
    min_width = "100%",
    min_height = "20%",
    max_height = "20%",
    left = { " ", wilder.popupmenu_devicons() },
    border = "rounded",
  }))
)
