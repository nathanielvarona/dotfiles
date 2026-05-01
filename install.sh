#!/bin/sh

set -eu

REPO="nathanielvarona"

echo "Installing dotfiles from ${REPO}..."

# ------------------------------------------------------------
# Ensure ~/.local/bin exists
# ------------------------------------------------------------
BIN_DIR="${HOME}/.local/bin"
mkdir -p "${BIN_DIR}"
export PATH="${BIN_DIR}:$PATH"

# ------------------------------------------------------------
# Install chezmoi if missing
# ------------------------------------------------------------
if ! command -v chezmoi > /dev/null 2>&1; then
  echo "chezmoi not found, installing..."

  if command -v curl > /dev/null 2>&1; then
    sh -c "$(curl -fsSL https://chezmoi.io/get)" -- -b "${BIN_DIR}"
  elif command -v wget > /dev/null 2>&1; then
    sh -c "$(wget -qO- https://chezmoi.io/get)" -- -b "${BIN_DIR}"
  else
    echo "Error: curl or wget required" >&2
    exit 1
  fi
fi

CHEZMOI="$(command -v chezmoi)"

# ------------------------------------------------------------
# Apply dotfiles (REMOTE SOURCE)
# ------------------------------------------------------------
echo "Running: chezmoi init --apply ${REPO}"
exec "${CHEZMOI}" init --apply "${REPO}"
