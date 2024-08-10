return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("todo-comments").setup({
      keywords = {
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        DEBUG = { icon = " ", color = "debug" },
        REVIEW = { icon = " ", color = "warning" },
        HACK = { icon = " ", color = "hack" },
        QUESTION = { icon = " ", color = "question" },
        TODO = { icon = " ", color = "todo" },
        CHANGED = { icon = "󱖊 ", color = "changed" },
        OPTIMIZE = { icon = "󰅒 ", color = "optimize" },
        FIXME = { icon = " ", color = "fix" },
        BUG = { icon = " ", color = "bug" },
      },
      colors = {
        hint = { "#fab387" }, -- Peach (NOTE)
        debug = { "#f5c2e7" }, -- Pink (DEBUG)
        warning = { "#f38ba8" }, -- Red (REVIEW)
        hack = { "#cba6f7" }, -- Mauve (HACK)
        question = { "#94e2d5" }, -- Teal (QUESTION)
        todo = { "#89b4fa" }, -- Blue (TODO)
        changed = { "#74c7ec" }, -- Sapphire (CHANGED)
        optimize = { "#a6e3a1" }, -- Green (OPTIMIZE)
        fix = { "#eba0ac" }, -- Maroon (FIXME)
        bug = { "#f9e2af" }, -- Yellow (BUG)
      },
      highlight = {
        before = "empty", -- "fg" or "bg" or empty
        keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
        after = "empty", -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern used for highlight (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
      },
    })
  end,
}

--  # Test Todo Highlight
--[[
    # NOTE: text details
    # DEBUG: text details
    # REVIEW: text details
    # HACK: text details
    # QUESTION: text details
    # TODO: text details
    # CHANGED: text details
    # OPTIMIZE: text details
    # FIXME: text details
    # BUG: text details
--]]
