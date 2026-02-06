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
end

return {
  -- Disable Conflicting Extras/Plugins
  {
    "nvim-mini/mini.animate",
    enabled = false,
  },
  {
    "sphamba/smear-cursor.nvim",
    enabled = false,
  },

  vim.notify("Neovim: LazyVim", vim.log.levels.INFO),
}
