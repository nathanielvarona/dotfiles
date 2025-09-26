--[[
  This file contains configuration settings specifically for the `vscode-neovim` extension.

  For more information about the `vscode-neovim` extension and its API usage,
  refer to the official documentation and repositories:

  GitHub Repository:
    - https://github.com/vscode-neovim/vscode-neovim

  Visual Studio Code Marketplace:
    - https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim
]]

if not vim.g.vscode then
  return {}
else
  return {
    -- Additional configuration for VSCode-specific setup
    {
      "LazyVim/LazyVim",
      opts = function(_, opts)
        -- Notify the user that VSCode-specific configuration has been loaded
        vim.notify("Neovim: LazyVim", vim.log.levels.INFO)
        return opts
      end,
    },
  }
end
