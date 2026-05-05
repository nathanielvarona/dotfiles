# dotfiles

Personal dotfiles repository for reproducible development environments across macOS, Linux, and Windows (CMD / PowerShell / WSL).

This repository is built around:

- **Templating & State Management**: [chezmoi](https://chezmoi.io)
- **Reproducibility**: `pkgs/` as declarative state manifests
- **Automation**: `Justfile` task runner
- **Cross-platform consistency**: Unified configs for Zsh, PowerShell, and various CLIs

---

## Core Architecture

1. **Dotfile management** → `chezmoi` handles symlinking and templating.
2. **Package state management** → `pkgs/` directory tracks installed software.
3. **Task orchestration** → `Justfile` simplifies complex maintenance workflows.

---

## Requirements

- `git`, `curl` or `wget`
- `zsh` (primary shell for Unix-like systems)
- `just` (command runner)
- `brew` (macOS / Linux) or `scoop`/`winget` (Windows)

---

## Quick Start

### Bootstrap (Automated)

```bash
curl -fsSL https://raw.githubusercontent.com/nathanielvarona/dotfiles/main/install.sh \
  | sh
```

### Manual Setup

```bash
# Install chezmoi

# macOS or Linux
sh -c "$(curl -fsLS https://get.chezmoi.io)"

# Windows PowerShell
iex "&{$(irm 'https://get.chezmoi.io/ps1')}"

# Initialize and apply
chezmoi init --apply nathanielvarona
```

---

## Package Management

This repo uses a **Dump → Commit → Restore** model to keep software synchronized across machines.

| Platform        | Managers Supported                                           |
| :-------------- | :----------------------------------------------------------- |
| **macOS/Linux** | Homebrew (Formulae/Casks), asdf, pyenv, pipx, krew, cargo    |
| **Windows**     | Scoop, WinGet, PowerShell modules                            |
| **Universal**   | GitHub CLI Extensions, Helm, Ollama, Hugging Face, Whalebrew |

**Usage:**

- `just dump-all`: Save current system state to `pkgs/`
- `just restore-all`: Install all missing packages from `pkgs/`

---

## Key Features

- **Editor**: [LazyVim](https://lazyvim.org) ([Neovim](https://neovim.io/)) and [VSCode](https://code.visualstudio.com/) with [VSCode Neovim](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim) extension configuration.
- **Terminal**: [Kitty](https://sw.kovidgoyal.net/kitty/), and Windows [Terminal](https://github.com/microsoft/terminal) support.
- **Shell**: [Oh My Posh](https://ohmyposh.dev/) themed [Zsh](https://www.zsh.org/) and [PowerShell](https://github.com/powershell/powershell).

---

## License

[MIT](./LICENSE)
