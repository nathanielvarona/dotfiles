return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    opts.filesystem.filtered_items = {
      hide_dotfiles = false, -- Show files starting with .
      hide_gitignored = false, -- Show gitignored files if you want
      hide_hidden = false, -- Show hidden files
    }
  end,
}
