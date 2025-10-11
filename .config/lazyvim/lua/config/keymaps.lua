-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function toggle_diagnostic()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  vim.notify("Diagnostics " .. (vim.diagnostic.is_enabled() and "enabled" or "disabled"))
end

vim.keymap.set("n", "<leader>ht", toggle_diagnostic, { desc = "Toggle diagnostics" })
