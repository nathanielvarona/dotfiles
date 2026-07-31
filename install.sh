#!/bin/sh

set -eu

# ============================================================
# Dotfiles Installer (macOS / Linux)
# ============================================================

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

# ------------------------------------------------------------
# Homebrew
# ------------------------------------------------------------

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

# ------------------------------------------------------------
# Requirements
# ------------------------------------------------------------

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
