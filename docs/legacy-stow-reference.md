# Legacy GNU Stow Reference

> **Historical reference only.** This document captures the previous GNU Stow–managed version of this dotfiles repository (tag `old-gnu-stow-managed-for-reference-only`). The current repository is managed with [chezmoi](https://chezmoi.io). Keep this page for migration context and command history; do not treat it as the active setup guide.

---

## Table of Contents

1. [Overview](#overview)
2. [Core Architecture](#core-architecture)
3. [Requirements](#requirements)
4. [Quick Start](#quick-start)
5. [Package Management](#package-management)
6. [Directory Structure](#directory-structure)
7. [Workflow](#workflow)
8. [Philosophy](#philosophy)
9. [Demos](#demos)
10. [Tool Notes](#tool-notes)
11. [License](#license)

---

## Overview

Personal dotfiles repository for reproducible development environments across macOS, Linux, and Windows (PowerShell / WSL).

This repository was built around:

- **Modularity** (XDG-based structure)
- **Reproducibility** (`pkgs/` as state manifests)
- **Automation** (DRY `Justfile`)
- **Portability** (GNU `stow`)
- **Infrastructure-as-Code philosophy**

---

## Core Architecture

The repository was structured around three pillars:

1. **Symlink management** → GNU `stow`
2. **Package state management** → `pkgs/`
3. **Task orchestration** → `Justfile`

Everything was automated through `just`.

---

## Requirements

Ensure the following were installed before setup:

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
> This repository followed a **Dump → Commit → Restore** workflow.

All state was stored in:

```text
./pkgs/
```

The `Justfile` centralized configuration:

```make
PACKAGES := "./pkgs"
BREW_BUNDLE_DUMP := "brew bundle dump --describe --force --file"
BREW_BUNDLE_RESTORE := "brew bundle --file"
```

### Supported Package Managers

The following ecosystems were automated:

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

### Dump Installed State

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

### Restore State

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

## Demos

### Windows / Linux

#### PowerShell, Windows Subsystem for Linux (WSL), Docker, CUDA, Oh-My-Posh

[![asciinema](https://asciinema.org/a/760740.svg)](https://asciinema.org/a/760740?autoplay=1&loop=1)

### macOS

#### tmuxp (tmux), LazyVim (NeoVim), Tree-sitter, Language Server Protocol (LSP), Lazygit (Git)

[![asciinema](https://asciinema.org/a/748818.svg)](https://asciinema.org/a/748818?autoplay=1&loop=1)

#### Zsh, Zinit, Plugin orchestration

[![asciinema](https://asciinema.org/a/666761.svg)](https://asciinema.org/a/666761?autoplay=1&loop=1)

---

## Tool Notes

### Homebrew

See upstream guidance: https://docs.brew.sh/How-To-Open-a-Homebrew-Pull-Request

### EnvPane

EnvPane sets global environment variables for apps that do not respect the XDG spec.

**Installation (one-liner):**

```bash
(cd ~/Library/PreferencePanes && rm -rf EnvPane.prefPane && curl -sL https://github.com/hschmidt/EnvPane/releases/download/releases%2F0.8/EnvPane-0.8.tar.bz2 | tar -xjf -)
```

**First launch:**

```bash
open ~/Library/PreferencePanes/EnvPane.prefPane
```

**Usage:**

- GUI: System Settings → Environment Variables → add Name/Value.
- CLI: edit `~/.MacOSX/environment.plist` directly; valid changes apply automatically.

### GnuPG / GPG

The `pass` password manager and `pinentry` passphrase dialog (Assuan protocol) were used.

```bash
defaults write org.gpgtools.common UseKeychain false
```

**Troubleshooting:**

1. Restart the GPG agent after config changes:

   ```bash
   gpgconf --kill gpg-agent
   ```

2. Update the BrowserPass native messaging host after browser/BrowserPass updates:

   ```bash
   PREFIX='/usr/local/opt/browserpass' make hosts-BROWSER-user -f '/usr/local/opt/browserpass/lib/browserpass/Makefile'
   ```

   where `BROWSER` is one of `chromium`, `chrome`, `vivaldi`, `brave`, `firefox`.

**Working with keys:**

- Import public key: `gpg --import ./publickey.asc`
- Decrypt private key: `gpg ./privatekey.asc.enc`
- Import private key: `gpg --import ./privatekey.asc`

### NeoVim

Reference: https://neovimcraft.com/

**Troubleshooting (LazyVim / AstroNvim / NvChad / Kickstart only; LunarVim uses its own docs):**

Reset cache for standard Neovim:

```bash
rm -Rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```

Isolated Neovim apps (`$NVIM_APPNAME`):

```bash
rm -Rf ~/.local/share/${NVIM_APPNAME} ~/.local/state/${NVIM_APPNAME} ~/.cache/${NVIM_APPNAME}
```

### Notes — Tool History

| Tools | Status | Description | Actively Used Replacement |
| :--- | :--- | :--- | :--- |
| `iTerm2`, `Alacritty`, `Kitty` | ❌ Deleted | Less customizable | `Wezterm` |
| `Zellij` | ❌ Deleted | Prefer native terminal multiplexer | `Tmux` |
| `Oh My Zsh`, `zplug`, `Antigen`, `Antibody`, `antidote` | ❌ Deleted | Prefer actively maintained | `Zinit` |
| `RVM` | ❌ Deleted | Compiling issues | `rbenv` |
| `NVM` | ❌ Deleted | Compiling issues | `fnm` |
| `Pyenv` | ✅ Active | Used in some cases | `Poetry` and `venv` |
| `VSCode` | ✅ Active | Used while mastering Vim motions/plugins | `NeoVim` (LazyVim) |

### Packages — Detailed Reference

Brewfiles were organized into `Taps`, `Formulae`, `Casks`, `Mac App Store (MAS)`, and `VSCode Extensions`.

**Install packages:**

```bash
brew bundle install --no-lock --file ./packages/taps.Brewfile
brew bundle install --no-lock --file ./packages/formulae.Brewfile
brew bundle install --no-lock --file ./packages/casks.Brewfile
brew bundle install --no-lock --file ./packages/mas.Brewfile
brew bundle install --no-lock --file ./packages/vscode.Brewfile
brew bundle install --no-lock --file ./packages/whalebrew.Brewfile
```

**Dump existing packages to file:**

```bash
brew bundle dump --no-lock --describe --force --file ./packages/formulae.Brewfile --brews
brew bundle dump --no-lock --describe --force --file ./packages/casks.Brewfile --casks
brew bundle dump --no-lock --describe --force --file ./packages/taps.Brewfile --taps
brew bundle dump --no-lock --describe --force --file ./packages/mas.Brewfile --mas
brew bundle dump --no-lock --describe --force --file ./packages/vscode.Brewfile --vscode
brew bundle dump --no-lock --describe --force --file ./packages/whalebrew.Brewfile --whalebrew
```

**ASDF plugins:**

```bash
egrep -v '^(;|#|//)' ./packages/asdf-plugins | xargs -I {} asdf plugin add {}
# dump: asdf plugin list > ./packages/asdf-plugins
```

**Pyenv versions:**

```bash
egrep -v '^(;|#|//)' ./packages/pyenv-versions | xargs -I {} pyenv install {}
# dump: pyenv versions --bare --skip-aliases --skip-envs > ./packages/pyenv-versions
```

**pipx apps:**

```bash
awk '{print $1}' ./packages/pipx-apps | egrep -v '^(;|#|//)' | xargs -I {} pipx install {}
# dump: pipx list --short > ./packages/pipx-apps
```

**Krew plugins:**

```bash
awk '{print $1}' ./packages/krew-plugins | egrep -v '^(;|#|//)' | xargs -I {} krew install {}
# dump: krew list > ./packages/krew-plugins
```

**Helm repos:**

```bash
awk 'NR > 1 {split($0, ri, " "); print ri[1] " " ri[2]}' ./packages/helm-repos | egrep -v '^(;|#|//)' | xargs -n 2 helm repo add
# dump: helm repo list > ./packages/helm-repos
```

**Cargo packages:**

```bash
awk '{print $1}' ./packages/rust-cargo-packages | egrep -v '^(;|#|//)' | xargs -I {} cargo install {}
# dump: cat ~/.cargo/.crates2.json | jq -r '.installs | keys[] | split(" ")[0]' > ./packages/rust-cargo-packages
```

**GitHub CLI extensions:**

```bash
awk '{print $1}' ./packages/github-cli-extensions | egrep -v '^(;|#|//)' | xargs -I {} gh extension install {}
# dump: gh extension list | awk -F'\t' '{print $2}' > ./packages/github-cli-extensions
```

**Perl packages:**

```bash
cpan App::cpanminus
cpanm --installdeps ./packages/
```

**Ollama models:**

```bash
egrep -v '^(;|#|//)' ./packages/ollama-models | xargs -I {} ollama pull {}
# dump: ollama list | awk 'NR > 1 { print $1 }' > ./packages/ollama-models
```

**Hugging Face models:**

```bash
while IFS= read -r model_name; do
  repo_id="$(echo ${model_name%% *} | tr -d '[:blank:]')"
  filename="$(echo ${model_name#* } | tr -d '[:blank:]')"
  huggingface-cli download "$repo_id" "$filename"
done < <(awk 'NR > 1' ./packages/hugging-face-models | egrep -v '^(;|#|//)')
```

### Powerlevel10k

Clear the instant prompt cache:

```bash
rm -Rf $HOME/.cache/p10k-*
```

### Secrets

Distributed `.secrets` file example:

```bash
# vim: filetype=sh
# Github API Token
export GITHUB_API_TOKEN="####"
export GITHUB_TOKEN=${GITHUB_API_TOKEN}
export HOMEBREW_GITHUB_API_TOKEN=${GITHUB_API_TOKEN}

# OpenAI Tools
export OPENAI_API_KEY="####"

# Google AI Studio
export GEMINI_API_KEY="####"

# Ollama Tools
export OLLAMA_SERVER=http://localhost:11434

# Atuin.sh
export ATUIN_SYNC_ADDRESS="http://0.0.0.0:8888"
export ATUIN_ENTER_ACCEPT=false
export ATUIN_HOST="0.0.0.0"
export ATUIN_PORT="8888"
export ATUIN_OPEN_REGISTRATION=true
export ATUIN_DB_URI="postgres://atuin:<your-pgsql-password>@localhost/atuin"
```

### Shell

**Bash linting/formatting:**

- Run `editorconfig-checker` for EditorConfig errors.
- Run `shfmt --indent 2 --write ./<path>/<to>/<script>.sh` to format.

**Zsh troubleshooting:**

```bash
rm -f $HOME/.zcompdump && exec $SHELL -l
```

### Terminal (Kitty)

Mouse gesture support:

```text
Control + Command + With Mouse
```

macOS:

```bash
defaults write -g NSWindowShouldDragOnGesture YES
```

Kitty config:

```text
hide_window_decorations titlebar-only
```

### Vim

Plugin reference: https://vimawesome.com/

### VSCode

NeoVim integration — enable key repetition on macOS:

```bash
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
```

Validate settings:

```bash
defaults read com.microsoft.VSCode
```

### Windows

**PowerShell installation:**

```powershell
winget install Microsoft.PowerShell --source winget
# or from MSStore: winget install 9MZ1SNWT0N5D

winget install JanDeDobbeleer.OhMyPosh --source winget
# or from MSStore: winget install XP8K0HKJFRXGCK

winget install junegunn.fzf --source winget

oh-my-posh font install meslo

Get-ExecutionPolicy -List
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Uninstall a module (admin):

```powershell
pwsh -NoProfile -NonInteractive -Command "Uninstall-Module -Name PSReadLine -RequiredVersion 2.4.5"
```

**WSL installation:**

```bash
sudo apt update
sudo apt install zsh
sudo chsh -s $(which zsh) $USER

sudo apt-get install build-essential procps curl file git
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install zinit
brew install fzf
brew install oh-my-posh
```

Copy WSL configuration:

```bash
cp ./.config/zsh/linux.zsh ~/.wsl.zsh
echo -n "\n. ~/.wsl.zsh" >> ~/.zshrc
```

Run sync script:

```bash
bash ./sync.sh
```

### Zinit

Total reset and rebuild:

```bash
rm -Rf $HOME/.local/share/zinit $HOME/.cache/zinit
```

---

## License

[MIT](./LICENSE)