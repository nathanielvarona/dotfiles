# Kickstart (single file)

Upstream [`kickstart.nvim`](https://github.com/nvim-lua/kickstart.nvim) as one self-contained `init.lua`. This is the configuration for stock `nvim` — the default `~/.config/nvim` — and is intended for remote servers where the whole setup is "install Neovim, copy one file".

| | |
| :--- | :--- |
| Source | `dot_config/nvim/init.lua` (deployed to `~/.config/nvim/init.lua`) |
| App name | Default `nvim` (no `NVIM_APPNAME`) |
| Plugin manager | `vim.pack` (built into Neovim 0.12+) |
| Theme | `tokyonight-night` (upstream default) |
| Installer | `scripts/kickstart-nvim.sh` |

> [!TIP]
> Plain `nvim` loads this config. LazyVim remains available through the `lazyvim` shell function, which sets `NVIM_APPNAME=lazyvim` for that invocation.

## Install on a remote server

```bash
curl -fsSL https://raw.githubusercontent.com/nathanielvarona/dotfiles/main/scripts/kickstart-nvim.sh | sh
```

The script:

1. Checks for Neovim 0.12 or newer and, if needed, downloads the latest release tarball for Linux (`x86_64`/`arm64`) or macOS into `~/.local/opt/nvim`, linking `~/.local/bin/nvim`.
2. Copies `init.lua` from this repository to `~/.config/nvim/init.lua`, backing up any existing file first.
3. Runs Neovim once headlessly so `vim.pack` installs every plugin.

Requirements: `curl`, `tar`, and `git`. Optional but recommended: `make`, `unzip`, `ripgrep`, `fd`, a C compiler, and a clipboard tool. The script warns when these are missing.

Re-running the script updates the config (with a timestamped backup) and leaves existing plugins in place.

### Options

Set these before `sh`:

| Variable | Default | Effect |
| :--- | :--- | :--- |
| `NVIM_VERSION` | latest release | Tag to install, e.g. `v0.12.6` |
| `NVIM_INSTALL_DIR` | `~/.local/opt/nvim` | Where Neovim is unpacked |
| `KICKSTART_INIT_URL` | this repo's `main` branch | Alternate `init.lua` |
| `SKIP_NVIM_INSTALL` | unset | `1` copies only the config |
| `SKIP_PLUGIN_INSTALL` | unset | `1` skips the first-launch plugin install |

```bash
curl -fsSL https://raw.githubusercontent.com/nathanielvarona/dotfiles/main/scripts/kickstart-nvim.sh |
  SKIP_NVIM_INSTALL=1 sh
```

### Manual copy

Without the script, the same result is:

```bash
mkdir -p ~/.config/nvim
curl -fsSL https://raw.githubusercontent.com/nathanielvarona/dotfiles/main/dot_config/nvim/init.lua \
  -o ~/.config/nvim/init.lua
nvim --headless '+qa'   # install plugins on first launch
```

## Daily use

| Command | Purpose |
| :--- | :--- |
| `:lua vim.pack.update()` | Update all plugins |
| `:checkhealth kickstart` | Check version and external tools |
| `:Telescope` | Open the picker menu |
| `:Mason` | Inspect LSP servers and tools |

The file is documented top-to-bottom with numbered sections (options, keymaps, plugin manager, UI, search, LSP, formatting, completion, treesitter). Editing it locally is enough; other machines pick up changes on the next run of the installer or by copying the file.

## Reset

```bash
rm -Rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```

Then re-run the installer.
