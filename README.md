# dotfiles

My Dotfiles Collection

## What's inside?

- A collection of dotfiles for easy setup and configuration of my development environment
- Managed using GNU `stow` to symlink dotfiles to my home directory `~/` or `$HOME`
- Handy scripts for installing packages and development toolings

## Quick Setup

```bash
# Clone the Dotfiles
git clone https://github.com/nathanielvarona/dotfiles.git \
  dotfiles && cd dotfiles

# Stow
stow --stow --verbose .

# Unstow
stow --delete --verbose .

# Restow (like Unstow followed by Stow)
stow --restow --verbose .
```

> [!TIP]
> Use the GNU `stow` option `--simulate` for dry run and evalute possible changes before the real one.

## Tooling Documentations

Kindly check the [./docs](./docs) directory.

## Screencast

- dotfiles: tmuxp - lazyvim - tree-sitter - lspconfig - lazygit
  [![asciicast - dotfiles: tmuxp - lazyvim - tree-sitter - lspconfig - lazygit](https://asciinema.org/a/748818.svg)](https://asciinema.org/a/748818?autoplay=1&loop=1)
- Dotfiles - Zinit Initial Load
  [![Dotfiles - Zinit Initial Load](https://asciinema.org/a/666761.svg)](https://asciinema.org/a/666761?autoplay=1&loop=1)
