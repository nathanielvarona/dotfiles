-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'ayu'
config.color_scheme = 'Brogrammer'
-- config.color_scheme = 'GitHub Dark'
-- config.color_scheme = 'Glacier'
-- config.color_scheme = 'Gotham (terminal.sexy)'
-- config.color_scheme = 'Vacuous 2 (terminal.sexy)'

config.initial_cols = 100
config.initial_rows = 30

config.font = wezterm.font_with_fallback({'MesloLGS Nerd Font', 'JetBrains Mono'}, { weight = 'Regular' })
config.font_size = 14.0

-- Hide Tabs
config.enable_tab_bar = false

-- Support option+left/right on mac to jump words
-- https://github.com/wez/wezterm/issues/253#issuecomment-672007120
config.keys = {
  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  {key="LeftArrow", mods="OPT", action=wezterm.action{SendString="\x1bb"}},
  -- Make Option-Right equivalent to Alt-f; forward-word
  {key="RightArrow", mods="OPT", action=wezterm.action{SendString="\x1bf"}},

  -- Switch Tabas
  -- Same as in Chrome
  -- macOS
  {key="LeftArrow", mods="CMD|OPT", action=wezterm.action{ActivateTabRelative=-1}},
  {key="RightArrow", mods="CMD|OPT", action=wezterm.action{ActivateTabRelative=1}},
}

-- and finally, return the configuration to wezterm
return config
