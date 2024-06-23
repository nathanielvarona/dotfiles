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

### Backup the List of Brew Packages

```bash
brew bundle dump --force --no-lock
```

### Shell Scripts Linting and Formatting

To ensure consistency and cleanliness, use:

* Run `editorconfig-checker` to check for EditorConfig errors
* Run `shfmt --indent 2 --write ./<path>/<to>/<script>.sh` to format shell scripts
