# Justfile is a modern version for Makefile
# See the Link: https://just.systems/

# Variables
PACKAGES := "./pkgs"
BREW_BUNDLE_DUMP := "brew bundle dump --describe --force --file"

# Show Just Available Commands
default:
  just --list

# Dump All
dump-all: brewfile whalebrew asdf pyenv pipx krew helm rust-cargo gh-cli-ext ollama hugging-face

# Dump Brewfiles
brewfile: brewfile-formulae brewfile-casks brewfile-taps brewfile-mas brewfile-vscode

# Dump Brewfile for Formulae
brewfile-formulae:
    {{BREW_BUNDLE_DUMP}} {{PACKAGES}}/formulae.Brewfile --brews

# Dump Brewfile for Casks
brewfile-casks:
    {{BREW_BUNDLE_DUMP}} {{PACKAGES}}/casks.Brewfile --casks

# Dump Brewfile for Taps
brewfile-taps:
    {{BREW_BUNDLE_DUMP}} {{PACKAGES}}/taps.Brewfile --taps

# Dump Brewfile for Mac App Store
brewfile-mas:
    {{BREW_BUNDLE_DUMP}} {{PACKAGES}}/mas.Brewfile --mas

# Dump Brewfile for VSCode Extensions
brewfile-vscode:
    {{BREW_BUNDLE_DUMP}} {{PACKAGES}}/vscode.Brewfile --vscode

# Dump Whalebrew Apps
whalebrew:
    whalebrew list > {{PACKAGES}}/whalebrew

# Dump ASDF Toolings
asdf:
    asdf plugin list > {{PACKAGES}}/asdf-plugins

# Dump PyEnv (Python Version Manager)
pyenv:
    pyenv versions --bare --skip-aliases --skip-envs > {{PACKAGES}}/pyenv-versions

# Dump Pipx (Python Apps)
pipx:
    pipx list --short > {{PACKAGES}}/pipx-apps

# Dump Krew (Kubernetes Plugin Manager) Plugins
krew:
    krew list > {{PACKAGES}}/krew-plugins

# Dump Helm Repositories
helm:
    helm repo list > {{PACKAGES}}/helm-repos

# Load Helm Repositories
helm-load:
    @awk 'NR > 1 { print $1, $2 }' {{PACKAGES}}/helm-repos | \
    while read -r name url; do \
        helm repo add "$name" "$url"; \
    done
    @helm repo update

# Dump Rust Packages
rust-cargo:
    jq -r '.installs | keys[] | split(" ")[0]' ~/.cargo/.crates2.json \
      > {{PACKAGES}}/rust-cargo-packages

# Dump GitHub CLI Extensions
gh-cli-ext:
    gh extension list | awk -F'\t' '{print $2}' \
      > {{PACKAGES}}/github-cli-extensions

# Dump Ollama Models
ollama:
    if pgrep -x "ollama" > /dev/null; then \
        ollama list | awk 'NR > 1 { print $1 }' \
          > {{PACKAGES}}/ollama-models && \
        echo "Ollama Model List Dumped"; \
    else \
        echo "Dump Skipped! Ollama Service is Down"; \
    fi

# Dump Hugging Face Models
hugging-face:
    hf models ls --format json | jq '.[] | .id' > {{PACKAGES}}/hugging-face-models

