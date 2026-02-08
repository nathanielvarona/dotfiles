return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      enabled = false,
    },
    styles = {
      snacks_image = {
        relative = "editor",
        col = -1,
      },
    },
    image = {
      enabled = true,
      doc = {
        inline = false,
        float = true,
        max_width = 60,
        max_height = 30,
      },
    },
    picker = {
      sources = {
        explorer = {
          hidden = true,
          ignored = true,
          exclude = { ".DS_Store", "__pycache__" },
        },
        files = {
          hidden = true,
          ignored = true,
          exclude = { ".DS_Store" },
        },
      },
    },
  },
}
