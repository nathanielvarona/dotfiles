-- Disabled if Snacks Explorer is Enabled
if vim.g.lazyvim_picker == "snacks" then
  return {}
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_by_name = {
          ".git",
          ".DS_Store",
          "thumbs.db",
        },
        never_show = {},
      },
      window = {
        mappings = {
          ["d"] = "delete",
          ["D"] = "trash",
        },
      },
      commands = {
        trash = function(state)
          local utils = require("neo-tree.utils")
          local inputs = require("neo-tree.ui.inputs")
          local path = state.tree:get_node().path
          local _, name = utils.split_path(path)

          local msg = string.format("Are you sure you want to trash '%s'?", name)

          inputs.confirm(msg, function(confirmed)
            if not confirmed then
              return
            end

            vim.fn.system({ "trash", vim.fn.fnameescape(path) })

            require("neo-tree.sources.manager").refresh(state.name)
          end)
        end,

        trash_visual = function(state, selected_nodes)
          local inputs = require("neo-tree.ui.inputs")
          local msg = "Are you sure you want to trash " .. #selected_nodes .. " files ?"

          inputs.confirm(msg, function(confirmed)
            if not confirmed then
              return
            end
            for _, node in ipairs(selected_nodes) do
              vim.fn.system({ "trash", vim.fn.fnameescape(node.path) })
            end

            require("neo-tree.sources.manager").refresh(state.name)
          end)
        end,
      },
    },
    default_component_configs = {
      indent = {
        indent_size = 2,
        padding = 1,
        indent_guides = {
          enable = true,
        },
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
        highlight = "NeoTreeIndentMarker",
      },
    },
  },

  config = function(_, opts)
    vim.cmd("highlight NeoTreeIndentMarker guifg=#6c7086")
    require("neo-tree").setup(opts)
  end,

  keys = {
    -- {
    --   "<C-n>",
    --   ":Neotree filesystem reveal left<CR>",
    --   desc = "Toggle Neo-tree",
    --   noremap = true,
    --   silent = true,
    -- },
  },
}
