# dotfiles

Personal cross-platform dotfiles for reproducible development environments across macOS, Native Linux, and Windows (CMD / PowerShell / WSL), powered by [chezmoi](https://chezmoi.io).

## Highlights

- **Templating & state management** with chezmoi
- **Reproducibility** through declarative `pkgs/` manifests
- **Automation** via `Justfile`
- **Cross-platform consistency** for Zsh, PowerShell, editors, terminals, and CLI tooling
- **Windows desktop setup** including GlazeWM, YASB, and PowerToys DSC

## Requirements

- `git`
- `curl` or `wget`
- `zsh` (recommended for Unix-like systems)
- `just` (optional but recommended)
- `brew` (macOS/Linux) or `scoop`/`winget` (Windows)

## Quick Start

### Automated Bootstrap

**macOS / Linux**

```bash
curl -fsSL https://raw.githubusercontent.com/nathanielvarona/dotfiles/main/install.sh | sh
```

**Windows (PowerShell)**

```powershell
irm https://raw.githubusercontent.com/nathanielvarona/dotfiles/main/install.ps1 | iex
```

### Manual Setup

**Install chezmoi**

- macOS / Linux: `sh -c "$(curl -fsLS https://get.chezmoi.io)"`
- Windows (PowerShell): `iex "&{$(irm 'https://get.chezmoi.io/ps1')}"`

**Initialize and apply**

```bash
chezmoi init --apply nathanielvarona
```

## Package Management

This repository follows a **Dump → Commit → Restore** workflow to keep tooling reproducible across machines.

| Platform | Managers |
| :--- | :--- |
| macOS / Linux | Homebrew |
| Windows | Winget, Scoop |
| Universal | mise, vfox, asdf |
| Version managers | pyenv, fnm, rbenv |

```bash
just dump-[TOOLING]
just restore-[TOOLING]
```

Examples:

```bash
just dump-brew
just restore-brew
```

## Key Features

- **Editor**: [LazyVim](https://lazyvim.org) (Neovim) and [VSCode](https://code.visualstudio.com/) with VSCode Neovim
- **Terminal**: [Kitty](https://sw.kovidgoyal.net/kitty/) and Windows Terminal
- **Shell**: [Zsh](https://www.zsh.org/) and [PowerShell](https://github.com/powershell/powershell) with [Oh My Posh](https://ohmyposh.dev/)
- **Desktop (Windows)**: [GlazeWM](https://github.com/glzr-io/glazewm), [YASB](https://github.com/amnweb/yasb), and [PowerToys](https://github.com/microsoft/PowerToys) DSC

## Documentation

- [Docs index](./docs/README.md)
- [Installation](./docs/installation/README.md)
- [Troubleshooting](./docs/troubleshooting/README.md)
- [Neovim](./docs/neovim/README.md)
- [WSL host services](./docs/wsl/HOST_SERVICES_ACCESS.md)

## Historical Reference

The previous GNU Stow-managed version of this repository is preserved for historical reference:

- Tag: <https://github.com/nathanielvarona/dotfiles/tree/old-gnu-stow-managed-for-reference-only>
- Consolidated reference: [docs/legacy-stow-reference.md](./docs/legacy-stow-reference.md)

## License

[MIT](./LICENSE)