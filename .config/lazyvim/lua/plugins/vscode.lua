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
  { import = "lazyvim.plugins.extras.vscode" },

  {
    -- Additional configuration for VSCode-specific setup
    "LazyVim/LazyVim",
    opts = function(_, opts)
      if not vim.g.vscode then
        return opts or {}
      end

      -- Notify the user that VSCode-specific configuration has been loaded
      vim.notify("Neovim: LazyVim", vim.log.levels.INFO)

      return opts or {}
    end,
  },
}
