return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {
      preset = "classic",
      options = {
        show_source = {
          enabled = true,
        },
        add_messages = {
          display_count = true,
        },
        multilines = {
          enabled = true,
        },
        set_arrow_to_diag_color = true,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = { diagnostics = { virtual_text = false } },
  },
}
