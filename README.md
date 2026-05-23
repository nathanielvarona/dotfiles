# dotfiles

Personal cross-platform dotfiles repository for reproducible development environments across macOS, Native Linux, and Windows (CMD / PowerShell / WSL), powered by [chezmoi](https://chezmoi.io).

This repository focuses on:

- **Templating & State Management** using `chezmoi`
- **Reproducibility** through declarative `pkgs/` manifests
- **Automation** with `Justfile`
- **Cross-platform consistency** for `Zsh`, `PowerShell`, editors, terminals, and CLI tooling

---

## Requirements

- `git`
- `curl` or `wget`
- `zsh` (recommended for Unix-like systems)
- `just` (optional but recommended)
- `brew` (macOS/Linux)
- `scoop` or `winget` (Windows)

---

## Quick Start

### Automated Bootstrap

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

---

### Manual Setup

#### Install chezmoi

##### macOS or Linux

```bash
sh -c "$(curl -fsLS https://get.chezmoi.io)"
```

##### Windows (PowerShell)

```powershell
iex "&{$(irm 'https://get.chezmoi.io/ps1')}"
```

#### Initialize and apply

```bash
chezmoi init --apply nathanielvarona
```

---

## Package Management

This repository follows a:

```text
Dump → Commit → Restore
```

workflow to keep tooling reproducible across machines.

| Platform         | Managers Supported |
| :--------------- | :----------------- |
| macOS / Linux    | Homebrew           |
| Windows          | Winget, Scoop      |
| Universal        | mise, vfox, asdf   |
| Version Managers | pyenv, fnm, rbenv  |

### Usage

```bash
just dump-[TOOLING]
just restore-[TOOLING]
```

Examples:

```bash
just dump-brew
just restore-brew
```

---

## Key Features

- **Editor**: [LazyVim](https://lazyvim.org) ([Neovim](https://neovim.io/)) and [VSCode](https://code.visualstudio.com/) with [VSCode Neovim](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim) extension configuration.
- **Terminal**: [Kitty](https://sw.kovidgoyal.net/kitty/) and Windows [Terminal](https://github.com/microsoft/terminal) support.
- **Shell**: [Zsh](https://www.zsh.org/) and [PowerShell](https://github.com/powershell/powershell) with [Oh My Posh](https://ohmyposh.dev/) theme.

---

## Historical Reference

The previous GNU Stow-managed version of this repository is preserved for historical reference:

<https://github.com/nathanielvarona/dotfiles/tree/old-gnu-stow-managed-for-reference-only>

---

## License

[MIT](./LICENSE)
