return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts, {
      filesystem = {
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {
            ".git",
            ".DS_Store",
            "thumbs.db",
          },
          never_show = {},
        },
      },
      default_component_configs = {
        indent = {
          indent_size = 2,
          padding = 1,
          indent_guides = {
            enable = true,
          },
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
        },
      },
    })
  end,
  config = function(_, opts)
    vim.cmd("highlight NeoTreeIndentMarker guifg=#74c7ec")
    require("neo-tree").setup(opts)
  end,
  keys = {
    -- {
    --   "<C-n>",
    --   ":Neotree filesystem reveal left<CR>",
    --   desc = "Toggle Neo-tree",
    --   noremap = true,
    --   silent = true,
    -- },
  },
}
