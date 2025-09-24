-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Brogrammer"

-- Intended for Recommended Asciinema Demo
config.initial_cols = 100
config.initial_rows = 30

-- Intended for Recommended Asciinema with Editors and Multiplexers
-- config.initial_cols = 172
-- config.initial_rows = 45

config.default_cursor_style = "SteadyBlock"

config.font = wezterm.font_with_fallback({
  { family = "JetBrains Mono NL", scale = 1 },
  { family = "Symbols Nerd Font Mono", scale = 0.9 },
})

config.font_size = 14.0

config.background = {
  {
    source = {
      Color = "#000000",
    },
    width = "100%",
    height = "100%",
    -- opacity = 0.75
  },
}

config.window_close_confirmation = "AlwaysPrompt"

-- Hide Tabs
-- config.enable_tab_bar = false

-- Configures whether the window has a title bar and/or resizable border
config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
-- config.hide_tab_bar_if_only_one_tab = true
-- config.use_fancy_tab_bar = false

config.window_frame = {
  -- The font used in the tab bar.
  -- Roboto Bold is the default; this font is bundled
  -- with wezterm.
  -- Whatever font is selected here, it will have the
  -- main font setting appended to it to pick up any
  -- fallback fonts you may have used there.
  font = wezterm.font_with_fallback({
    { family = "JetBrains Mono NL", scale = 1, weight = "Bold" },
    { family = "Symbols Nerd Font Mono", scale = 0.9, weight = "Bold" },
  }),

  -- The size of the font in the tab bar.
  -- Default to 10.0 on Windows but 12.0 on other systems
  font_size = 13.0,

  -- The overall background color of the tab bar when
  -- the window is focused
  -- active_titlebar_bg = '#333333',

  -- The overall background color of the tab bar when
  -- the window is not focused
  -- inactive_titlebar_bg = '#333333',

  inactive_titlebar_bg = "#353535",
  active_titlebar_bg = "#2b2042",
  inactive_titlebar_fg = "#cccccc",
  active_titlebar_fg = "#ffffff",
  inactive_titlebar_border_bottom = "#2b2042",
  active_titlebar_border_bottom = "#2b2042",
  button_fg = "#cccccc",
  button_bg = "#2b2042",
  button_hover_fg = "#ffffff",
  button_hover_bg = "#3b3052",
}

config.window_padding = {
  left = 2,
  right = 2,
  top = 0,
  bottom = 2,
}

config.show_tab_index_in_tab_bar = true
config.tab_and_split_indices_are_zero_based = false

config.colors = {
  tab_bar = {

    -- The color of the strip that goes along the top of the window
    -- (does not apply when fancy tab bar is in use)
    background = "#0b0022",

    -- The active tab is the one that has focus in the window
    active_tab = {
      -- The color of the background area for the tab
      bg_color = "#1b1032",
      -- The color of the text for the tab
      fg_color = "#c0c0c0",

      -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
      -- label shown for this tab.
      -- The default is "Normal"
      intensity = "Normal",

      -- Specify whether you want "None", "Single" or "Double" underline for
      -- label shown for this tab.
      -- The default is "None"
      -- underline = 'None',

      -- Specify whether you want the text to be italic (true) or not (false)
      -- for this tab.  The default is false.
      -- italic = false,

      -- Specify whether you want the text to be rendered with strikethrough (true)
      -- or not for this tab.  The default is false.
      -- strikethrough = false,
    },

    -- Inactive tabs are the tabs that do not have focus
    inactive_tab = {
      bg_color = "#2b2042",
      fg_color = "#808080",
      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab`.
    },

    -- You can configure some alternate styling when the mouse pointer
    -- moves over inactive tabs
    inactive_tab_hover = {
      bg_color = "#3b3052",
      fg_color = "#909090",
      -- italic = true,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab_hover`.
    },

    -- The new tab button that let you create new tabs
    new_tab = {
      bg_color = "#3b3052",
      fg_color = "#909090",

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab`.
    },

    -- You can configure some alternate styling when the mouse pointer
    -- moves over the new tab button
    new_tab_hover = {
      bg_color = "#1b1032",
      fg_color = "#808080",
      -- italic = true,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab_hover`.
    },
  },
}

-- Enable macOS full screen mode
config.native_macos_fullscreen_mode = true

-- Support option+left/right on mac to jump words
config.keys = {

  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  { key = "LeftArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bb" }) },
  -- Make Option-Right equivalent to Alt-f; forward-word
  { key = "RightArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bf" }) },

  -- Switch Tabs (Same as in Chrome) for macOS
  { key = "LeftArrow", mods = "CMD|OPT", action = wezterm.action({ ActivateTabRelative = -1 }) },
  { key = "RightArrow", mods = "CMD|OPT", action = wezterm.action({ ActivateTabRelative = 1 }) },

  -- Toggles full screen mode for the current window
  {
    key = "n",
    mods = "SHIFT|CTRL",
    action = wezterm.action.ToggleFullScreen,
  },
}

-- and finally, return the configuration to wezterm
return config
