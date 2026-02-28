# Justfile is a modern version for Makefile
# See the Link: https://just.systems/

# ============================================================
# Dotfiles Justfile
# ============================================================

set shell := ["bash", "-cu"]

# ------------------------------------------------------------
# Variables
# ------------------------------------------------------------

PACKAGES := "./pkgs"
BREW_BUNDLE_DUMP := "brew bundle dump --describe --force --file"
BREW_BUNDLE_RESTORE := "brew bundle --file"

# ------------------------------------------------------------
# Default
# ------------------------------------------------------------

default:
	@just --list


# ============================================================
# STOW (Grouped Command)
# Usage:
#   just stow apply
#   just stow apply dry-run
#   just stow delete
#   just stow restow dry-run
# ============================================================

stow action="apply" mode="" target=".":
	#!/usr/bin/env bash
	set -euo pipefail

	case "{{action}}" in
		apply)  CMD="--stow" ;;
		delete) CMD="--delete" ;;
		restow) CMD="--restow" ;;
		*)
			echo "Invalid action: {{action}}"
			echo "Valid actions: apply | delete | restow"
			exit 1
			;;
	esac

	FLAGS="--verbose"

	if [ "{{mode}}" = "dry-run" ]; then
		FLAGS="$FLAGS --simulate"
	fi

	echo "→ stow $CMD $FLAGS {{target}}"
	stow $CMD $FLAGS {{target}}


# ============================================================
# PACKAGE DUMP
# ============================================================

dump-all: init brewfile whalebrew asdf pyenv pipx krew helm cargo gh-cli-ext ollama hugging-face

# -------------------------
# Create Package Directory
# -------------------------
init:
	mkdir -p {{PACKAGES}}

# -------------------------
# Homebrew
# -------------------------

brewfile:
	{{BREW_BUNDLE_DUMP}} {{PACKAGES}}/formulae.Brewfile
	{{BREW_BUNDLE_DUMP}} {{PACKAGES}}/casks.Brewfile --cask
	{{BREW_BUNDLE_DUMP}} {{PACKAGES}}/taps.Brewfile --tap
	{{BREW_BUNDLE_DUMP}} {{PACKAGES}}/mas.Brewfile --mas
	{{BREW_BUNDLE_DUMP}} {{PACKAGES}}/vscode.Brewfile --vscode


# -------------------------
# Whalebrew
# -------------------------

whalebrew:
	whalebrew list --no-headers > {{PACKAGES}}/whalebrew || true


# -------------------------
# asdf
# -------------------------

asdf:
	asdf plugin list --urls | awk -v OFS='\t' 'NF{$1=$1; print}' | column -t > {{PACKAGES}}/asdf-plugins || true


# -------------------------
# pyenv
# -------------------------

pyenv:
	pyenv versions --bare > {{PACKAGES}}/pyenv-versions || true


# -------------------------
# pipx
# -------------------------

pipx:
	pipx list --short | column -t > {{PACKAGES}}/pipx-apps || true


# -------------------------
# krew
# -------------------------

krew:
	kubectl krew list > {{PACKAGES}}/krew-plugins || true


# -------------------------
# Helm
# -------------------------

helm:
	helm repo list | sed '1d' | column -t > {{PACKAGES}}/helm-repos || true


# -------------------------
# Cargo
# -------------------------

cargo:
	cargo install --list | awk '/^[a-zA-Z0-9_-]+ v/ {print $1}' > {{PACKAGES}}/rust-cargo-packages || true


# -------------------------
# GitHub CLI
# -------------------------

gh-cli-ext:
	gh extension list | awk '{print $1}' > {{PACKAGES}}/github-cli-extensions || true


# -------------------------
# Ollama
# -------------------------

ollama:
	ollama list | awk 'NR>1 {print $1}' > {{PACKAGES}}/ollama-models || true


# -------------------------
# Hugging Face
# -------------------------

hugging-face:
	hf models ls | awk 'NR > 2' | awk '{print $1}' > {{PACKAGES}}/hugging-face-models || true

# ============================================================
# PACKAGE RESTORE
# ============================================================

restore-all: restore-brew restore-asdf restore-pyenv restore-pipx restore-krew restore-helm restore-cargo restore-gh restore-whalebrew restore-ollama restore-hugging-face


# -------------------------
# Homebrew Restore
# -------------------------

restore-brew:
	{{BREW_BUNDLE_RESTORE}} {{PACKAGES}}/formulae.Brewfile || true
	{{BREW_BUNDLE_RESTORE}} {{PACKAGES}}/casks.Brewfile || true
	{{BREW_BUNDLE_RESTORE}} {{PACKAGES}}/taps.Brewfile || true
	{{BREW_BUNDLE_RESTORE}} {{PACKAGES}}/mas.Brewfile || true
	{{BREW_BUNDLE_RESTORE}} {{PACKAGES}}/vscode.Brewfile || true


# -------------------------
# asdf Restore
# -------------------------
restore-asdf:
	[ -f {{PACKAGES}}/asdf-plugins ] && \
	while read -r plugin url; do \
		asdf plugin add "$plugin" "$url" || true; \
	done < {{PACKAGES}}/asdf-plugins

	asdf install || true


# -------------------------
# pyenv Restore
# -------------------------
restore-pyenv:
	cat {{PACKAGES}}/pyenv-versions | xargs -I{} pyenv install {} || true


# -------------------------
# pipx Restore
# -------------------------

restore-pipx:
	cat {{PACKAGES}}/pipx-apps | awk '{print $1}' | xargs -I{} pipx install {} || true


# -------------------------
# krew Restore
# -------------------------

restore-krew:
	cat {{PACKAGES}}/krew-plugins | xargs -I{} kubectl krew install {} || true


# -------------------------
# Helm Restore
# -------------------------

restore-helm:
	cat {{PACKAGES}}/helm-repos | xargs -L1 sh -c 'helm repo add $0 $1' || true
	helm repo update || true


# -------------------------
# Cargo Restore
# -------------------------

restore-cargo:
	cat {{PACKAGES}}/rust-cargo-packages | xargs -I{} cargo install {} || true


# -------------------------
# GitHub CLI Restore
# -------------------------

restore-gh:
	cat {{PACKAGES}}/github-cli-extensions | xargs -I{} gh extension install {} || true


# -------------------------
# Whalebrew Restore
# -------------------------

restore-whalebrew:
	cat {{PACKAGES}}/whalebrew | xargs -L1 sh -c 'whalebrew install $1 -n $0' || true


# -------------------------
# Ollama Restore
# -------------------------

restore-ollama:
	cat {{PACKAGES}}/ollama-models | xargs -I{} ollama pull {} || true


# -------------------------
# Hugging Face Restore
# -------------------------

restore-hugging-face:
	cat {{PACKAGES}}/hugging-face-models | xargs -I{} hf download {} || true
