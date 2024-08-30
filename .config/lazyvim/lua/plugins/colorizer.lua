return {
  "norcalli/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup({
      "lua",
      "css",
      "md",
    }, {
      mode = "background",
      names = false,
    })
  end,
}
