local highlight = {
  "RainbowRed",
  "RainbowYellow",
  "RainbowBlue",
  "RainbowOrange",
  "RainbowGreen",
  "RainbowViolet",
  "RainbowCyan",
}

local colors = {
  "#E06C75",
  "#E5C07B",
  "#61AFEF",
  "#D19A66",
  "#98C379",
  "#C678DD",
  "#56B6C2",
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
        char = "▎",
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
