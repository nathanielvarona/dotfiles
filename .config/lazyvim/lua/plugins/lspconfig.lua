return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_installation = true,
      ensure_installed = {
        "ty", -- Python LSP and Linter (Type Checker)
        "ruff", -- Python LSP, Linter and Formater (Code Formater)
        "htmx",
      },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      {
        "neovim/nvim-lspconfig",

        -- NOTE:
        -- > If you want to overide the default LSP custom settings.
        -- > Such as adding custom LSP flags to monitor Log level.

        opts = {
          -- servers = {
          --   ty = {
          --     init_options = {
          --       logLevel = "debug",
          --     },
          --   },
          --   ruff = {
          --     init_options = {
          --       settings = {
          --         logLevel = "debug",
          --       },
          --     },
          --   },
          --   htmx = {
          --     cmd = { "htmx-lsp", "--level", "DEBUG" },
          --   },
          -- },
        },
      },
    },
  },
}
