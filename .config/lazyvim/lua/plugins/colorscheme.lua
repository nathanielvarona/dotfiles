return {
  -- Extend Custom Colorscheme Options
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({
        -- your custom options here
      })
      -- vim.cmd("colorscheme github_dark_high_contrast")
      -- vim.cmd("colorscheme github_dark_tritanopia")
    end,
  },

  -- { "rebelot/kanagawa.nvim" },

  -- { "ellisonleao/gruvbox.nvim" },

  -- Overide LazyVim `colorscheme` Settings
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "catppuccin-mocha",
      colorscheme = "github_dark_default",
      -- colorscheme = "github_dark_high_contrast",
      -- colorscheme = "github_dark_tritanopia",
      -- colorscheme = "kanagawa-dragon",
      -- colorscheme = "kanagawa-wave",
      -- colorscheme = "gruvbox",
      -- colorscheme = "tokyonight-night",
    },
  },
}
