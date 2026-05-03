# vim: noexpandtab: tabstop=4: shiftwidth=4: fileencoding=utf-8: foldmethod=marker: filetype=just

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
# Homebrew
# ================

dump-brew: init
	{{BREW_BUNDLE_DUMP}} {{PACKAGES}}/formulae.Brewfile --formulae
	{{BREW_BUNDLE_DUMP}} {{PACKAGES}}/cask.Brewfile --cask
	{{BREW_BUNDLE_DUMP}} {{PACKAGES}}/tap.Brewfile --tap
	{{BREW_BUNDLE_DUMP}} {{PACKAGES}}/mas.Brewfile --mas
	{{BREW_BUNDLE_DUMP}} {{PACKAGES}}/vscode.Brewfile --vscode

restore-brew:
	@if [ -f {{PACKAGES}}/formulae.Brewfile ]; then {{BREW_BUNDLE_RESTORE}} {{PACKAGES}}/formulae.Brewfile; fi || true
	@if [ -f {{PACKAGES}}/cask.Brewfile ]; then {{BREW_BUNDLE_RESTORE}} {{PACKAGES}}/cask.Brewfile; fi || true
	@if [ -f {{PACKAGES}}/tap.Brewfile ]; then {{BREW_BUNDLE_RESTORE}} {{PACKAGES}}/tap.Brewfile; fi || true
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
# Perl CPAN
# ================

dump-perl-modules: init
	#!/usr/bin/env bash
	set -euo pipefail

	OUT="{{PACKAGES}}/cpanfile"

	echo "→ Dumping user-installed Perl modules with versions to $OUT"

	perl -MExtUtils::Installed -MModule::CoreList -e '
		my $inst = ExtUtils::Installed->new();
		my %core = map { $_ => 1 } Module::CoreList->find_modules(qr/.*/, $]);

		for my $mod (sort $inst->modules()) {
			next if $mod eq "Perl";
			next if exists $core{$mod};

			my $ver = $inst->version($mod) || 0;
			print "requires '\''$mod'\'', '\''$ver'\'';\n";
		}
	' > "$OUT" || true

restore-perl-modules:
	#!/usr/bin/env bash
	set -euo pipefail

	CPANFILE="{{PACKAGES}}/cpanfile"

	# Bootstrap cpanm if not installed
	if ! command -v cpanm >/dev/null 2>&1; then
		echo "→ cpanm not found, installing via cpan"
		PERL_MM_USE_DEFAULT=1 cpan App::cpanminus || true
	fi

	# Restore modules using cpanfile
	if [ -f "$CPANFILE" ]; then
		echo "→ Installing Perl modules from $CPANFILE"
		cpanm --quiet --notest --installdeps "{{PACKAGES}}" || true
	else
		echo "→ No cpanfile found at $CPANFILE (skipping)"
	fi

[windows]
dump-winget:
	#!pwsh.exe
	winget export -o apps.json --include-versions --ignore-warnings --disable-interactivity --accept-source-agreements
	jq -r '.Sources[].Packages[] | "\(.PackageIdentifier)\t\(.Version)"' apps.json |
		ConvertFrom-Csv -Delimiter "`t" -Header "Application", "Version" |
		Format-Table -AutoSize |
		Out-String |
		ForEach-Object { $_.Trim() } |
		Where-Object { $_ -ne "" } |
		Set-Content {{PACKAGES}}/windows-winget
	rm -r -fo apps.json

[windows]
restore-winget:
	#!pwsh.exe
	if (Test-Path {{PACKAGES}}/windows-winget) {
		# Read the file, skip the Header and Table separator lines
		$apps = Get-Content {{PACKAGES}}/windows-winget | Select-Object -Skip 2
		foreach ($line in $apps) {
			# Extract the first column (Package ID) before the whitespace
			$appId = $line.Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)[0]
			if ($appId) {
				Write-Host "--> Installing: $appId" -ForegroundColor Cyan
				winget install --id $appId --exact --accept-source-agreements --accept-package-agreements
			}
		}
	} else {
		Write-Error "Dump file not found at {{PACKAGES}}/windows-winget"
	}

[windows]
restore-vscode-extension-windows:
    #!pwsh.exe
    $brewfile = "{{PACKAGES}}/vscode.Brewfile"
    if (-not (Test-Path $brewfile)) {
        Write-Error "Brewfile not found at $brewfile"
        return
    }
    # 1. Fetch current extensions once (huge performance boost)
    Write-Host "Checking current environment..." -ForegroundColor Gray
    $installed = code --list-extensions
    # 2. Extract extension IDs from Brewfile
    $desired = Select-String -Path $brewfile -Pattern '^vscode "(.*)"' | ForEach-Object { $_.Matches.Groups[1].Value }
    foreach ($ext in $desired) {
        if ($installed -contains $ext) {
            Write-Host "--> Skipping (Already Installed): $ext" -ForegroundColor DarkGray
        } else {
            Write-Host "--> Installing: $ext" -ForegroundColor Cyan
            # The CLI will show its own download progress here
            code --install-extension $ext --force
        }
    }
    Write-Host "VS Code restoration complete." -ForegroundColor Green

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
	dump-hugging-face \
	dump-perl-modules

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
	restore-hugging-face \
	restore-perl-modules

