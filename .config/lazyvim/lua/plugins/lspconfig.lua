return {
  -- Disable Pyright's Mason auto-installation and autostart
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          mason = false,
          autostart = false,
        },
        -- Configure pylsp
        pylsp = {
          mason = true, -- Or false if you manage it manually
          autostart = true,
          -- Add any specific pylsp settings here
          settings = {
            pylsp = {
              plugins = {
                -- Example: disable specific pylsp linters if desired
                pylint = { enabled = false },
                pyflakes = { enabled = false },
                pycodestyle = { enabled = false },
              },
            },
          },
        },
      },
    },
  },
}
