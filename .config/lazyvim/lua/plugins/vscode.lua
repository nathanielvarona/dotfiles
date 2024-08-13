--[[
  This file contains configuration settings specifically for the `vscode-neovim` extension.

  For more information about the `vscode-neovim` extension and its API usage,
  refer to the official documentation and repositories:

  GitHub Repository:
    - https://github.com/vscode-neovim/vscode-neovim

  Visual Studio Code Marketplace:
    - https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim
]]

return {
  -- Import the VSCode extras from LazyVim
  { import = "lazyvim.plugins.extras.vscode" },

  {
    -- Additional configuration for VSCode-specific setup
    "LazyVim/LazyVim",
    opts = function(_, opts)
      if not vim.g.vscode then
        return opts or {}
      end

      -- Load the vscode API for easier integration with VSCode commands
      local vscode = require("vscode")

      -- Define custom mappings to handle cursor movements with wrapped lines
      local mappings = {
        up = "k",
        down = "j",
        wrappedLineStart = "0",
        wrappedLineFirstNonWhitespaceCharacter = "^",
        wrappedLineEnd = "$",
      }

      -- Function to move the cursor using VSCode's cursorMove command
      local function moveCursor(to, select)
        return function()
          local mode = vim.api.nvim_get_mode().mode
          if mode == "V" or mode == "" then
            return mappings[to]
          end

          vscode.action("cursorMove", {
            args = {
              {
                to = to,
                by = "wrappedLine",
                value = vim.v.count1,
                select = select,
              },
            },
          })
          return "<Ignore>"
        end
      end

      -- Set up key mappings for normal and visual modes
      vim.keymap.set("n", "k", moveCursor("up"), { expr = true })
      vim.keymap.set("n", "j", moveCursor("down"), { expr = true })
      vim.keymap.set("n", "0", moveCursor("wrappedLineStart"), { expr = true })
      vim.keymap.set("n", "^", moveCursor("wrappedLineFirstNonWhitespaceCharacter"), { expr = true })
      vim.keymap.set("n", "$", moveCursor("wrappedLineEnd"), { expr = true })

      vim.keymap.set("v", "k", moveCursor("up", true), { expr = true })
      vim.keymap.set("v", "j", moveCursor("down", true), { expr = true })
      vim.keymap.set("v", "0", moveCursor("wrappedLineStart", true), { expr = true })
      vim.keymap.set("v", "^", moveCursor("wrappedLineFirstNonWhitespaceCharacter", true), { expr = true })
      vim.keymap.set("v", "$", moveCursor("wrappedLineEnd", true), { expr = true })

      -- Additional Vim motions and commands
      vim.keymap.set("n", "W", "w", { desc = "Move forward to the start of the next word" })
      vim.keymap.set("n", "B", "b", { desc = "Move backward to the start of the previous word" })
      vim.keymap.set("n", "gg", "gg", { desc = "Move to the beginning of the file" })
      vim.keymap.set("n", "G", "G", { desc = "Move to the end of the file" })

      vim.api.nvim_create_user_command(
        "NextParagraph",
        "normal! }",
        { desc = "Move to the start of the next paragraph" }
      )
      vim.api.nvim_create_user_command(
        "PrevParagraph",
        "normal! {",
        { desc = "Move to the start of the previous paragraph" }
      )

      vim.keymap.set("v", "p", '"_dP', { desc = "Paste over selection without affecting register" })
      vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
      vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

      -- Notify the user that VSCode-specific configuration has been loaded
      vim.notify("Neovim: LazyVim", vim.log.levels.INFO)

      return opts or {}
    end,
  },
}
