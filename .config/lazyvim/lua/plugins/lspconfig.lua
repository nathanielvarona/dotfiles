return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      harper_ls = {
        settings = {
          ["harper-ls"] = {
            linters = {
              SentenceCapitalization = false,
              SpellCheck = false,
              LongSentences = false,
            },
          },
        },
      },
      bashls = {
        filetypes = {
          "sh",
          "zsh",
          "zshrc",
        },
      },
      html = {},
      htmx = {
        -- cmd = {
        --   "htmx-lsp",
        --   "--level",
        --   "DEBUG"
        -- },
      },
      -- pylsp = {},
      -- pyright = {
      --   settings = {
      --     python = {
      --       analysis = {
      --         autoSearchPaths = true,
      --         useLibraryCodeForTypes = true,
      --         diagnosticMode = 'openFilesOnly',
      --       },
      --     },
      --   }
      -- },
      ty = {
        init_options = {
          -- logLevel = "debug",
        },
        settings = {
          ty = {
            -- disableLanguageServices = true, -- if you want to use ty exclusively for type checking and want to use another language server like pyright
            inlayHints = {
              variableTypes = false,
              callArgumentNames = false,
            },
            experimental = {
              autoImport = true,
            },
          },
        },
      },
      ruff = {
        init_options = {
          settings = {
            -- logLevel = "debug",
            showSyntaxErrors = false,
            organizeImports = true,
          },
        },
      },
      djls = {},
      -- ltex = {
      --   enabled = false,
      --   settings = {
      --     ltex = {
      --       language = "en-US",
      --     },
      --   },
      -- }
      powershell_es = {},
    },
  },
}
