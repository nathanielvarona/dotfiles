return {
  {
    "projekt0n/github-nvim-theme",
    tag = "v1.1.2",
    -- enabled = false,
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("github-theme").setup({
        -- ...
      })

      vim.cmd("colorscheme github_dark_high_contrast")
    end,
  },
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     -- colorscheme = "github_dark_default",
  --     colorscheme = "github_dark_high_contrast",
  --     -- colorscheme = "github_light_default",
  --     -- colorscheme = "github_light_high_contrast",
  --   },
  -- },
}
