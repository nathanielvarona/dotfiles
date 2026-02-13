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
    event = "VeryLazy",

    opts = function(_, opts)
      opts = opts or {}

      local defaults = require("camouflage.config").defaults

      local function add_unique_pattern(list, pattern)
        for _, p in ipairs(list) do
          if vim.deep_equal(p, pattern) then
            return
          end
        end
        table.insert(list, pattern)
      end

      -- Start with a copy of defaults
      local config = vim.deepcopy(defaults)

      -- Override only what you need
      config.style = "stars"

      config.colors = {
        foreground = "#808080",
        background = "transparent",
      }

      -- Check passwords against breach database
      config.pwned = {
        enabled = false,
      }

      -- Merge / override parsers
      config.parsers.env.include_export = true
      -- include_commented remains true from defaults

      -- Extend patterns
      config.patterns = config.patterns or {}

      add_unique_pattern(config.patterns, {
        file_pattern = {
          ".secret*",
          "*.secret*",
        },
        parser = "env",
      })

      add_unique_pattern(config.patterns, {
        file_pattern = {
          "environment.plist",
        },
        parser = "xml",
      })

      return config
    end,

    keys = {
      { "<leader>cxt", "<cmd>CamouflageToggle<cr>", desc = "Toggle Camouflage" },
      { "<leader>cxr", "<cmd>CamouflageReveal<cr>", desc = "Reveal Line" },
      { "<leader>cxy", "<cmd>CamouflageYank<cr>", desc = "Yank Value" },
      { "<leader>cxf", "<cmd>CamouflageFollowCursor<cr>", desc = "Follow Cursor" },
    },
  },
}
