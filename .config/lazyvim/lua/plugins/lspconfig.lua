return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "ty", -- Python LSP, and Linter
        "ruff", -- Python Formatter
        "htmx-lsp",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ty = {
          -- enabled = false,
          settings = {
            ty = {
              -- disableLanguageServices = true,
            },
          },
        },
        ruff = {
          -- enabled = false,
          cmd_env = { RUFF_TRACE = "messages" },
          init_options = {
            settings = {
              logLevel = "error",
            },
          },
          keys = {
            {
              "<leader>co",
              LazyVim.lsp.action["source.organizeImports"],
              desc = "Organize Imports",
            },
          },
        },
        htmx = {
          -- enabled = false,
          -- cmd = { "htmx-lsp", "--level", "DEBUG" },
        },
      },
    },
  },
}
