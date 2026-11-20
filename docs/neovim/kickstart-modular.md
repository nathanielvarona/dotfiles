# Kickstart Modular (`kickvim`)

An isolated [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim) setup installed alongside LazyVim.

| Item | Value |
| :--- | :--- |
| Source | `dot_config/kickmodvim/` |
| Deployed config | `~/.config/kickmodvim` |
| App name | `NVIM_APPNAME=kickmodvim` |
| Alias | `kickvim` |
| Theme | `github_dark_high_contrast` from [github-nvim-theme](https://github.com/projekt0n/github-nvim-theme) |

LazyVim remains the default configuration (`NVIM_APPNAME=lazyvim`). Launch this one with:

```bash
kickvim
# equivalent to:
NVIM_APPNAME=kickmodvim nvim
```

Because `NVIM_APPNAME` is set per invocation, the two configurations have completely separate config, plugins, state, and cache directories.

## Isolated paths (Linux / macOS / WSL)

| Purpose | Path |
| :--- | :--- |
| Config | `~/.config/kickmodvim` |
| Plugins (`vim.pack`) | `~/.local/share/kickmodvim/site/pack/core/opt` |
| State (undo, shada) | `~/.local/state/kickmodvim` |
| Cache | `~/.cache/kickmodvim` |

> [!NOTE]
> On Windows, Neovim uses the `%LOCALAPPDATA%` equivalents (`kickmodvim`, `kickmodvim-data`, and so on). The `kickvim` PowerShell function sets the same environment variable.

## Compared with default Neovim

| Area | Stock `nvim` | `kickvim` |
| :--- | :--- | :--- |
| Configuration | `~/.config/nvim` (optional, single file typical) | Modular Lua config in `~/.config/kickmodvim`, isolated from other setups |
| Plugin manager | `vim.pack` is available in Neovim 0.12+ but unused; older versions need `packadd` or an external manager | Declarative `vim.pack` plugin list (requires Neovim 0.12+) |
| Colorscheme | Built-in default | GitHub Dark High Contrast |
| Leader key | `\` | `Space` (also local leader) |
| Line numbers | Off | On, with cursor line and `scrolloff=10` |
| Clipboard | System clipboard only when explicitly used | `unnamedplus` synced with the OS |
| Search | Case-sensitive | Case-insensitive unless the pattern has capitals (`smartcase`) |
| Undo | Memory only | Persistent undo file |
| Splits | Default split placement | New splits open right and below |
| Completion | Built-in `ins-completion` only | `blink.cmp` + LuaSnip snippets |
| LSP | None | `lua_ls` and `stylua`, installed through Mason; helpers for adding more |
| Fuzzy finder | None | Telescope (files, grep, help, diagnostics, buffers, symbols) |
| Syntax highlighting | Regex-based | Tree-sitter (auto-installs available parsers) |
| Git integration | None | gitsigns (gutter signs, hunk actions, blame) |
| Formatting | Manual `=` / external commands | conform.nvim with manual `<leader>f`; LSP fallback |
| File explorer | `netrw` | Neo-tree sidebar (`\`) for browsing, plus Oil.nvim for editing directories as buffers (replaces `netrw` for directory buffers) |
| Statusline | None | `mini.statusline` (icons when a Nerd Font is enabled) |
| Navigation aids | None | which-key, `mini.ai`, `mini.surround`, guess-indent, todo-comments, yank highlight |

### Options changed from stock

These are set in `lua/options.lua`:

| Option | Value | Effect |
| :--- | :--- | :--- |
| `mapleader` / `maplocalleader` | `Space` | Leader is Space |
| `number` | `true` | Absolute line numbers |
| `mouse` | `a` | Mouse enabled in all modes |
| `showmode` | `false` | Mode is shown by the statusline instead |
| `clipboard` | `unnamedplus` | Use the OS clipboard by default |
| `breakindent` | `true` | Wrapped lines keep indentation |
| `undofile` | `true` | Undo history persists across sessions |
| `ignorecase` / `smartcase` | `true` | Case-insensitive search with smart case |
| `signcolumn` | `yes` | Always reserve the sign column |
| `updatetime` | `250` | Faster diagnostics and CursorHold |
| `timeoutlen` | `300` | Shorter key sequence timeout |
| `splitright` / `splitbelow` | `true` | Natural split placement |
| `list` / `listchars` | `true`; tabs `»`, trailing spaces `·`, non-breaking spaces `␣` | Visible whitespace characters |
| `inccommand` | `split` | Live substitution preview |
| `cursorline` | `true` | Highlight the current line |
| `scrolloff` | `10` | Keep context around the cursor |
| `confirm` | `true` | Prompt instead of failing on unsaved changes |

Diagnostics are configured in `lua/keymaps.lua` with rounded floats, severity sorting, virtual text, and an auto-opened float when jumping between diagnostics.

## Plugins installed

Enabled modules are required from `lua/plugins.lua`. All plugins are managed with `vim.pack`.

| Module | Plugin(s) | Purpose |
| :--- | :--- | :--- |
| `github-theme` | `projekt0n/github-nvim-theme` | GitHub Dark High Contrast colorscheme |
| `guess-indent` | `NMAC427/guess-indent.nvim` | Detect and apply file indentation |
| `gitsigns` | `lewis6991/gitsigns.nvim` | Git gutter signs, hunk staging/reset, blame, diff |
| `lazygit` | `kdheepak/lazygit.nvim` | Full lazygit TUI inside Neovim |
| `which-key` | `folke/which-key.nvim` | Show pending keybindings and groups |
| `todo-comments` | `folke/todo-comments.nvim` | Highlight `TODO`, `FIXME`, `NOTE`, etc. |
| `mini` | `nvim-mini/mini.nvim` | `mini.ai`, `mini.surround`, `mini.statusline`, optional `mini.icons` |
| `telescope` | `telescope.nvim`, `plenary.nvim`, `telescope-ui-select.nvim`, `telescope-fzf-native.nvim` (when `make` exists) | Fuzzy finding and pickers |
| `neo-tree` | `neo-tree.nvim`, `nui.nvim`, `plenary.nvim` | Sidebar file tree |
| `oil` | `stevearc/oil.nvim` | File explorer and filesystem editing as a buffer |
| `lspconfig` | `nvim-lspconfig`, `mason.nvim`, `mason-lspconfig.nvim`, `mason-tool-installer.nvim`, `fidget.nvim` | LSP client, server/tool installation, progress UI |
| `conform` | `stevearc/conform.nvim` | Formatting with LSP fallback |
| `blink-cmp` | `saghen/blink.cmp`, `L3MON4D3/LuaSnip` | Completion menu and snippets |
| `treesitter` | `nvim-treesitter` (`main` branch) | Parsing, highlighting, indentation |

### Included but disabled

These modules exist in `lua/kickstart/plugins/` but are commented out in `lua/plugins.lua`: `autopairs`, `debug`, `indent_line`, and `lint`.

### LSP and formatting defaults

- `lua_ls` is configured for Lua editing but its formatting is disabled; `stylua` handles Lua formatting.
- The other servers in `lua/kickstart/plugins/lspconfig.lua` are commented out. Uncomment or add entries to the `servers` table and Mason will install/enable them.
- Mason is available with `:Mason`. Installed servers live under the isolated data directory.
- conform has no formatters mapped by default beyond the manual `<leader>f` command; add filetypes and formatters in `lua/kickstart/plugins/conform.lua`.
- Tree-sitter preinstalls `bash`, `c`, `diff`, `html`, `lua`, `luadoc`, `markdown`, `markdown_inline`, `query`, `vim`, and `vimdoc`. Other available parsers install automatically when a matching filetype is opened.

## Keymaps

`<leader>` is `Space`. Wait briefly on a prefix to let which-key show the available mappings. Mode is normal unless noted.

### Core

| Key | Action |
| :--- | :--- |
| `<Esc>` | Clear search highlights |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Move focus to the left / lower / upper / right window |
| `<leader>q` | Open diagnostics in the location list |
| `<Esc><Esc>` (terminal mode) | Leave terminal mode |
| Yank (e.g. `yap`) | Briefly highlight yanked text |

### Search (Telescope)

| Key | Action |
| :--- | :--- |
| `<leader>sf` | Find files |
| `<leader>sg` | Live grep |
| `<leader>sw` | Grep the current word/selection |
| `<leader>sh` | Search help tags |
| `<leader>sk` | Search keymaps |
| `<leader>ss` | Select a Telescope picker |
| `<leader>sd` | Search diagnostics |
| `<leader>sr` | Resume the previous picker |
| `<leader>s.` | Recent files |
| `<leader>sc` | Search commands |
| `<leader>s/` | Live grep in open files |
| `<leader>sn` | Find files in the Neovim config directory |
| `<leader>/` | Fuzzy-find in the current buffer |
| `<leader><leader>` | Find existing buffers |

Inside a Telescope picker: `?` in normal mode or `<C-/>` in insert mode shows that picker's keymaps.

### File explorer (Neo-tree)

| Key | Action |
| :--- | :--- |
| `\` | Reveal the current file in the Neo-tree sidebar |
| `\` (inside Neo-tree) | Close the sidebar |
| `<CR>` | Open the entry under the cursor |
| `a` / `A` | Add a file / directory |
| `d` | Delete the entry |
| `r` | Rename the entry |
| `y` / `x` / `p` | Copy / cut / paste entries |
| `R` | Refresh the tree |
| `H` | Toggle hidden files |
| `q` | Close the sidebar |

### File explorer (Oil)

Editing the listing and saving with `:w` applies the changes to the filesystem; quitting without saving discards them.

| Key | Action |
| :--- | :--- |
| `-` | Open the parent directory of the current file (or the current directory) |
| `-` (inside Oil) | Go to the parent directory |
| `<CR>` | Open the entry under the cursor |
| `<C-v>` / `<C-s>` / `<C-t>` | Open the entry in a vertical split / split / new tab |
| `<C-p>` | Toggle the preview |
| `<C-l>` | Refresh the listing |
| `<C-c>` | Close Oil |
| `g?` | Show Oil's help with all mappings |

### LSP (active buffers)

These are buffer-local and only exist after a language server attaches.

| Key | Action |
| :--- | :--- |
| `grn` | Rename symbol |
| `gra` | Code action (normal and visual) |
| `grD` | Go to declaration |
| `grd` | Go to definition (Telescope) |
| `grr` | Find references (Telescope) |
| `gri` | Go to implementation (Telescope) |
| `grt` | Go to type definition (Telescope) |
| `gO` | Document symbols (Telescope) |
| `gW` | Workspace symbols (Telescope) |
| `<leader>th` | Toggle inlay hints (when supported) |

### Git (gitsigns, git-tracked buffers)

| Key | Action |
| :--- | :--- |
| `]c` / `[c` | Jump to next / previous changed hunk |
| `<leader>hs` | Stage hunk (normal and visual) |
| `<leader>hr` | Reset hunk (normal and visual) |
| `<leader>hS` | Stage buffer |
| `<leader>hR` | Reset buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hi` | Preview hunk inline |
| `<leader>hb` | Blame line (full) |
| `<leader>hd` | Diff against the index |
| `<leader>hD` | Diff against the last commit |
| `<leader>hq` / `<leader>hQ` | Hunks to quickfix (file / whole repo) |
| `<leader>tb` | Toggle current-line blame |
| `<leader>tw` | Toggle intra-line word diff |
| `ih` (operator/visual) | Select the hunk as a text object |
| `<leader>gg` | Open LazyGit |

LazyGit also exposes `:LazyGit`, `:LazyGitCurrentFile`, `:LazyGitFilter`, `:LazyGitFilterCurrentFile`, and `:LazyGitConfig`. It requires the `lazygit` binary on your `PATH`; close it with `q`.

### Editing (mini.nvim)

| Key | Action |
| :--- | :--- |
| `aa` / `ii` | Around / inside a text object (e.g. `va)`, `yiiq`, `ci'`) |
| `sa` | Add a surrounding (e.g. `saiw)`) |
| `sd` | Delete a surrounding (e.g. `sd'`) |
| `sr` | Replace a surrounding (e.g. `sr)'`) |
| `sf` / `sF` | Find a surrounding to the right / left |
| `sh` | Highlight a surrounding |

### Completion (blink.cmp, insert mode)

| Key | Action |
| :--- | :--- |
| `<C-space>` | Open the menu, or show docs when already open |
| `<C-n>` / `<C-p>` (or arrows) | Select next / previous item |
| `<C-y>` | Accept the selection |
| `<C-e>` | Hide the menu |
| `<C-k>` | Toggle signature help |
| `<Tab>` / `<S-Tab>` | Move forward / backward through snippet placeholders |

### Formatting

| Key | Action |
| :--- | :--- |
| `<leader>f` | Format the buffer (normal and visual) via conform, falling back to LSP |

### Which-key groups

| Prefix | Group |
| :--- | :--- |
| `<leader>s` | Search |
| `<leader>t` | Toggle |
| `<leader>h` | Git hunk |
| `gr` | LSP actions |

## Customizing

- **Add a plugin:** drop a Lua file in `lua/custom/plugins/` and it is loaded automatically by `lua/custom/plugins/init.lua`. Keep plugins that depend on each other in the same file because load order is unspecified.
- **Enable an optional kickstart module:** uncomment its `require` in `lua/plugins.lua`.
- **Change or disable the file explorer:** edit `lua/kickstart/plugins/oil.lua`; set `default_file_explorer = false` to leave directory buffers to another plugin or `netrw`.
- **Change the theme:** edit `lua/kickstart/plugins/github-theme.lua`, change `theme_style`, and update the `vim.cmd.colorscheme` name.
- **Add a language server:** add it to the `servers` table in `lua/kickstart/plugins/lspconfig.lua` (and any required settings), then restart Neovim.
- **Use a Nerd Font:** set `vim.g.have_nerd_font = true` in `lua/options.lua` to enable icons in mini and which-key.

## Health, updates, and reset

```vim
:checkhealth kickstart   " verify Neovim version and external tools
:Mason                   " inspect installed LSP servers and tools
:lua vim.pack.update()   " update all vim.pack plugins
:Telescope               " discover pickers
```

External requirements: `git`, `make`, `unzip`, a C compiler, `ripgrep`, `fd`, `lazygit`, the Tree-sitter CLI, and a clipboard tool for your platform. A Nerd Font is optional.

To reset only this setup (Linux/macOS/WSL):

```bash
rm -Rf ~/.config/kickmodvim ~/.local/share/kickmodvim \
  ~/.local/state/kickmodvim ~/.cache/kickmodvim
```

Then run `chezmoi apply` to restore the config. Plugins will reinstall on the next launch.
