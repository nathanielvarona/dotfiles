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

# Stow Package(s)
stow <PACKAGE NAME>

# Restow Package(s)
stow -R <PACKAGE NAME>

# Unstow Package(s)
stow -D <PACKAGE NAME>
```


## Contributing

### Linting and File Formatting

To ensure consistency and cleanliness, I use:

* `editorconfig-checker` for EditorConfig validation
* `shfmt` for shell script formatting

Usage
* Run `editorconfig-checker` to check for EditorConfig errors
* Run `shfmt --indent 2 -w ./scripts/.scripts/<path-to>/<script>.source.sh` to format shell scripts
