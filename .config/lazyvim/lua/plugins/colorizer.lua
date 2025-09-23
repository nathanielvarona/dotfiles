return {
  "norcalli/nvim-colorizer.lua",
  branch = "master",
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
