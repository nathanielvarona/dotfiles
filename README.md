# dotfiles

My Dotfiles Collection

## Features

* A collection of dotfiles for easy setup and configuration of my development environment
* Organized into directories for simplicity and ease of use
* Managed using GNU `stow` to symlink dotfiles to my home directory `$HOME` or `~/`

## Quick Setup

```bash
# Clone the Dotfiles
git clone https://github.com/nathanielvarona/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Stow
stow --stow --verbose .

# Unstow
stow --delete --verbose .

# Restow (like Unstow followed by Stow)
stow --restow --verbose .
```

> [!TIP]
> Use the GNU `stow` option `--simulate` to simulate changes.

## Contributing

### Linting and File Formatting

To ensure consistency and cleanliness, I use:

* `editorconfig-checker` for EditorConfig validation
* `shfmt` for shell script formatting

Linting Usage

* Run `editorconfig-checker` to check for EditorConfig errors
* Run `shfmt --indent 2 --write ./<path>/<to>/<script>.sh` to format shell scripts
