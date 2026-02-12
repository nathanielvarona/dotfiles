return {
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

    -- Merge / override parsers
    config.parsers.env.include_export = true
    -- include_commented remains true from defaults

    -- Extend patterns
    config.patterns = config.patterns or {}

    add_unique_pattern(config.patterns, {
      file_pattern = {
        "*.secrets",
        ".secrets*",
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
    { "<leader>ct", "<cmd>CamouflageToggle<cr>", desc = "Toggle Camouflage" },
    { "<leader>cr", "<cmd>CamouflageReveal<cr>", desc = "Reveal Line" },
    { "<leader>cy", "<cmd>CamouflageYank<cr>", desc = "Yank Value" },
    { "<leader>cf", "<cmd>CamouflageFollowCursor<cr>", desc = "Follow Cursor" },
  },
}
