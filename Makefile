.PHONY: all common

BREW_BUNDLE_DUMP = brew bundle dump --no-lock --describe --force --file

all: brewfile

brewfile: brewfile-formulae brewfile-casks brewfile-taps brewfile-mas brewfile-vscode

brewfile-formulae: common
	$(BREW_BUNDLE_DUMP) ./formulae.Brewfile --brews

brewfile-casks: common
	$(BREW_BUNDLE_DUMP) ./casks.Brewfile --casks

brewfile-taps: common
	$(BREW_BUNDLE_DUMP) ./taps.Brewfile --taps

brewfile-mas: common
	$(BREW_BUNDLE_DUMP) ./mas.Brewfile --mas

brewfile-vscode: common
	$(BREW_BUNDLE_DUMP) ./vscode.Brewfile --vscode
