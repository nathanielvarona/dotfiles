-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- vim.g.lazyvim_picker = "fzf"
-- vim.g.lazyvim_picker = "telescope"
vim.g.lazyvim_picker = "snacks"

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

-- WARNING: Temporary disabled due to performance issue.
-- LSP Server to use for Python.
-- Uncomment if LazyExtras: "lang.python" or "lazyvim.plugins.extras.lang.python" is enabled.
-- Set to "basedpyright" to use basedpyright instead of pyright.
-- vim.g.lazyvim_python_lsp = "pyright"
-- Set to "ruff_lsp" to use the old LSP implementation version.
-- vim.g.lazyvim_python_ruff = "ruff"

-- LSP Server to use for Ruby.
-- Set to "solargraph" to use solargraph instead of ruby_lsp.
vim.g.lazyvim_ruby_lsp = "ruby_lsp"
vim.g.lazyvim_ruby_formatter = "rubocop"

-- Better Hardtime Hints Visibility
vim.opt.showmode = false

-- Enable the option to require a Prettier config file
-- If no prettier config file is found, the formatter will not be used
vim.g.lazyvim_prettier_needs_config = false

-- Bypass filetype dectection
vim.filetype.add({
  extension = {
    html = "html",
  },
})

-- Native Whitespace Settings
-- vim.opt.list = true
-- vim.opt.listchars = {
--   space = "·",
--   tab = "->",
--   eol = "↵",
--   trail = "·",
-- }

-- Wrap Line options use the "lua/plugins/neominimap.lua" file.

-- Disable Snacks Animate
-- vim.g.snacks_animate = false
