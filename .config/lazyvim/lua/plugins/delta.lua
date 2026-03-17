return {
  {
    "kokusenz/delta.lua",
    config = function()
      require("delta").setup({
        highlighting = {
          max_similarity_threshold = 0.4,
        },
      })
    end,
  },

  {
    "kokusenz/deltaview.nvim",
    config = function()
      require("deltaview").setup({})
    end,
  },
}
