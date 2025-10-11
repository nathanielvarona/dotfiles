return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_installation = true,
      -- Use this plugin if `LazyExtras` wont satisfies your needs for LSP.
      ensure_installed = {
        -- Already installed and available via `brew install haprer`
        -- "harper_ls",
        "ty", -- Python LSP and Linter (Type Checker)
        "ruff", -- Python LSP, Linter, and Formatter (Code Formatter)
        "htmx",
      },
    },
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {
          ensure_installed = {
            -- Already installed via `brew install tree-sitter-cli`
            -- "tree-sitter-cli",
          },
        },
      },
      {
        "neovim/nvim-lspconfig",

        -- NOTE:
        -- > If you want to override the default LSP custom settings.
        -- > Such as adding custom LSP flags to monitor Log level.

        opts = {
          servers = {
            -- Enable Harper Language Server
            harper_ls = {
              settings = {
                ["harper-ls"] = {
                  -- userDictPath = "",
                  -- workspaceDictPath = "",
                  -- fileDictPath = "",
                  linters = {
                    -- SpellCheck = false,
                    -- SpelledNumbers = false,
                    -- AnA = true,
                    SentenceCapitalization = false,
                    -- UnclosedQuotes = true,
                    -- WrongQuotes = false,
                    -- LongSentences = true,
                    -- RepeatedWords = true,
                    -- Spaces = true,
                    -- Matcher = true,
                    -- CorrectNumberSuffix = true,
                  },
                  -- codeActions = {
                  --   ForceStable = false,
                  -- },
                  -- markdown = {
                  --   IgnoreLinkTitle = false,
                  -- },
                  -- diagnosticSeverity = "hint",
                  -- isolateEnglish = false,
                  -- dialect = "American",
                  -- maxFileLength = 120000,
                  -- ignoredLintsPath = {},
                },
              },
            },
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
          },
        },
      },
    },
  },
}
