return {
  "iamcco/markdown-preview.nvim",
  -- tag = "v0.0.10",
  -- dir = "~/Projects/contribute/neovim/plugins/markdown-preview.nvim",
  -- dev = true,
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  -- build = function()
  --   vim.fn["mkdp#util#install"]()
  -- end,
  build = "cd app && yarn install",
  keys = {
    {
      "<leader>cp",
      -- "<leader>mp",
      ft = "markdown",
      "<cmd>MarkdownPreviewToggle<cr>",
      desc = "Markdown Preview",
    },
  },
  -- init = function()
  --   vim.g.mkdp_filetypes = { "markdown" }
  -- end,
  -- ft = { "markdown" },
  config = function()
    vim.cmd([[do FileType]])
  end,
}
