--[[
  This file contains configuration settings specifically for the `vscode-neovim` extension.

  For more information about the `vscode-neovim` extension and its API usage,
  refer to the official documentation and repositories:

  GitHub Repository:
    - https://github.com/vscode-neovim/vscode-neovim

  Visual Studio Code Marketplace:
    - https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim
]]

return {
  -- Import the VSCode extras from LazyVim
  {
    import = "lazyvim.plugins.extras.vscode",
    cond = vim.g.vscode,
  },

  {
    -- Additional configuration for VSCode-specific setup
    "LazyVim/LazyVim",
    cond = vim.g.vscode,
    config = function(_, opts)
      opts = opts or {}

      -- Notify the user that VSCode-specific configuration has been loaded
      vim.notify("Neovim: LazyVim", vim.log.levels.INFO)
    end,
  },
}
