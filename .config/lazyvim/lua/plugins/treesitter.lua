-- stylua: ignore
if true then return {} end

return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts, {
      ensure_installed = {
        "norg",
      },
    })
  end,
}
