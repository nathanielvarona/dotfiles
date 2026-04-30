-- Disable Plugin
if true then
  return {}
end

return {
  {
    "m4xshen/hardtime.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    vscode = true, -- Include the use of VSCode to be Disciplined
    config = function()
      require("hardtime").setup({
        disable_mouse = false,
        hints = {
          ["k%^"] = {
            message = function()
              return "Use - instead of k^" -- return the hint message you want to display
            end,
            length = 2, -- the length of actual key strokes that matches this pattern
          },
          ["d[tTfF].i"] = { -- this matches d + {t/T/f/F} + {any character} + i
            message = function(keys) -- keys is a string of key strokes that matches the pattern
              return "Use " .. "c" .. keys:sub(2, 3) .. " instead of " .. keys
              -- example: Use ct( instead of dt(i
            end,
            length = 4,
          },
        },
      })
    end,
  },

  {
    "tris203/precognition.nvim",
    event = "VeryLazy",
    opts = {
      startVisible = true,
      showBlankVirtLine = true,
      highlightColor = { link = "Comment" },
      hints = {
        Caret = { text = "^", prio = 2 },
        Dollar = { text = "$", prio = 1 },
        MatchingPair = { text = "%", prio = 5 },
        Zero = { text = "0", prio = 1 },
        w = { text = "w", prio = 10 },
        b = { text = "b", prio = 9 },
        e = { text = "e", prio = 8 },
        W = { text = "W", prio = 7 },
        B = { text = "B", prio = 6 },
        E = { text = "E", prio = 5 },
      },
      gutterHints = {
        G = { text = "G", prio = 10 },
        gg = { text = "gg", prio = 9 },
        PrevParagraph = { text = "{", prio = 8 },
        NextParagraph = { text = "}", prio = 8 },
      },
      disabled_fts = {
        "startify",
      },
    },
  },
}
