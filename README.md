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
brew bundle dump --no-lock --describe \
  --force --file ./packages/Brewfile
```

Install Packages from the Brewfile

```bash
brew bundle install
```

### ASDF Plugins

Dump List of Plugins

```bash
asdf plugin list > ./packages/asdf-plugins
```

Install Plugins from List File

```bash
egrep -v '^(;|#|//)' ./packages/asdf-plugins | 
  xargs -I {} asdf plugin add {} 
```

### Export Ollama Models

Dump Model List

```bash
ollama list | 
  awk 'NR>1 { print $1 }' > ./packages/ollama-models
```

Pull models from the List

```bash
egrep -v '^(;|#|//)' ./packages/ollama-models | 
  xargs -I {} ollama pull {}
```

### GNU Pretty Good Privacy (PGP) package and Password manager

#### Passphrase entry dialog utilizing the Assuan protocol

```bash
defaults write org.gpgtools.common UseKeychain false
```

Python Poetry Packages

```bash
egrep -v '^(;|#|//)' ./packages/pipx-apps | 
  xargs -I {} pipx install {}
```

### Perl CPAN Packages

#### Requirement

```bash
cpan App::cpanminus
```

#### Installation

```bash
cpanm --installdeps ./packages/
```

### Shell Scripts Linting and Formatting

To ensure consistency and cleanliness, use:

* Run `editorconfig-checker` to check for EditorConfig errors
* Run `shfmt --indent 2 --write ./<path>/<to>/<script>.sh` to format shell scripts
