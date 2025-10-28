-- stylua: ignore
-- if true then return {} end

local highlight = {
  "RainbowBlue",
  "RainbowViolet",
  "RainbowRed",
  "RainbowYellow",
  "RainbowGreen",
  "RainbowOrange",
  "RainbowCyan",
}

local colors = {
  "#61AFEF", -- Blue
  "#C678DD", -- Violet
  "#E06C75", -- Red
  "#E5C07B", -- Yellow
  "#98C379", -- Green
  "#D19A66", -- Orange
  "#56B6C2", -- Cyan
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
