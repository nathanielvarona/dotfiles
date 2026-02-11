-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Toggle Diagnostics
local function toggle_diagnostic()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  vim.notify("Diagnostics " .. (vim.diagnostic.is_enabled() and "enabled" or "disabled"))
end

vim.keymap.set("n", "<leader>ht", toggle_diagnostic, { desc = "Toggle diagnostics" })

-- Toggle Harper LSP
vim.keymap.set("n", "<leader>uH", function()
  local clients = vim.lsp.get_clients({ name = "harper_ls" })
  if #clients > 0 then
    vim.cmd("LspStop harper_ls")
    vim.notify("Harper LSP Disabled", vim.log.levels.INFO)
  else
    vim.cmd("LspStart harper_ls")
    vim.notify("Harper LSP Enabled", vim.log.levels.INFO)
  end
end, { desc = "Toggle Harper LSP" })
