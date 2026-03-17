# Justfile – Modern Make Alternative
# https://just.systems/

set shell := ["bash", "-cu"]

# ================
# Global Variables
# ================

PACKAGES := "./pkgs"
BREW_BUNDLE_DUMP := "brew bundle dump --describe --force --file"
BREW_BUNDLE_RESTORE := "brew bundle --file"

# ================
# Default
# ================

default:
	@just --list

# ================
# Init
# ================

init:
	mkdir -p {{PACKAGES}}

# ================
# Stow
# ================
# Usage:
#   just stow apply
#   just stow apply dry-run
#   just stow delete
#   just stow restow
# ================

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

# ================
# Homebrew
# ================

dump-brew: init
	{{BREW_BUNDLE_DUMP}} {{PACKAGES}}/formulae.Brewfile --formulae
	{{BREW_BUNDLE_DUMP}} {{PACKAGES}}/casks.Brewfile --cask
	{{BREW_BUNDLE_DUMP}} {{PACKAGES}}/taps.Brewfile --tap
	{{BREW_BUNDLE_DUMP}} {{PACKAGES}}/mas.Brewfile --mas
	{{BREW_BUNDLE_DUMP}} {{PACKAGES}}/vscode.Brewfile --vscode

restore-brew:
	@if [ -f {{PACKAGES}}/formulae.Brewfile ]; then {{BREW_BUNDLE_RESTORE}} {{PACKAGES}}/formulae.Brewfile; fi || true
	@if [ -f {{PACKAGES}}/casks.Brewfile ]; then {{BREW_BUNDLE_RESTORE}} {{PACKAGES}}/casks.Brewfile; fi || true
	@if [ -f {{PACKAGES}}/taps.Brewfile ]; then {{BREW_BUNDLE_RESTORE}} {{PACKAGES}}/taps.Brewfile; fi || true
	@if [ -f {{PACKAGES}}/mas.Brewfile ]; then {{BREW_BUNDLE_RESTORE}} {{PACKAGES}}/mas.Brewfile; fi || true
	@if [ -f {{PACKAGES}}/vscode.Brewfile ]; then {{BREW_BUNDLE_RESTORE}} {{PACKAGES}}/vscode.Brewfile; fi || true

# ================
# ASDF
# ================

dump-asdf: init
	asdf plugin list --urls | awk 'NF{$1=$1;print}' | column -t > {{PACKAGES}}/asdf-plugins || true

restore-asdf:
	@if [ -f {{PACKAGES}}/asdf-plugins ]; then \
		while read -r plugin url; do \
			asdf plugin add "$plugin" "$url" || true; \
		done < {{PACKAGES}}/asdf-plugins ; \
	fi
	asdf install || true

# ================
# Pyenv
# ================

dump-pyenv: init
	pyenv versions --bare > {{PACKAGES}}/pyenv-versions || true

restore-pyenv:
	@if [ -f {{PACKAGES}}/pyenv-versions ]; then \
		cat {{PACKAGES}}/pyenv-versions | xargs -I{} pyenv install {} || true ; \
	fi

# ================
# Pipx
# ================

dump-pipx: init
	pipx list --short | column -t > {{PACKAGES}}/pipx-apps || true

restore-pipx:
	@if [ -f {{PACKAGES}}/pipx-apps ]; then \
		awk '{print $1}' {{PACKAGES}}/pipx-apps | xargs -I{} pipx install {} ; \
	fi

# ================
# Krew
# ================

dump-krew: init
	kubectl krew list > {{PACKAGES}}/krew-plugins || true

restore-krew:
	@if [ -f {{PACKAGES}}/krew-plugins ]; then \
		cat {{PACKAGES}}/krew-plugins | xargs -I{} kubectl krew install {} || true ; \
	fi

# ================
# Helm
# ================

dump-helm: init
	helm repo list | sed '1d' | column -t > {{PACKAGES}}/helm-repos || true

restore-helm:
	@if [ -f {{PACKAGES}}/helm-repos ]; then \
		while read -r name url; do \
			helm repo add "$name" "$url" || true; \
		done < {{PACKAGES}}/helm-repos ; \
	fi
	helm repo update || true

# ================
# Cargo
# ================

dump-cargo: init
	cargo install --list | awk '/^[a-zA-Z0-9_-]+ v/ {print $1}' > {{PACKAGES}}/rust-cargo-packages || true

restore-cargo:
	@if [ -f {{PACKAGES}}/rust-cargo-packages ]; then \
		cat {{PACKAGES}}/rust-cargo-packages | xargs -I{} cargo install {} || true ; \
	fi

# ================
# GitHub CLI
# ================

dump-gh-ext: init
	gh extension list | grep -Eo '[[:alnum:]_-]+/[[:alnum:]_.-]+' > {{PACKAGES}}/github-cli-extensions || true

restore-gh-ext:
	@if [ -f {{PACKAGES}}/github-cli-extensions ]; then \
		cat {{PACKAGES}}/github-cli-extensions | xargs -I{} gh extension install {} || true ; \
	fi

# ================
# Whalebrew
# ================

dump-whalebrew: init
	whalebrew list --no-headers > {{PACKAGES}}/whalebrew || true

restore-whalebrew:
	@if [ -f {{PACKAGES}}/whalebrew ]; then \
		cat {{PACKAGES}}/whalebrew | xargs -L1 whalebrew install || true ; \
	fi

# ================
# Ollama
# ================

dump-ollama: init
	ollama list | awk 'NR>1 {print $1}' > {{PACKAGES}}/ollama-models || true

restore-ollama:
	@if [ -f {{PACKAGES}}/ollama-models ]; then \
		cat {{PACKAGES}}/ollama-models | xargs -I{} ollama pull {} || true ; \
	fi

# ================
# Hugging Face
# ================

dump-hugging-face: init
	hf models ls --format json | jq -r ".[].id" > {{PACKAGES}}/hugging-face-models || true

restore-hugging-face:
	@if [ -f {{PACKAGES}}/hugging-face-models ]; then \
		cat {{PACKAGES}}/hugging-face-models | xargs -I{} hf download {} || true ; \
	fi

# ================
# Aggregate
# ================

dump-all: \
	dump-brew \
	dump-asdf \
	dump-pyenv \
	dump-pipx \
	dump-krew \
	dump-helm \
	dump-cargo \
	dump-gh-ext \
	dump-whalebrew \
	dump-ollama \
	dump-hugging-face

restore-all: \
	restore-brew \
	restore-asdf \
	restore-pyenv \
	restore-pipx \
	restore-krew \
	restore-helm \
	restore-cargo \
	restore-gh-ext \
	restore-whalebrew \
	restore-ollama \
	restore-hugging-face
