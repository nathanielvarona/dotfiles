return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    opts.options.section_separators = {
      left = "",
      right = "",
    }
    opts.options.component_separators = {
      left = "│",
      right = "│",
    }

    local mode_map = {
      NORMAL = "N",
      ["O-PENDING"] = "O",
      INSERT = "I",
      VISUAL = "V",
      ["V-BLOCK"] = "VB",
      ["V-LINE"] = "VL",
      ["V-REPLACE"] = "VR",
      REPLACE = "R",
      COMMAND = "C",
      ["COMMAND-LINE"] = "CL",
      EX = "X",
      MORE = "M",
      CONFIRM = "Y",
      SELECT = "S",
      TERMINAL = "T",
    }

    opts.sections = opts.sections or {}
    opts.sections.lualine_a = {
      {
        "mode",
        fmt = function(res)
          return mode_map[res] or res
        end,
      },
    }
  end,
}
