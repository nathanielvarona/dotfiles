# dotfiles

Personal dotfiles repository for reproducible development environments across macOS, Linux, and Windows (CMD / PowerShell / WSL).

This repository is built around:

- **Templating & State Management**: [chezmoi](https://chezmoi.io)
- **Reproducibility**: `pkgs/` as declarative state manifests
- **Automation**: `Justfile` task runner
- **Cross-platform consistency**: Unified configs for Zsh, PowerShell, and various CLIs

---

## Core Architecture

1. **Dotfile management** → `chezmoi` handles configuration templating and symlinking.
2. **Package state management** → `pkgs/` directory tracks installed tooling software.
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

#### macOS or Linux

```bash
curl -fsSL \
  https://raw.githubusercontent.com/nathanielvarona/dotfiles/main/install.sh \
    | sh
```

#### Windows (PowerShell)

```powershell
irm `
  https://raw.githubusercontent.com/nathanielvarona/dotfiles/main/install.ps1 `
    | iex
```

### Manual Setup

#### 1. Install chezmoi

##### macOS or Linux

```bash
sh -c "$(curl -fsLS https://get.chezmoi.io)"
```

##### Windows (PowerShell)

```powershell
iex "&{$(irm 'https://get.chezmoi.io/ps1')}"
```

##### 2. Initialize and apply

```bash
chezmoi init --apply nathanielvarona
```

---

## Package Management

This repo uses a **Dump → Commit → Restore** model to keep software synchronized across machines.

**Such as:**

| Platform        | Managers Supported            |
| :-------------- | :---------------------------- |
| **macOS/Linux** | Homebrew (Formulae and Casks) |
| **Windows**     | Winget and Scoop              |
| **Universal**   | mise and fox                  |

**Usage:**

- `just dump-[TOOLING]`: Save tooling state to `pkgs/`
- `just restore-[TOOLING]`: Install missing tooling from `pkgs/`

---

## Key Features

- **Editor**: [LazyVim](https://lazyvim.org) ([Neovim](https://neovim.io/)) and [VSCode](https://code.visualstudio.com/) with [VSCode Neovim](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim) extension configuration.
- **Terminal**: [Kitty](https://sw.kovidgoyal.net/kitty/) and Windows [Terminal](https://github.com/microsoft/terminal) support.
- **Shell**: [Oh My Posh](https://ohmyposh.dev/) themed [Zsh](https://www.zsh.org/) and [PowerShell](https://github.com/powershell/powershell).

---

## License

[MIT](./LICENSE)
