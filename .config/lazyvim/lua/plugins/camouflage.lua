return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.spec = opts.spec or {}

      table.insert(opts.spec, {
        "<leader>cx",
        group = "Camouflage",
      })

      return opts
    end,
  },

  {
    "zeybek/camouflage.nvim",
    lazy = false,
    priority = 1000,

    opts = function(_, opts)
      local defaults = require("camouflage.config").defaults

      -- Start from default patterns to preserve peconfigured patterns
      opts.patterns = vim.deepcopy(defaults.patterns)

      -------------------------------------------------
      -- Safe overrides
      -------------------------------------------------

      opts.style = "dotted"

      opts.highlight_group = "DiagnosticWarn"

      opts.reveal = {
        highlight_group = "DiagnosticInfo",
      }

      opts.pwned = vim.tbl_extend("force", opts.pwned or {}, {
        enabled = false,
      })

      -------------------------------------------------
      -- Extend parser config safely
      -------------------------------------------------

      opts.parsers = vim.tbl_deep_extend("force", {}, defaults.parsers, opts.parsers or {})

      opts.parsers.env.include_export = true

      -------------------------------------------------
      -- Extend file patterns safely
      -------------------------------------------------

      local function extend_pattern(parser, files)
        for _, p in ipairs(opts.patterns) do
          if p.parser == parser then
            local patterns = p.file_pattern

            if type(patterns) == "string" then
              patterns = { patterns }
            end

            patterns = patterns or {}

            ---@cast patterns string[]
            vim.list_extend(patterns, files)

            p.file_pattern = patterns
            return
          end
        end

        table.insert(opts.patterns, {
          parser = parser,
          file_pattern = files,
        })
      end

      extend_pattern("env", {

        ".secret*",
        "*.secret*",
      })

      extend_pattern("xml", {

        "environment.plist",
      })

      return opts
    end,

    keys = {
      { "<leader>cxt", "<cmd>CamouflageToggle<cr>", desc = "Toggle Camouflage" },
      { "<leader>cxr", "<cmd>CamouflageReveal<cr>", desc = "Reveal Line" },
      { "<leader>cxy", "<cmd>CamouflageYank<cr>", desc = "Yank Value" },
      { "<leader>cxf", "<cmd>CamouflageFollowCursor<cr>", desc = "Follow Cursor" },
    },
  },
}
