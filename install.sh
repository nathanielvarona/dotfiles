#!/bin/sh

set -eu

# ============================================================
# Dotfiles Installer (macOS / Linux / WSL)
# ============================================================
#
# Omarchy is a batteries-included Arch distribution. Its own package and mise
# layers already provide many CLI tools, so this installer avoids reinstalling
# or shadowing them there. On Omarchy it only ensures chezmoi is available and
# applies the dotfiles.

case "$(uname -s)" in
  Darwin | Linux)
    ;;
  *)
    printf 'Error: install.sh only supports macOS and Linux.\n' >&2
    exit 1
    ;;
esac

REPO="nathanielvarona"

test_command() {
  command -v "$1" > /dev/null 2>&1
}

is_omarchy() {
  if test_command omarchy; then
    return 0
  fi

  if [ -r /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    case "${ID:-}:${ID_LIKE:-}" in
      *omarchy*|*:arch*) return 0 ;;
    esac
  fi

  return 1
}

# ============================================================
# Omarchy / Arch path
# ============================================================
#
# Omarchy ships many development tools through pacman and mise. Installing the
# same tools again through Homebrew can create PATH conflicts, so bootstrap
# only chezmoi and let Omarchy own the rest.

if is_omarchy; then
  printf '\nOmarchy detected. Using its native package layer.\n\n'

  if ! test_command chezmoi; then
    printf 'Installing chezmoi via pacman...\n\n'

    if test_command sudo; then
      sudo pacman -S --needed --noconfirm chezmoi
    else
      pacman -S --needed --noconfirm chezmoi
    fi
  fi

  CHEZMOI="$(command -v chezmoi)"

  # Omarchy already owns many files under ~/.config. Back them up before chezmoi
  # overwrites anything, so the original desktop configuration can be restored.
  if [ -d "$HOME/.config" ]; then
    BACKUP="$HOME/.config.omarchy-backup.$(date +%Y%m%d%H%M%S)"
    printf 'Backing up existing ~/.config to %s\n\n' "$BACKUP"
    cp -a "$HOME/.config" "$BACKUP"
  fi

  printf '\nApplying dotfiles...\n\n'

  exec "$CHEZMOI" init --apply --force "$REPO"
fi

# ============================================================
# Debian/Ubuntu Prerequisites
# ============================================================

if test_command apt-get; then
  printf "\nChecking system dependencies...\n\n"

  sudo apt-get update

  sudo apt-get install -y \
    build-essential \
    procps \
    curl \
    file \
    git
fi

install_brew_package() {
  package="$1"
  command="${2:-$1}"

  if test_command "$command"; then
    printf '✓ %s already installed.\n' "$command"
    return
  fi

  printf 'Installing %s...\n' "$package"
  brew install "$package"
}

# ============================================================
# Homebrew
# ============================================================

if ! test_command brew; then
  printf '\nInstalling Homebrew...\n\n'

  if [ "$(id -u)" -ne 0 ] && command -v sudo > /dev/null 2>&1; then
    sudo -v
  fi

  /bin/bash -c "$(
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
  )" < /dev/tty

  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# ============================================================
# Requirements
# ============================================================

printf '\nBootstrapping development tools...\n\n'

install_brew_package zsh
install_brew_package git
install_brew_package delta
install_brew_package fzf
install_brew_package zoxide
install_brew_package oh-my-posh
install_brew_package zinit
install_brew_package chezmoi

# Refresh PATH
eval "$(brew shellenv)"

CHEZMOI="$(command -v chezmoi)"

printf '\nApplying dotfiles...\n\n'

exec "$CHEZMOI" init --apply "$REPO"
