return {
  "mcauley-penney/visual-whitespace.nvim",
  config = true,
  event = "ModeChanged *:[vV\22]", -- optionally, lazy load on entering visual mode
  opts = {},
  init = function()
    -- vim.api.nvim_set_hl(0, "VisualNonText", { fg = "#5D5F71", bg = "#24282d" })
    vim.keymap.set({ "n", "v" }, "<leader>tw", require("visual-whitespace").toggle, {})
  end,
}
