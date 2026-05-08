#!/bin/sh

set -eu

# ============================================================
# Dotfiles Installer (macOS / Linux)
# ============================================================

# ------------------------------------------------------------
# Platform Safety Check
# ------------------------------------------------------------

case "$(uname -s)" in
  Linux | Darwin)
    ;;
  *)
    printf "Error: install.sh only supports macOS and Linux\n" >&2
    exit 1
    ;;
esac

REPO="nathanielvarona"

printf "\n"
printf "Installing dotfiles from %s...\n" "$REPO"
printf "\n"

# ------------------------------------------------------------
# Ensure ~/.local/bin exists
# ------------------------------------------------------------

BIN_DIR="${HOME}/.local/bin"

if [ ! -d "${BIN_DIR}" ]; then
  mkdir -p "${BIN_DIR}"

  printf "Created local bin directory\n"
  printf "  Path : %s\n" "${BIN_DIR}"
  printf "\n"
fi

# Add to current session PATH
export PATH="${BIN_DIR}:$PATH"

# ------------------------------------------------------------
# Install chezmoi if missing
# ------------------------------------------------------------

if ! command -v chezmoi > /dev/null 2>&1; then
  printf "Installing chezmoi...\n"

  if command -v curl > /dev/null 2>&1; then
    sh -c "$(curl -fsSL https://chezmoi.io/get)" -- -b "${BIN_DIR}"
  elif command -v wget > /dev/null 2>&1; then
    sh -c "$(wget -qO- https://chezmoi.io/get)" -- -b "${BIN_DIR}"
  else
    printf "Error: curl or wget is required\n" >&2
    exit 1
  fi

  printf "Installed chezmoi\n"
  printf "\n"
fi

CHEZMOI="$(command -v chezmoi)"

# ------------------------------------------------------------
# Apply Dotfiles (Remote Source)
# ------------------------------------------------------------

printf "Applying dotfiles...\n"
printf "  Repository : %s\n" "${REPO}"
printf "\n"

exec "${CHEZMOI}" init --apply "${REPO}"
