return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    -- Unbind <leader><space>
    vim.api.nvim_set_keymap("n", "<leader><space>", "", { noremap = true, silent = true })

    -- Add keybinding to find files with hidden files included
    vim.api.nvim_set_keymap(
      "n",
      "<leader>fh",
      '<cmd>lua require("telescope.builtin").find_files({ hidden = true, no_ignore = true })<CR>',
      { noremap = true, silent = true }
    )
  end,
}
