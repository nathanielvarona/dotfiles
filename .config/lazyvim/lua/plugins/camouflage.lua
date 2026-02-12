return {
  "zeybek/camouflage.nvim",
  event = "VeryLazy",

  opts = function(_, opts)
    opts = opts or {}

    local defaults = require("camouflage.config").defaults

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
    vim.list_extend(config.patterns, {
      {
        file_pattern = { "*.secrets", ".secrets*" },
        parser = "env",
      },
      {
        file_pattern = { "environment.plist" },
        parser = "xml",
      },
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
