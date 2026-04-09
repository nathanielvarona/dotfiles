# dotfiles

Personal dotfiles repository for reproducible development environments across macOS, Linux, and Windows (PowerShell / WSL).

This repository is built around:

- **Modularity** (XDG-based structure)
- **Reproducibility** (`pkgs/` as state manifests)
- **Automation** (DRY `Justfile`)
- **Portability** (GNU `stow`)
- **Infrastructure-as-Code philosophy**

---

## Core Architecture

This repository is structured around three pillars:

1. **Symlink management** → GNU `stow`
2. **Package state management** → `pkgs/`
3. **Task orchestration** → `Justfile`

Everything is automated through `just`.

---

## Requirements

Ensure the following are installed before setup:

- `brew`
- `git`
- `zsh`
- `stow`
- `just`

---

## Quick Start

### Clone

```bash
git clone https://github.com/nathanielvarona/dotfiles.git dotfiles
cd dotfiles
```

### Apply Dotfiles

```bash
just stow apply
```

Preview changes:

```bash
just stow apply dry-run
```

Remove symlinks:

```bash
just stow delete
```

Restow:

```bash
just stow restow
```

---

## Package Management

> [!NOTE]
> This repository follows a **Dump → Commit → Restore**.

All state is stored in:

```
./pkgs/
```

The `Justfile` centralizes configuration:

```make
PACKAGES := "./pkgs"
BREW_BUNDLE_DUMP := "brew bundle dump --describe --force --file"
BREW_BUNDLE_RESTORE := "brew bundle --file"
```

---

### Supported Package Managers

The following ecosystems are automated:

- Homebrew (formulae, casks, taps, mas, vscode)
- asdf
- pyenv
- pipx
- kubectl krew
- Helm repos
- Cargo
- GitHub CLI extensions
- Whalebrew
- Ollama models
- Hugging Face models
- Perl modules

---

## Dump Installed State

Dump everything:

```bash
just dump-all
```

Dump individual managers:

```bash
just dump-brew
just dump-asdf
just dump-pyenv
just dump-pipx
just dump-krew
just dump-helm
just dump-cargo
just dump-gh-ext
just dump-whalebrew
just dump-ollama
just dump-hugging-face
just dump-perl-modules
```

---

## Restore State

Restore everything:

```bash
just restore-all
```

Restore individual managers:

```bash
just restore-brew
just restore-asdf
just restore-pyenv
just restore-pipx
just restore-krew
just restore-helm
just restore-cargo
just restore-gh-ext
just restore-whalebrew
just restore-ollama
just restore-hugging-face
just restore-perl-modules
```

---

### Restoration Design Principles

- Idempotent
- File-existence guarded (`[ -f file ]`)
- Non-breaking (`|| true`)
- Pipeline-safe (`cat | xargs`)
- Safe loops for multi-field entries (Helm, asdf)

Example:

```bash
if [ -f ./pkgs/pyenv-versions ]; then
  cat ./pkgs/pyenv-versions | xargs -I{} pyenv install {} || true
fi
```

---

## Directory Structure

```text
.
├── .config                          # XDG base directory for user application configurations
│   ├── .ssh                         # SSH client configuration and key management
│   ├── aerospace                    # Aerospace tiling window manager configuration (macOS)
│   ├── alacritty                    # Alacritty GPU-accelerated terminal configuration
│   ├── asdf                         # asdf version manager configuration
│   ├── atuin                        # Atuin shell history synchronization configuration
│   ├── bat                          # bat syntax-highlighting pager configuration
│   ├── Code                         # Visual Studio Code user configuration
│   ├── fzf                          # fzf fuzzy finder configuration
│   ├── gh-dash                      # GitHub CLI dashboard configuration
│   ├── ghostty                      # Ghostty terminal emulator configuration
│   ├── git                          # Git configuration (user settings, aliases, includes)
│   ├── gnupg                        # GnuPG encryption and signing configuration
│   ├── kitty                        # Kitty terminal emulator configuration
│   ├── lazygit                      # Lazygit terminal UI configuration
│   ├── lazyvim                      # LazyVim (Neovim distribution) configuration
│   ├── lsd                          # LSD modern ls replacement configuration
│   ├── luarocks                     # LuaRocks Lua package manager configuration
│   ├── oh-my-posh                   # Oh My Posh shell prompt configuration
│   ├── opencode                     # OpenCode editor and tooling configuration
│   ├── powerlevel10k                # Powerlevel10k Zsh prompt theme configuration
│   ├── powershell                   # PowerShell profiles and modules
│   ├── scooter                      # Third-party or custom CLI tool configurations
│   ├── tmux                         # tmux terminal multiplexer configuration
│   ├── ueberzugpp                   # ueberzug++ image preview backend configuration
│   ├── vim                          # Minimal or legacy Vim configuration
│   ├── wezterm                      # WezTerm terminal emulator configuration
│   ├── yazi                         # Yazi terminal file manager configuration
│   ├── zed                          # Zed editor configuration
│   ├── zellij                       # Zellij terminal workspace configuration
│   └── zsh                          # Zsh shell primary configuration
├── .MacOSX                          # macOS-specific environment configuration
│   └── environment.plist            # LaunchServices environment variable definitions
├── .scripts                         # Custom automation scripts and helper utilities
│   ├── autoload                     # Shell scripts automatically sourced by the shell
│   ├── bin                          # Executable helper scripts and utilities
│   └── source                       # Modular script libraries and reusable components
├── docs                             # Internal documentation and technical references
│   ├── brew                         # Homebrew usage and configuration notes
│   ├── envpane                      # Environment panel documentation and notes
│   ├── gnupg                        # GnuPG usage documentation
│   ├── neovim                       # Neovim configuration documentation
│   ├── notes                        # General development and environment notes
│   ├── packages                     # Package management documentation
│   ├── powerlevel10k                # Powerlevel10k customization notes
│   ├── secrets                      # Secure configuration and secret management notes
│   ├── shell                        # Shell configuration documentation
│   ├── terminal                     # Terminal emulator documentation
│   ├── vim                          # Vim configuration documentation
│   ├── vscode                       # Visual Studio Code documentation
│   ├── windows                      # Windows environment setup documentation
│   └── zinit                        # Zinit plugin manager documentation
├── external                         # External dependencies managed as Git submodules
│   └── <upstream-owner>             # Upstream GitHub user or organization
│       └── <repository>             # External project repository
├── pkgs                             # Reproducible package and dependency manifests
│   ├── asdf-plugins                 # asdf plugin definitions
│   ├── cask.Brewfile                # Homebrew casks (GUI applications)
│   ├── cpanfile                     # Perl dependency manifest
│   ├── formulae.Brewfile            # Homebrew formulae (CLI tools)
│   ├── github-cli-extensions        # GitHub CLI extensions list
│   ├── helm-repos                   # Helm repository definitions
│   ├── hugging-face-models          # Hugging Face model references
│   ├── krew-plugins                 # kubectl krew plugin definitions
│   ├── mas.Brewfile                 # Mac App Store application definitions
│   ├── ollama-models                # Ollama local AI model definitions
│   ├── pipx-apps                    # pipx-installed Python applications
│   ├── pyenv-versions               # pyenv-managed Python versions
│   ├── rust-cargo-packages          # Cargo-installed Rust CLI packages
│   ├── tap.Brewfile                 # Homebrew tap repositories
│   ├── vscode.Brewfile              # VSCode extension definitions
│   └── whalebrew                    # Whalebrew containerized CLI tools
├── .editorconfig                    # Editor formatting and style consistency rules
├── .gitignore                       # Git ignore rules
├── .markdownlint-cli2.yaml          # Markdown linting configuration
├── .secrets                         # Local secret references (not committed)
├── .stowrc                          # GNU Stow configuration
├── .taplo.toml                      # TOML formatter configuration
├── .tmuxp.yaml                      # tmuxp session layout definitions
├── .tool-versions                   # asdf runtime version definitions (local only)
├── .zshenv                          # Zsh early environment initialization
├── Justfile                         # Task runner automation (Just)
├── LICENSE                          # MIT license
└── README.md                        # Repository documentation
```

---

## Workflow

### On a Fresh Machine

```bash
git clone ...
cd dotfiles

just restore-all
just stow apply
```

### After Installing New Tools

```bash
just dump-all
git commit -m "update package state"
```

---

## Philosophy

- Treat development environment as **declarative infrastructure**
- Keep system **reproducible and versioned**
- Avoid manual installs and snowflake machines

---

## Asciinema Demos

### Windows / Linux

#### PowerShell, Windows Subsystem for Linux (WSL), Docker, CUDA, Oh-My-Posh

[![asciinema](https://asciinema.org/a/760740.svg)](https://asciinema.org/a/760740?autoplay=1&loop=1)

### macOS

#### tmuxp (tmux), LazyVim (NeoVim), Tree-sitter, Language Server Protocol (LSP) , Lazygit (Git)

[![asciinema](https://asciinema.org/a/748818.svg)](https://asciinema.org/a/748818?autoplay=1&loop=1)

#### Zsh, Zinit, Plugin orchestration

[![asciinema](https://asciinema.org/a/666761.svg)](https://asciinema.org/a/666761?autoplay=1&loop=1)

---

## License

[MIT](./LICENSE)
