# dotfiles

My Dotfiles Collection

## Features

- A collection of dotfiles for easy setup and configuration of my development environment
- Managed using GNU `stow` to symlink dotfiles to my home directory `~/` or `$HOME`
- Handy scripts for installing packages and development toolings

## Demos

### Zinit Initial Load

<a href="https://asciinema.org/a/666761?autoplay=1&loop=1">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./doc/img/demo/zinit-dark.gif" />
    <img alt="Zinit Initial Load" src="./doc/img/demo/zinit-light.gif" />
  </picture>
</a>

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

## Toolings Comprehensive Documentation

Kindly check the [./doc](./doc) directory.
