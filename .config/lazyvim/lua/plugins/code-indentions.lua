-- stylua: ignore
-- if true then return {} end

local highlight = {
  "RainbowRed",
  "RainbowGreen",
  "RainbowOrange",
  "RainbowBlue",
  "RainbowYellow",
  "RainbowCyan",
  "RainbowViolet",
}

local colors = {
  "#E06C75", -- Red
  "#98C379", -- Green
  "#D19A66", -- Orange
  "#61AFEF", -- Blue
  "#E5C07B", -- Yellow
  "#56B6C2", -- Cyan
  "#C678DD", -- Violet
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
