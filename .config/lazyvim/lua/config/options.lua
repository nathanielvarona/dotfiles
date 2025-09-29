-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- vim.g.lazyvim_picker = "fzf"
-- vim.g.lazyvim_picker = "telescope"

-- The order of your `lazy.nvim` imports is incorrect:
--   - `lazyvim.plugins` should be first
--   - followed by any `lazyvim.plugins.extras`
--   - and finally your own `plugins`

-- vim.g.lazyvim_check_order = false

-- Default sessionoptions settings
-- vim.o.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds"
-- Inspect Settings Vim Command: "set sessionoptions?"
-- Auto-Session Plugin Recommendation
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- LSP Server to use for Python.
-- Set to "basedpyright" to use basedpyright instead of pyright.
vim.g.lazyvim_python_lsp = "pyright"
-- Set to "ruff_lsp" to use the old LSP implementation version.
vim.g.lazyvim_python_ruff = "ruff"

-- LSP Server to use for Ruby.
-- Set to "solargraph" to use solargraph instead of ruby_lsp.
vim.g.lazyvim_ruby_lsp = "ruby_lsp"
vim.g.lazyvim_ruby_formatter = "rubocop"

-- Better Hardtime Hints Visibility
vim.opt.showmode = false
