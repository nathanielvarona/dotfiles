return {
  "norcalli/nvim-colorizer.lua",
  config = function()
    -- require("colorizer").setup({}, { mode = "foreground" })
    require("colorizer").setup({}, { mode = "background" })
  end,
}
