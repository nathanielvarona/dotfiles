# dotfiles

My Dotfiles Collection

## Features

* A collection of dotfiles for easy setup and configuration of my development environment
* Managed using GNU `stow` to symlink dotfiles to my home directory `$HOME` or `~/`

## Quick Setup

```bash
# Clone the Dotfiles
git clone https://github.com/nathanielvarona/dotfiles.git \
  ~/.dotfiles && cd ~/.dotfiles

# Stow
stow --stow --verbose .

# Unstow
stow --delete --verbose .

# Restow (like Unstow followed by Stow)
stow --restow --verbose .
```

> [!TIP]
> Use the GNU `stow` option `--simulate` for dry run and evalute possible changes before the real one.

## Before Committing

### Homebrew Packages

Dump List of Packages to Brewfile

```bash
brew bundle dump --no-lock --describe --force
```

Install Packages from the Brewfile

```bash
brew bundle install
```

### ASDF Plugins

Dump List of Plugins

```bash
asdf plugin list > asdf_plugins.list
```

Install Plugins from List File

```bash
while read -r plugin_name; do
  asdf plugin add "$plugin_name"
  if [[ $? -ne 0 ]]; then
    echo "Error adding plugin: $plugin_name"
  fi
done < asdf_plugins.list
```

### Export Ollama Models

Dump Model List

```bash
ollama list | awk 'NR>1 { print $1 }' > ollama_models.list
```

Pull models from the List

```bash
egrep -v '^(;|#|//)' ./ollama_models.list | xargs ollama pull
```

### GNU Pretty Good Privacy (PGP) package and Password manager

#### Passphrase entry dialog utilizing the Assuan protocol

```bash
defaults write org.gpgtools.pinentry-mac UseKeychain -bool NO
```

Python Poetry Packages

```bash
egrep -v '^(;|#|//)' ./pipx_packages.list | xargs pipx install
```

### Shell Scripts Linting and Formatting

To ensure consistency and cleanliness, use:

* Run `editorconfig-checker` to check for EditorConfig errors
* Run `shfmt --indent 2 --write ./<path>/<to>/<script>.sh` to format shell scripts
