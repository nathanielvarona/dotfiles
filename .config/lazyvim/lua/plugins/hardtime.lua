return {
  {
    "m4xshen/hardtime.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    vscode = true, -- Include the use of VSCode to be Disciplined
    config = function()
      require("hardtime").setup({

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
}
