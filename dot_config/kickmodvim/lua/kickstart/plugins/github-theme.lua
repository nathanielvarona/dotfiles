local function gh(repo) return 'https://github.com/' .. repo end

-- [[ Colorscheme ]]
-- GitHub Dark High Contrast from projekt0n/github-nvim-theme.
-- See `:help github-theme` for all styles and configuration options.
vim.pack.add { gh 'projekt0n/github-nvim-theme' }

require('github-theme').setup {
  options = {
    theme_style = 'dark_high_contrast',
    transparent = false,
    terminal_colors = true,
  },
}

-- Load the colorscheme here.
vim.cmd.colorscheme 'github_dark_high_contrast'

-- vim: ts=2 sts=2 sw=2 et
