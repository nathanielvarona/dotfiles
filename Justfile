# Justfile is a modern version for Makefile
# https://just.systems/

# ============================================================
# Dotfiles Justfile
# ============================================================

set shell := ["bash", "-cu"]

# ------------------------------------------------------------
# Global Variables
# ------------------------------------------------------------

PACKAGES := "./pkgs"
BREW_BUNDLE_DUMP := "brew bundle dump --describe --force --file"
BREW_BUNDLE_RESTORE := "brew bundle --file"

# ------------------------------------------------------------
# Default Target
# ------------------------------------------------------------

default:
	@just --list

# ------------------------------------------------------------
# Ensure pkgs directory exists
# ------------------------------------------------------------

init:
	mkdir -p {{PACKAGES}}

# ============================================================
# STOW
# ============================================================
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
# HOMEBREW
# ============================================================

brew-dump: init
	# Dump all Brew bundles
	{{BREW_BUNDLE_DUMP}} {{PACKAGES}}/formulae.Brewfile --formulae
	{{BREW_BUNDLE_DUMP}} {{PACKAGES}}/casks.Brewfile --cask
	{{BREW_BUNDLE_DUMP}} {{PACKAGES}}/taps.Brewfile --tap
	{{BREW_BUNDLE_DUMP}} {{PACKAGES}}/mas.Brewfile --mas
	{{BREW_BUNDLE_DUMP}} {{PACKAGES}}/vscode.Brewfile --vscode

brew-restore:
	# Restore Brew bundles
	{{BREW_BUNDLE_RESTORE}} {{PACKAGES}}/formulae.Brewfile || true
	{{BREW_BUNDLE_RESTORE}} {{PACKAGES}}/casks.Brewfile || true
	{{BREW_BUNDLE_RESTORE}} {{PACKAGES}}/taps.Brewfile || true
	{{BREW_BUNDLE_RESTORE}} {{PACKAGES}}/mas.Brewfile || true
	{{BREW_BUNDLE_RESTORE}} {{PACKAGES}}/vscode.Brewfile || true


# ============================================================
# ASDF
# ============================================================

asdf-dump: init
	# Dump installed asdf plugins with URLs
	asdf plugin list --urls | awk -v OFS='\t' 'NF{$1=$1; print}' | column -t > {{PACKAGES}}/asdf-plugins || true

asdf-restore:
	# Restore asdf plugins
	@if [ -f {{PACKAGES}}/asdf-plugins ]; then \
		while read -r plugin url; do \
			asdf plugin add "$plugin" "$url" || true; \
		done < {{PACKAGES}}/asdf-plugins ; \
	fi
	asdf install || true


# ============================================================
# PYENV
# ============================================================

pyenv-dump: init
	pyenv versions --bare > {{PACKAGES}}/pyenv-versions || true

pyenv-restore:
	[ -f {{PACKAGES}}/pyenv-versions ] && \
	cat {{PACKAGES}}/pyenv-versions | xargs -I{} pyenv install {} || true


# ============================================================
# PIPX
# ============================================================

pipx-dump: init
	pipx list --short | column -t > {{PACKAGES}}/pipx-apps || true

pipx-restore:
	@if [ -f {{PACKAGES}}/pipx-apps ]; then \
		awk '{print $1}' {{PACKAGES}}/pipx-apps | xargs -I{} pipx install {} ; \
	fi


# ============================================================
# KREW
# ============================================================

krew-dump: init
	kubectl krew list > {{PACKAGES}}/krew-plugins || true

krew-restore:
	@if [ -f {{PACKAGES}}/krew-plugins ]; then \
		cat {{PACKAGES}}/krew-plugins | xargs -I{} kubectl krew install {} ; \
	fi


# ============================================================
# HELM
# ============================================================

helm-dump: init
	helm repo list | sed '1d' | column -t > {{PACKAGES}}/helm-repos || true

helm-restore:
	@if [ -f {{PACKAGES}}/helm-repos ]; then \
		cat {{PACKAGES}}/helm-repos | xargs -L1 sh -c 'helm repo add $0 $1' ; \
	fi
	helm repo update || true


# ============================================================
# CARGO
# ============================================================

cargo-dump: init
	cargo install --list | awk '/^[a-zA-Z0-9_-]+ v/ {print $1}' > {{PACKAGES}}/rust-cargo-packages || true

cargo-restore:
	@if [ -f {{PACKAGES}}/rust-cargo-packages ]; then \
		cat {{PACKAGES}}/rust-cargo-packages | xargs -I{} cargo install {} ; \
	fi


# ============================================================
# GITHUB CLI
# ============================================================

gh-dump: init
	gh extension list | grep -Eo '[[:alnum:]_-]+/[[:alnum:]_.-]+' > {{PACKAGES}}/github-cli-extensions || true

gh-restore:
	@if [ -f {{PACKAGES}}/github-cli-extensions ]; then \
		cat {{PACKAGES}}/github-cli-extensions | xargs -I{} gh extension install {} ; \
	fi


# ============================================================
# WHALEBREW
# ============================================================

whalebrew-dump: init
	whalebrew list --no-headers > {{PACKAGES}}/whalebrew || true

whalebrew-restore:
	@if [ -f {{PACKAGES}}/whalebrew ]; then \
		cat {{PACKAGES}}/whalebrew | xargs -L1 sh -c 'whalebrew install $1 -n $0' ; \
	fi


# ============================================================
# OLLAMA
# ============================================================

ollama-dump: init
	ollama list | awk 'NR>1 {print $1}' > {{PACKAGES}}/ollama-models || true

ollama-restore:
	@if [ -f {{PACKAGES}}/ollama-models ]; then \
		cat {{PACKAGES}}/ollama-models | xargs -I{} ollama pull {} ; \
	fi


# ============================================================
# HUGGING FACE
# ============================================================

hugging-face-dump: init
	hf models ls | awk 'NR > 2' | awk '{print $1}' > {{PACKAGES}}/hugging-face-models || true

hugging-face-restore:
	@if [ -f {{PACKAGES}}/hugging-face-models ]; then \
		cat {{PACKAGES}}/hugging-face-models | xargs -I{} hf download {} ; \
	fi


# ============================================================
# AGGREGATE TARGETS
# ============================================================

dump-all: \
	brew-dump \
	asdf-dump \
	pyenv-dump \
	pipx-dump \
	krew-dump \
	helm-dump \
	cargo-dump \
	gh-dump \
	whalebrew-dump \
	ollama-dump \
	hugging-face-dump

restore-all: \
	brew-restore \
	asdf-restore \
	pyenv-restore \
	pipx-restore \
	krew-restore \
	helm-restore \
	cargo-restore \
	gh-restore \
	whalebrew-restore \
	ollama-restore \
	hugging-face-restore

