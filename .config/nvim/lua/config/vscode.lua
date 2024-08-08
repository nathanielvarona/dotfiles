--[[
  This file contains configuration settings specifically for the `vscode-neovim` extension.

  For more information about the `vscode-neovim` extension and its API usage,
  refer to the official documentation and repositories:

  GitHub Repository:
    - https://github.com/vscode-neovim/vscode-neovim

  Visual Studio Code Marketplace:
    - https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim
]]

if vim.g.vscode then
  -- Load the vscode API for easier integration with VSCode commands
  local vscode = require("vscode")

  -- Define custom mappings to handle cursor movements with wrapped lines
  local mappings = {
    up = "k", -- Move up
    down = "j", -- Move down
    wrappedLineStart = "0", -- Move to the start of the wrapped line
    wrappedLineFirstNonWhitespaceCharacter = "^", -- Move to the first non-whitespace character on the wrapped line
    wrappedLineEnd = "$", -- Move to the end of the wrapped line
  }

  -- Function to move the cursor using VSCode's cursorMove command
  -- This function customizes cursor behavior for wrapped lines
  local function moveCursor(to, select)
    return function()
      local mode = vim.api.nvim_get_mode().mode
      -- If in visual mode, use normal NeoVim mappings
      if mode == "V" or mode == "" then
        return mappings[to]
      end

      -- Use VSCode's cursorMove command for normal mode
      vscode.action("cursorMove", {
        args = {
          {
            to = to,
            by = "wrappedLine", -- Move by wrapped line
            value = vim.v.count1, -- Repeat based on count prefix
            select = select, -- Handle selection in visual mode
          },
        },
      })
      return "<Ignore>"
    end
  end

  -- Set up key mappings for normal mode
  vim.keymap.set("n", "k", moveCursor("up"), { expr = true })
  vim.keymap.set("n", "j", moveCursor("down"), { expr = true })
  vim.keymap.set("n", "0", moveCursor("wrappedLineStart"), { expr = true })
  vim.keymap.set("n", "^", moveCursor("wrappedLineFirstNonWhitespaceCharacter"), { expr = true })
  vim.keymap.set("n", "$", moveCursor("wrappedLineEnd"), { expr = true })

  -- Set up key mappings for visual mode (selecting text)
  vim.keymap.set("v", "k", moveCursor("up", true), { expr = true })
  vim.keymap.set("v", "j", moveCursor("down", true), { expr = true })
  vim.keymap.set("v", "0", moveCursor("wrappedLineStart", true), { expr = true })
  vim.keymap.set("v", "^", moveCursor("wrappedLineFirstNonWhitespaceCharacter", true), { expr = true })
  vim.keymap.set("v", "$", moveCursor("wrappedLineEnd", true), { expr = true })

  -- Additional Vim motions and commands:
  -- Advanced Vim motions with descriptions
  vim.keymap.set("n", "W", "w", { desc = "Move forward to the start of the next word" })
  vim.keymap.set("n", "B", "b", { desc = "Move backward to the start of the previous word" })
  vim.keymap.set("n", "gg", "gg", { desc = "Move to the beginning of the file" })
  vim.keymap.set("n", "G", "G", { desc = "Move to the end of the file" })

  -- Define commands for navigating paragraphs
  vim.api.nvim_create_user_command("NextParagraph", "normal! }", { desc = "Move to the start of the next paragraph" })
  vim.api.nvim_create_user_command(
    "PrevParagraph",
    "normal! {",
    { desc = "Move to the start of the previous paragraph" }
  )

  -- Visual mode mappings for quick selections
  vim.keymap.set("v", "p", '"_dP', { desc = "Paste over selection without affecting register" })
  vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
  vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

  -- Notify the user that VSCode-specific configuration has been loaded
  vim.notify("VSCode-specific configuration loaded...", vim.log.levels.INFO)
end
