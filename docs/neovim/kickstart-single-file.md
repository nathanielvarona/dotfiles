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

## Clipboard over SSH (OSC 52)

`OSC 52` is a terminal escape sequence that asks the **terminal emulator** — the one on your desk, not the remote host — to write text to the system clipboard. Neovim sends the base64-encoded text in an escape sequence, it travels through SSH, and Windows Terminal writes it to the Windows clipboard. No `xclip` or other clipboard tool is needed on the server.

When `SSH_CONNECTION` or `SSH_TTY` is set, `init.lua` configures:

- a `vim.g.clipboard` provider backed by `vim.ui.clipboard.osc52`
- `clipboard=unnamedplus`, so `yy`, `d`, `c`, and visual yanks all copy to the local clipboard

The provider is registered before `clipboard` is set, so `:echo has('clipboard')` returns `1` on the server.

### Windows Terminal

No change is normally required: OSC 52 writes are enabled by default since Windows Terminal 1.2 (use 1.18 or newer for the current fixes). The switch lives under **Settings → Profiles → Defaults → Terminal Emulation → Allow applications to write to the clipboard**, which corresponds to the profile setting:

```json
"compatibility": {
  "allowOSC52": true
}
```

This repository's `run_once_12_set_windows_terminal_settings.ps1.tmpl` now sets that key explicitly, so a previous opt-out cannot silently disable copies.

Bracketed paste needs no setting; it is on by default, and `Ctrl+Shift+V` is the default paste binding.

### Pasting into the server

Windows Terminal supports OSC 52 **writes only** — clipboard reads (`OSC 52 ; c ; ?`) are blocked on Windows for security reasons. Paste into Neovim with the terminal's own paste shortcut, `Ctrl+Shift+V` (or right-click), which arrives as a bracketed paste.

Typing `"+p` over SSH shows a notification instead of hanging for ten seconds waiting for a clipboard reply that Windows Terminal will never send.

If your terminal does answer OSC 52 reads (kitty, WezTerm, foot, Ghostty), replace the `paste` handlers in the `SSH_CONNECTION` block with `osc52.paste '+'` / `osc52.paste '*'`, or simply force the built-in provider with:

```lua
vim.g.clipboard = 'osc52'
```

### tmux

OSC 52 passes through tmux when clipboard integration is enabled (the default on tmux 3.2+):

```tmux
set -g set-clipboard on
```

If copies do nothing inside tmux, also check `tmux show -g set-clipboard` and update tmux, or run Neovim outside tmux to confirm the sequence reaches the terminal.

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
