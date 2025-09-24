return {
  -- Overide LazyVim `colorscheme` Settings
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "github_dark_high_contrast",
      -- colorscheme = "github_dark_tritanopia",
    },
  },

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
}
