#!/bin/sh
# Bootstrap kickstart.nvim on a remote/server machine.
#
# Installs Neovim 0.12+ (if needed) and copies the single-file kickstart
# init.lua to ~/.config/nvim/init.lua, then installs plugins once.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/nathanielvarona/dotfiles/main/scripts/kickstart-nvim.sh | sh
#
# Environment overrides:
#   NVIM_VERSION         Neovim tag to install, e.g. v0.12.6 (default: latest release)
#   NVIM_INSTALL_DIR     Where the Neovim tarball is unpacked (default: ~/.local/opt/nvim)
#   KICKSTART_INIT_URL   Source of init.lua (default: this dotfiles repo, main branch)
#   SKIP_NVIM_INSTALL=1  Only copy init.lua, never download Neovim
#   SKIP_PLUGIN_INSTALL=1 Do not run the first-launch plugin install
#
# The config is only used when NVIM_APPNAME is unset. If that variable is
# exported in your shell (e.g. NVIM_APPNAME=lazyvim), run `unset NVIM_APPNAME`
# or `NVIM_APPNAME=nvim nvim`.

set -eu

REPO_RAW="${REPO_RAW:-https://raw.githubusercontent.com/nathanielvarona/dotfiles/main}"
KICKSTART_INIT_URL="${KICKSTART_INIT_URL:-$REPO_RAW/dot_config/nvim/init.lua}"
NVIM_INSTALL_DIR="${NVIM_INSTALL_DIR:-$HOME/.local/opt/nvim}"
MIN_MAJOR=0
MIN_MINOR=12

say() { printf '%s\n' "$*"; }
warn() { printf 'warning: %s\n' "$*" >&2; }
die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

need() { command -v "$1" >/dev/null 2>&1 || die "required command not found: $1"; }

need curl
need tar
need mktemp

nvim_ok() {
  command -v nvim >/dev/null 2>&1 || return 1
  version=$(nvim --version | sed -n '1s/.*v\([0-9]*\)\.\([0-9]*\).*/\1 \2/p')
  [ -n "$version" ] || return 1
  major=${version% *}
  minor=${version#* }
  [ "$major" -gt "$MIN_MAJOR" ] || { [ "$major" -eq "$MIN_MAJOR" ] && [ "$minor" -ge "$MIN_MINOR" ]; }
}

detect_asset() {
  os=$(uname -s)
  arch=$(uname -m)
  case "$arch" in
    x86_64 | amd64) arch=x86_64 ;;
    aarch64 | arm64) arch=arm64 ;;
    *) die "unsupported CPU architecture: $arch" ;;
  esac
  case "$os" in
    Linux) printf 'nvim-linux-%s.tar.gz' "$arch" ;;
    Darwin) printf 'nvim-macos-%s.tar.gz' "$arch" ;;
    *) die "unsupported OS: $os (this script covers Linux, macOS, and WSL)" ;;
  esac
}

install_nvim() {
  asset=$(detect_asset)

  if [ -z "${NVIM_VERSION:-}" ]; then
    NVIM_VERSION=$(curl -fsSL https://api.github.com/repos/neovim/neovim/releases/latest 2>/dev/null |
      sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -n 1) || true
    [ -n "${NVIM_VERSION:-}" ] || NVIM_VERSION=v0.12.6
  fi

  url="https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/$asset"
  say "Installing Neovim $NVIM_VERSION ($asset) to $NVIM_INSTALL_DIR"

  tmp=$(mktemp -d)
  trap 'rm -rf "$tmp"' EXIT INT TERM
  curl -fL --progress-bar "$url" -o "$tmp/nvim.tar.gz" || die "download failed: $url"
  tar -xzf "$tmp/nvim.tar.gz" -C "$tmp" || die "failed to extract $asset"

  mkdir -p "$(dirname "$NVIM_INSTALL_DIR")"
  rm -rf "$NVIM_INSTALL_DIR"
  mv "$tmp"/nvim-* "$NVIM_INSTALL_DIR" || die "failed to install to $NVIM_INSTALL_DIR"

  mkdir -p "$HOME/.local/bin"
  ln -sf "$NVIM_INSTALL_DIR/bin/nvim" "$HOME/.local/bin/nvim"
  say "Linked $HOME/.local/bin/nvim"

  case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) warn "$HOME/.local/bin is not on PATH; add: export PATH=\"\$HOME/.local/bin:\$PATH\"" ;;
  esac
}

install_config() {
  config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
  mkdir -p "$config_dir"

  if [ -f "$config_dir/init.lua" ]; then
    backup="$config_dir/init.lua.bak.$(date +%Y%m%d%H%M%S)"
    cp "$config_dir/init.lua" "$backup"
    say "Backed up existing init.lua to $backup"
  fi

  say "Fetching kickstart init.lua from $KICKSTART_INIT_URL"
  curl -fsSL "$KICKSTART_INIT_URL" -o "$config_dir/init.lua" || die "failed to download init.lua"

  if [ "$(wc -c <"$config_dir/init.lua" | tr -d ' ')" -lt 1000 ]; then
    die "downloaded init.lua looks truncated: $config_dir/init.lua"
  fi
  say "Wrote $config_dir/init.lua"
}

check_optional() {
  command -v git >/dev/null 2>&1 || die "git is required: vim.pack clones plugins with it"
  command -v make >/dev/null 2>&1 || warn "make not found; optional Telescope/LuaSnip build steps are skipped"
  command -v unzip >/dev/null 2>&1 || warn "unzip not found; some plugins may not install"
  command -v rg >/dev/null 2>&1 || warn "ripgrep not found; live grep will not work"
  if ! command -v fd >/dev/null 2>&1 && ! command -v fdfind >/dev/null 2>&1; then
    warn "fd not found; Telescope file finding falls back to a slower method"
  fi
}

main() {
  check_optional

  if [ "${SKIP_NVIM_INSTALL:-0}" != 1 ]; then
    if nvim_ok; then
      say "Neovim $(nvim --version | head -n 1 | sed 's/^NVIM //') already has vim.pack support; skipping install"
    else
      install_nvim
    fi
  fi

  install_config

  if command -v nvim >/dev/null 2>&1 && [ "${SKIP_PLUGIN_INSTALL:-0}" != 1 ]; then
    say "Installing plugins (first launch takes a minute) ..."
    if ! nvim --headless '+qa' 2>&1; then
      warn "plugin install reported errors; open nvim and run :lua vim.pack.update()"
    fi
  fi

  say ''
  say 'Done. Start Neovim with:'
  say '  unset NVIM_APPNAME   # if your shell exports one'
  say '  nvim'
  say ''
  say 'Useful: :lua vim.pack.update() to update plugins, :checkhealth kickstart'
}

main "$@"
