.PHONY: all

BREW_BUNDLE_DUMP = brew bundle dump --no-lock --describe --force --file

all: brewfile asdf poetry krew helm ollama

brewfile: brewfile-formulae brewfile-casks brewfile-taps brewfile-mas brewfile-vscode

brewfile-formulae:
	$(BREW_BUNDLE_DUMP) ./formulae.Brewfile --brews

brewfile-casks:
	$(BREW_BUNDLE_DUMP) ./casks.Brewfile --casks

brewfile-taps:
	$(BREW_BUNDLE_DUMP) ./taps.Brewfile --taps

brewfile-mas:
	$(BREW_BUNDLE_DUMP) ./mas.Brewfile --mas

brewfile-vscode:
	$(BREW_BUNDLE_DUMP) ./vscode.Brewfile --vscode

asdf:
	asdf plugin list > ./asdf-plugins

poetry:
	pipx list --short > ./pipx-apps

krew:
	krew list > ./krew-plugins

helm:
	helm repo list > ./helm-repos

ollama:
	ollama list | awk 'NR > 1 { print $$1 }' > ./ollama-models
