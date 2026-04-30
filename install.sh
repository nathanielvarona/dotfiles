#!/usr/bin/env sh

set -e

echo "Installing dotfiles using chezmoi..."

# ---------------------------------------------------------
# Ensure ~/.local/bin is in PATH
# ---------------------------------------------------------
export PATH="$HOME/.local/bin:$PATH"

# ---------------------------------------------------------
# Detect OS
# ---------------------------------------------------------
OS="$(uname -s)"

# ---------------------------------------------------------
# Setup Homebrew (macOS + Linux)
# ---------------------------------------------------------

setup_brew() {
  if command -v brew > /dev/null 2>&1; then
    echo "Homebrew already installed"
    return
  fi

  echo "Installing Homebrew..."

  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

init_brew_env() {
  # macOS (Apple Silicon)
  if [ -x "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  # macOS (Intel)
  elif [ -x "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  # Linuxbrew
  elif [ -x "$HOME/.linuxbrew/bin/brew" ]; then
    eval "$($HOME/.linuxbrew/bin/brew shellenv)"
  elif [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
}

# Install brew if missing (macOS + Linux)
if [ "$OS" = "Darwin" ] || [ "$OS" = "Linux" ]; then
  if ! command -v brew > /dev/null 2>&1; then
    setup_brew
  fi
  init_brew_env
fi

# ---------------------------------------------------------
# Install chezmoi if missing
# ---------------------------------------------------------

if ! command -v chezmoi > /dev/null 2>&1; then
  echo "chezmoi not found, installing..."

  BIN_DIR="$HOME/.local/bin"
  mkdir -p "$BIN_DIR"

  if command -v curl > /dev/null 2>&1; then
    sh -c "$(curl -fsSL get.chezmoi.io)" -- -b "$BIN_DIR"
  elif command -v wget > /dev/null 2>&1; then
    sh -c "$(wget -qO- get.chezmoi.io)" -- -b "$BIN_DIR"
  else
    echo "Error: curl or wget required to install chezmoi." >&2
    exit 1
  fi

  CHEZMOI="$BIN_DIR/chezmoi"
else
  echo "chezmoi found, using existing installation"
  CHEZMOI="$(command -v chezmoi)"
fi

# ---------------------------------------------------------
# Apply dotfiles
# ---------------------------------------------------------

echo "Initializing dotfiles..."

exec "$CHEZMOI" init --apply nathanielvarona
