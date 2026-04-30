-- shared excludes
local exclude_base = {
  ".DS_Store",
}
local exclude_explorer = vim.list_extend(vim.deepcopy(exclude_base), {})
local exclude_files = vim.list_extend(vim.deepcopy(exclude_explorer), {
  "__pycache__",
  ".pnpm",
  ".venv",
  "ruff_cache",
  "media",
  "static",
  "assets",
  "node_modules",
  ".scannerwork",
})

return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    opts = opts or {}

    return vim.tbl_deep_extend("force", opts, {
      dashboard = {
        enabled = false,
      },
      styles = {
        snacks_image = {
          relative = "editor",
          col = -1,
        },
      },
      image = {
        enabled = true,
        doc = {
          inline = false,
          float = true,
          max_width = 60,
          max_height = 30,
        },
      },
      picker = {
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
            exclude = exclude_explorer,
          },
          files = {
            hidden = true,
            ignored = true,
            exclude = exclude_files,
          },
        },
      },
    })
  end,
}
