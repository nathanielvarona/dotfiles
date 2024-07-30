.PHONY: all

BREW_BUNDLE_DUMP = brew bundle dump --no-lock --describe --force --file

all: brewfile

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
