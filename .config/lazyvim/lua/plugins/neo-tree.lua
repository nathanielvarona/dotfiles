-- Extending LazyVim Pre-Included Plugins
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
    })
  end,
  keys = {
    {
      "<C-n>",
      ":Neotree filesystem reveal left<CR>",
      desc = "Toggle Neo-tree",
      noremap = true,
      silent = true,
    },
  },
}
