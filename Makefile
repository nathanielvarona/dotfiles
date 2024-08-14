.PHONY: all

PACKAGES = ./packages
BREW_BUNDLE_DUMP = brew bundle dump --no-lock --describe --force --file

all: brewfile asdf pyenv pipx krew helm rust-cargo github-cli-extension ollama

brewfile: brewfile-formulae brewfile-casks brewfile-taps brewfile-mas brewfile-vscode brewfile-whalebrew

brewfile-formulae:
	$(BREW_BUNDLE_DUMP) $(PACKAGES)/formulae.Brewfile --brews

brewfile-casks:
	$(BREW_BUNDLE_DUMP) $(PACKAGES)/casks.Brewfile --casks

brewfile-taps:
	$(BREW_BUNDLE_DUMP) $(PACKAGES)/taps.Brewfile --taps

brewfile-mas:
	$(BREW_BUNDLE_DUMP) $(PACKAGES)/mas.Brewfile --mas

brewfile-vscode:
	$(BREW_BUNDLE_DUMP) $(PACKAGES)/vscode.Brewfile --vscode

brewfile-whalebrew:
	$(BREW_BUNDLE_DUMP) $(PACKAGES)/whalebrew.Brewfile --whalebrew

asdf:
	asdf plugin list > $(PACKAGES)/asdf-plugins

pyenv:
	pyenv versions --bare --skip-aliases --skip-envs > $(PACKAGES)/pyenv-versions

pipx:
	pipx list --short > $(PACKAGES)/pipx-apps

krew:
	krew list > $(PACKAGES)/krew-plugins

helm:
	helm repo list > $(PACKAGES)/helm-repos

rust-cargo:
	cat ~/.cargo/.crates2.json | jq -r '.installs | keys[] | split(" ")[0]' > $(PACKAGES)/rust-cargo-global-packages

github-cli-extension:
	gh extension list | awk -F'\t' '{print $$2}' > $(PACKAGES)/github-cli-extensions

ollama:
	@pgrep -x "ollama" > /dev/null && ollama list | awk 'NR > 1 { print $$1 }' > $(PACKAGES)/ollama-models && \
	echo "Ollama Model List Dumped" || \
	echo "Dump Skipped! Ollama Service is Down"

# TODO:
# - hugging-face-models (Future)

# NOTE:
# - cpanfile (Excluded)
