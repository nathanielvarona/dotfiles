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

## Packages Installation

### Homebrew Packages

#### Dump List of Packages

```bash
brew bundle dump --no-lock --describe \
  --force --file ./packages/Brewfile
```

#### Install Packages

```bash
brew bundle install \
  --file ./packages/Brewfile
```

### ASDF Plugins

#### Dump List of Plugins

```bash
asdf plugin list > ./packages/asdf-plugins
```

#### Installation

```bash
egrep -v '^(;|#|//)' ./packages/asdf-plugins | 
  xargs -I {} asdf plugin add {}
```

### Poetry Apps (Python Packages)

#### Installation

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

### Ollama Models

Dump Model List

```bash
ollama list | 
  awk 'NR>1 { print $1 }' > ./packages/ollama-models
```

Pull Models

```bash
egrep -v '^(;|#|//)' ./packages/ollama-models |
  xargs -I {} ollama pull {}
```

### Hugging Face Models

Download Models

```bash
while IFS= read -r model_name; do
  repo_id="${model_name%% *}"
  filename="${model_name#* }"
  huggingface-cli download "$repo_id" "$filename"
done < <(egrep -v '^(;|#|//)' ./packages/hugging-face-models)
```

### GNU Pretty Good Privacy (PGP) package and Password manager

#### Passphrase entry dialog utilizing the Assuan protocol

```bash
defaults write org.gpgtools.common UseKeychain false
```

### Shell Scripts Linting and Formatting

To ensure consistency and cleanliness, use:

* Run `editorconfig-checker` to check for EditorConfig errors
* Run `shfmt --indent 2 --write ./<path>/<to>/<script>.sh` to format shell scripts
