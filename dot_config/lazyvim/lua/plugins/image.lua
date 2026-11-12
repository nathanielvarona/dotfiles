return {
  "3rd/image.nvim",
  build = false, -- Disables luarocks build since ImageMagick CLI handles Sixel
  opts = {
    backend = "sixel",
    processor = "magick_cli",
    integrations = {
      markdown = {
        enabled = true,
        only_render_image_at_cursor = true,
        only_render_image_at_cursor_mode = "popup", -- Prevents Sixel artifacts while scrolling
      },
    },
    tmux_show_only_in_active_window = true,
  },
}
