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

- `git`
- `stow`
- `just`
- `brew` (macOS)
- `zsh` (recommended)

---

## Quick Start

### Clone

```bash
git clone https://github.com/nathanielvarona/dotfiles.git dotfiles
cd dotfiles
```

### Stow Commands

Apply all dotfiles:

```bash
just stow apply
```

Dry-run to preview changes:

```bash
just stow apply dry-run
```

Remove symlinks:

```bash
just stow delete
```

Restow (delete + reapply):

```bash
just stow restow
```

---

## Package Management

This repository follows a **Dump → Commit → Restore** workflow.

All package states are stored in:

```
./pkgs/
```

The `Justfile` uses DRY variables:

```make
PACKAGES := "./pkgs"
BREW_BUNDLE_DUMP := "brew bundle dump --describe --force --file"
```

---

### Dump Installed Packages

Dump everything:

```bash
just dump-all
```

Dump specific managers:

```bash
just dump-brew
just dump-asdf
just dump-pyenv
just dump-pipx
just dump-cargo
just dump-gh-ext
just dump-krew
just dump-helm
just dump-ollama
just dump-hugging-face
just dump-whalebrew
```

These commands update manifests inside `pkgs/`:

- `formulae.Brewfile`
- `casks.Brewfile`
- `pyenv-versions`
- `pipx-apps`
- `rust-cargo-packages`
- `github-cli-extensions`

---

### Restore Packages

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
just restore-cargo
just restore-gh-ext
just restore-krew
just restore-helm
just restore-ollama
just restore-hugging-face
just restore-whalebrew
```

---

### Restoration Principles

- **Idempotent**
- Safe if files are missing or empty
- Non-breaking (`|| true` applied)
- Pipeline-friendly (`cat | xargs`)

Example:

```bash
[ -f {{PACKAGES}}/pyenv-versions ] && \
cat {{PACKAGES}}/pyenv-versions | xargs -I{} pyenv install {} || true
```

---

### Directory Structure

```text
.
├── .config                          # XDG base directory for user-level application configs
│   ├── .ssh                         # SSH client configuration and keys
│   ├── aerospace                    # Aerospace tiling WM configs (macOS)
│   ├── alacritty                    # Alacritty terminal config
│   ├── asdf                         # asdf version manager config
│   ├── atuin                        # Atuin shell history manager config
│   ├── bat                          # bat (cat clone with syntax highlighting) config
│   ├── Code                         # VSCode configuration
│   ├── fzf                          # fzf fuzzy finder config
│   ├── gh-dash                      # GitHub CLI dashboard config
│   ├── ghostty                      # Ghostty terminal config
│   ├── git                          # Git config (user, aliases, includes)
│   ├── gnupg                        # GnuPG encryption/signing config
│   ├── kitty                        # Kitty terminal config
│   ├── lazygit                      # Lazygit TUI config
│   ├── lazyvim                      # LazyVim (Neovim) config
│   ├── lsd                          # LSD (modern ls replacement) config
│   ├── luarocks                     # LuaRocks package manager config
│   ├── oh-my-posh                   # Oh My Posh prompt config
│   ├── opencode                     # OpenCode editor/tooling config
│   ├── powerlevel10k                # Powerlevel10k Zsh prompt theme config
│   ├── powershell                   # PowerShell profiles & modules
│   ├── scooter                      # Custom/third-party CLI tool configs
│   ├── tmux                         # tmux terminal multiplexer config
│   ├── ueberzugpp                   # ueberzugpp image preview backend config
│   ├── vim                          # Vim legacy/minimal config
│   ├── wezterm                      # WezTerm terminal config
│   ├── yazi                         # Yazi TUI file manager config
│   ├── zed                          # Zed editor config
│   ├── zellij                       # Zellij terminal multiplexer config
│   └── zsh                          # Zsh shell primary configuration
├── .MacOSX                          # macOS-specific environment configs
│   └── environment.plist            # macOS launch environment variables
├── .scripts                         # Custom automation & helper scripts
│   ├── autoload                     # Scripts automatically sourced by shell
│   ├── bin                          # Executable utility scripts
│   └── source                       # Modular script components
├── docs                             # Internal documentation & technical notes
│   ├── brew                         # Homebrew docs
│   ├── envpane                      # Environment pane notes
│   ├── gnupg                        # GPG documentation
│   ├── neovim                       # Neovim documentation
│   ├── notes                        # General technical notes
│   ├── packages                     # Package management references
│   ├── powerlevel10k                # Prompt customization docs
│   ├── secrets                      # Secure configuration handling
│   ├── shell                        # Shell configuration documentation
│   ├── terminal                     # Terminal documentation
│   ├── vim                          # Vim docs
│   ├── vscode                       # VSCode docs
│   ├── windows                      # Windows-specific setup notes
│   └── zinit                        # Zinit plugin manager docs
├── pkgs                             # Reproducible package & dependency manifests
│   ├── asdf-plugins                 # asdf plugin list
│   ├── casks.Brewfile               # Homebrew casks (GUI apps)
│   ├── cpanfile                     # Perl dependencies
│   ├── formulae.Brewfile            # Homebrew formulae (CLI tools)
│   ├── github-cli-extensions        # GitHub CLI extensions list
│   ├── helm-repos                   # Helm repository definitions
│   ├── hugging-face-models          # Hugging Face models references
│   ├── krew-plugins                 # kubectl krew plugins list
│   ├── mas.Brewfile                 # Mac App Store apps list
│   ├── ollama-models                # Ollama local AI model definitions
│   ├── pipx-apps                    # pipx-installed Python applications
│   ├── pyenv-versions               # pyenv-managed Python versions
│   ├── rust-cargo-packages          # Rust cargo-installed packages
│   ├── taps.Brewfile                # Homebrew taps
│   ├── vscode.Brewfile              # VSCode extensions
│   └── whalebrew                    # Whalebrew containerized CLI tools
├── .editorconfig                    # Editor formatting consistency rules
├── .gitignore                       # Git ignore rules
├── .markdownlint-cli2.yaml          # Markdown linting config
├── .secrets                         # Local secret references (not committed)
├── .stowrc                          # GNU Stow configuration
├── .taplo.toml                      # TOML formatter config
├── .tmuxp.yaml                      # tmuxp session layout config
├── .tool-versions                   # asdf runtime version definitions
├── .zshenv                          # Zsh early environment initialization
├── Justfile                         # Task runner definitions (Just automation)
├── LICENSE                          # MIT License
└── README.md                        # Repository documentation
```

## Workflow

On a new machine:

```bash
git clone ...
cd dotfiles

just restore-all
just stow apply
```

On an existing machine after installing new tools:

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

PowerShell, WSL, Docker, CUDA, Oh-My-Posh  
[![asciinema](https://asciinema.org/a/760740.svg)](https://asciinema.org/a/760740?autoplay=1&loop=1)

### macOS

tmuxp, LazyVim, Treesitter, LSP, Lazygit  
[![asciinema](https://asciinema.org/a/748818.svg)](https://asciinema.org/a/748818?autoplay=1&loop=1)

### macOS (Zinit)

[![asciinema](https://asciinema.org/a/666761.svg)](https://asciinema.org/a/666761?autoplay=1&loop=1)

---

## License

[MIT](./LICENSE)
