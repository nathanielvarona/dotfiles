-- stylua: ignore
-- if true then return {} end

return {
  "folke/snacks.nvim",
  config = function()
    local scooter_term = nil

    -- Called by scooter to open the selected file at the correct line from the scooter search list
    _G.EditLineFromScooter = function(file_path, line)
      if scooter_term and scooter_term:buf_valid() then
        scooter_term:hide()
      end

      local current_path = vim.fn.expand("%:p")
      local target_path = vim.fn.fnamemodify(file_path, ":p")

      if current_path ~= target_path then
        vim.cmd.edit(vim.fn.fnameescape(file_path))
      end

      vim.api.nvim_win_set_cursor(0, { line, 0 })
    end

    local function is_terminal_running(term)
      if not term or not term:buf_valid() then
        return false
      end
      local channel = vim.fn.getbufvar(term.buf, "terminal_job_id")
      return channel and vim.fn.jobwait({ channel }, 0)[1] == -1
    end

    local function open_scooter()
      if is_terminal_running(scooter_term) then
        scooter_term:toggle()
      else
        scooter_term = require("snacks").terminal.open("scooter", {
          win = { position = "float" },
        })
      end
    end

    local function open_scooter_with_text(search_text)
      if scooter_term and scooter_term:buf_valid() then
        scooter_term:close()
      end

      local escaped_text = vim.fn.shellescape(search_text:gsub("\r?\n", " "))
      scooter_term = require("snacks").terminal.open("scooter --fixed-strings --search-text " .. escaped_text, {
        win = { position = "float" },
      })
    end

    vim.keymap.set("n", "<leader>sf", open_scooter, { desc = "Open Scooter" })
    vim.keymap.set("v", "<leader>sf", function()
      local search_text = vim.fn.getregion()
      open_scooter_with_text(search_text)
    end, { desc = "Open Scooter with selected text" })
  end,
}
