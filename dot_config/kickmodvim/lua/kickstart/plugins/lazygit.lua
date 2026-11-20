-- LazyGit opens the lazygit terminal UI inside Neovim
-- https://github.com/kdheepak/lazygit.nvim
--
-- Requires the `lazygit` binary on your PATH (`brew install lazygit`).
-- Press `q` inside lazygit to close it.

-- No version constraint: this plugin publishes no semver tags, so track `main`.
vim.pack.add { { src = 'https://github.com/kdheepak/lazygit.nvim' } }

vim.keymap.set('n', '<leader>gg', '<Cmd>LazyGit<CR>', { desc = 'Open LazyGit' })

-- vim: ts=2 sts=2 sw=2 et
