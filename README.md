# dotfiles

My Dotfiles Collection

## Features

* A collection of dotfiles for easy setup and configuration of my development environment
* Managed using GNU `stow` to symlink dotfiles to my home directory `~/` or `$HOME`
* Handy scripts for installing packages and development toolings


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

Dump List of Packages

```bash
brew bundle dump --no-lock --describe \
  --force --file ./Brewfile
```

Install Packages

```bash
brew bundle install \
  --file ./Brewfile
```

### ASDF Plugins

Dump List of Plugins

```bash
asdf plugin list > ./asdf-plugins
```

Installation of Plugins

```bash
egrep -v '^(;|#|//)' ./asdf-plugins | 
  xargs -I {} asdf plugin add {}
```

### Pyenv Versions (Python Version Manager)

Build and Install Python Versions from Source

```bash
egrep -v '^(;|#|//)' ./pyenv-versions |
  xargs -I {} pyenv install {}
```

### Pipx Apps (Python Apps)

Installation of Python Apps

```bash
egrep -v '^(;|#|//)' ./pipx-apps | 
  xargs -I {} pipx install {}
```

### Perl CPAN Packages

Install CPAN Tooling called CPANM

```bash
cpan App::cpanminus
```

Use CPANM to Install Module/Tool from the `cpanfile`

```bash
cpanm --installdeps ./
```

### Krew Plugins

Install Krew Plugins

```bash
egrep -v '^(;|#|//)' ./krew-plugins | 
  xargs -I {} kubectl krew install {}
```

### Helm Repos

Add the Helm Repositories

```bash
while IFS= read -r helm_name; do
  name="${helm_name%% *}"
  url="${helm_name#* }"
  helm repo add "$name" "$url"
done < <(egrep -v '^(;|#|//)' ./helm-repos)
```

### Ollama Models

Dump Model List

```bash
ollama list | 
  awk 'NR>1 { print $1 }' > ./ollama-models
```

Pull Models

```bash
egrep -v '^(;|#|//)' ./ollama-models |
  xargs -I {} ollama pull {}
```

### Hugging Face Models

Download Models

```bash
while IFS= read -r model_name; do
  repo_id="${model_name%% *}"
  filename="${model_name#* }"
  huggingface-cli download "$repo_id" "$filename"
done < <(egrep -v '^(;|#|//)' ./hugging-face-models)
```

### GNU Pretty Good Privacy (PGP) package and Password manager

Passphrase entry dialog utilizing the Assuan protocol

```bash
defaults write org.gpgtools.common UseKeychain false
```

### Shell Scripts Linting and Formatting

To ensure consistency and cleanliness, use:

* Run `editorconfig-checker` to check for EditorConfig errors
* Run `shfmt --indent 2 --write ./<path>/<to>/<script>.sh` to format shell scripts

## Troubleshooting

Clearout the Powerlevel10k instant prompt Cache

```bash
rm -Rf $HOME/.cache/p10k-*
```

Clearout the Completation Cache from ZSH

```bash
rm -f $HOME/.zcompdump && exec $SHELL -l
```

Nuke Zinit (Total Reset the Zinit Configuration for Rebuild)

```
rm -Rf $HOME/.local/share/zinit $HOME/.cache/zinit
```
