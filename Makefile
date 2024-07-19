.PHONY: all

brewfile: brewfile-formulae brewfile-casks brewfile-taps brewfile-mas brewfile-vscode

brewfile-formulae:
	brew bundle dump --no-lock --describe --force --file ./formulae.Brewfile --brews

brewfile-casks:
	brew bundle dump --no-lock --describe --force --file ./casks.Brewfile --casks

brewfile-taps:
	brew bundle dump --no-lock --describe --force --file ./taps.Brewfile --taps

brewfile-mas:
	brew bundle dump --no-lock --describe --force --file ./mas.Brewfile --mas

brewfile-vscode:
	brew bundle dump --no-lock --describe --force --file ./vscode.Brewfile --vscode
