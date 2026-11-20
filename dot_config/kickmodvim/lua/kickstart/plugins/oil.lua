-- Oil is a file explorer that lets you edit the filesystem like a buffer
-- https://github.com/stevearc/oil.nvim
--
-- Instead of a tree, Oil opens a directory as a normal buffer. Add, rename,
-- move, or delete entries by editing the text, then `:w` to apply the changes.
-- Press `g?` inside the buffer to see all available mappings.

vim.pack.add { { src = 'https://github.com/stevearc/oil.nvim', version = vim.version.range '*' } }

vim.keymap.set('n', '-', '<Cmd>Oil<CR>', { desc = 'Open parent directory' })

require('oil').setup {
  -- Use Oil when opening a directory, e.g. `nvim .`
  default_file_explorer = true,
  view_options = {
    show_hidden = true,
  },
}

-- vim: ts=2 sts=2 sw=2 et
