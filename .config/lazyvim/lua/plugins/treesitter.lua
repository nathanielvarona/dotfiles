return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts, {
      ensure_installed = {
        "latex",
        "norg",
        "svelte",
        "typst",
        "vue",
      },
    })
  end,
}
