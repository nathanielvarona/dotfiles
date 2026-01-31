return {
  "folke/todo-comments.nvim",
  opts = {
    keywords = {
      BUG = { icon = " ", color = "bug" }, -- Critical, highest severity
      FIXME = { icon = " ", color = "fix_color" }, -- Needs fixing, high severity
      WARNING = { icon = " ", color = "warning" }, -- Needs attention, medium severity
      NOTE = { icon = " ", color = "note" }, -- Informative, low severity
      OPTIMIZE = { icon = " ", color = "optimization" }, -- Optimization needed, high severity
      HINT = { icon = " ", color = "hint" }, -- Informative, low severity
      CHANGED = { icon = " ", color = "changed" }, -- Recent changes, medium-high severity
      TODO = { icon = " ", color = "todo" }, -- To be done, medium-high severity
      REVIEW = { icon = " ", color = "review" }, -- Needs review, medium severity
      QUESTION = { icon = " ", color = "question" }, -- Needs clarification, medium severity
      HACK = { icon = " ", color = "hack" }, -- Temporary workaround, medium severity
      DEBUG = { icon = " ", color = "debug" }, -- Debugging, low-medium severity
    },
    colors = {
      bug = { "#f38ba8" }, -- Red (BUG)
      fix_color = { "#fab387" }, -- Orange (FIXME)
      warning = { "#f9e2af" }, -- Yellow (WARNING)
      note = { "#a6e3a1" }, -- Green (NOTE)
      optimization = { "#89b4fa" }, -- Blue (OPTIMIZE)
      hint = { "#94e2d5" }, -- Teal (HINT)
      changed = { "#74c7ec" }, -- Sapphire (CHANGED)
      todo = { "#b4befe" }, -- Blue (TODO)
      review = { "#89dceb" }, -- Sky (REVIEW)
      question = { "#cba6f7" }, -- Mauve (QUESTION)
      hack = { "#f5c2e7" }, -- Pink (HACK)
      debug = { "#eba0ac" }, -- Maroon (DEBUG)
    },
    highlight = {
      before = "", -- "fg" or "bg" or empty
      keyword = "bg", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
      after = "", -- "fg" or "bg" or empty
      pattern = [[.*<(KEYWORDS)\s*:]], -- pattern used for highlight (vim regex)
      comments_only = true, -- uses treesitter to match keywords in comments only
      max_line_len = 400, -- ignore lines longer than this
      exclude = {}, -- list of file types to exclude highlighting
    },
  },
}

--  # Test Todo Highlight
--[[
    # BUG: text details
    # FIXME: text details
    # WARNING: text details
    # NOTE: text details
    # OPTIMIZE: text details
    # HINT: text details
    # CHANGED: text details
    # TODO: text details
    # REVIEW: text details
    # QUESTION: text details
    # HACK: text details
    # DEBUG: text details
--]]
