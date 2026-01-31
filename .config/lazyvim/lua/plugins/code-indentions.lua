local highlight = {
  "RainbowBlue",
  "RainbowGreen",
  "RainbowYellow",
  "RainbowPurple",
  "RainbowRed",
  "RainbowIndigo",
  "RainbowCyan",
  "RainbowOrange",
  "RainbowViolet",
}

local colors = {
  "#7AC7FF", -- Lighter Blue
  "#AFF7A0", -- Lighter Green
  "#FFD77A", -- Lighter Yellow
  "#B77AFF", -- Lighter Purple
  "#FF7A7A", -- Lighter Red
  "#6A5ACD", -- Lighter Indigo
  "#7AD7D7", -- Lighter Cyan
  "#FFC07A", -- Lighter Orange
  "#D7A0FF", -- Lighter Violet
}

local function setup_highlights()
  for i, hl_group in ipairs(highlight) do
    vim.api.nvim_set_hl(0, hl_group, { fg = colors[i] })
  end
end

local hooks = require("ibl.hooks")
hooks.register(hooks.type.HIGHLIGHT_SETUP, setup_highlights)

return {
  {
    "folke/snacks.nvim",
    opts = {
      indent = {
        enabled = false,
      },
    },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      vim.g.rainbow_delimiters = { highlight = highlight }
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      indent = {
        -- char = "│",
        -- tab_char = "│",
        highlight = highlight,
      },
      scope = {
        show_start = false,
        show_end = false,
        highlight = highlight,
      },
    },
    config = function(_, opts)
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
      require("ibl").setup(opts)
    end,
  },
}
