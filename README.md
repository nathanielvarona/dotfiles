# dotfiles

Personal dotfiles repository for reproducible development environments across macOS, Linux, and Windows (PowerShell / WSL).

This repository is built around:

- **Templating & State Management** (chezmoi)
- **Reproducibility** (`pkgs/` as state manifests)
- **Automation** (`Justfile`)
- **Cross-platform consistency**
- **Infrastructure-as-Code philosophy**

---

## Core Architecture

This repository is structured around three pillars:

1. **Dotfile management** → chezmoi
2. **Package state management** → `pkgs/`
3. **Task orchestration** → `Justfile`

All configuration is declarative and reproducible across environments.

---

## Requirements

Ensure the following are installed before setup:

- `git`
- `curl` or `wget`
- `zsh` (recommended shell)
- `just` (optional but recommended)
- `brew` (macOS / Linux)

> chezmoi will be installed automatically by the bootstrap script if missing.

---

## Quick Start

### Bootstrap (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/nathanielvarona/dotfiles/refs/heads/master/install.sh | sh
```

This will:

- Install Homebrew (if missing)
- Install dependencies (including chezmoi)
- Apply dotfiles
- Configure Zsh (Linux/WSL)
- Apply system settings

---

### Manual Setup

```bash
git clone https://github.com/nathanielvarona/dotfiles.git dotfiles
cd dotfiles

chezmoi init --apply nathanielvarona
```

---

## Chezmoi Workflow

### Apply changes

```bash
chezmoi apply
```

### Preview changes

```bash
chezmoi diff
```

### Edit a managed file

```bash
chezmoi edit ~/.zshrc
```

### Re-run templates / scripts

```bash
chezmoi apply --force
```

---

## Templating System

This repository heavily uses chezmoi templating:

- `.tmpl` → dynamic, OS-aware files
- `.chezmoitemplates/` → reusable config templates
- `.chezmoi.toml.tmpl` → central configuration

Example:

- OS-aware shell configs
- Shared VS Code settings
- PowerShell / Zsh unified behavior

---

## Cross-Platform Design

| Platform | Behavior                          |
| -------- | --------------------------------- |
| macOS    | Native Homebrew + Zsh             |
| Linux    | Homebrew (Linuxbrew) + Zsh        |
| WSL      | Linuxbrew + Zsh (auto-configured) |
| Windows  | PowerShell + AppData mapping      |

---

## VS Code Configuration Strategy

Single source of truth:

```text
~/.config/Code/User/
```

Handled via:

- `.chezmoitemplates/vscode/`
- Windows AppData mirroring via chezmoi

Ensures consistent editor experience across platforms.

---

## Package Management

> [!NOTE]
> This repository follows a **Dump → Commit → Restore** model.

All package state is stored in:

```text
./pkgs/
```

---

### Supported Package Managers

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

```bash
just dump-all
```

Individual:

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

```bash
just restore-all
```

---

## Directory Structure

```text
.
├── .chezmoitemplates        # Reusable config templates (e.g., VS Code)
├── dot_config               # XDG-based configuration (primary source)
├── AppData                  # Windows-specific targets (chezmoi-managed)
├── Documents                # PowerShell profiles
├── dot_scripts              # Custom scripts (autoload/bin/source)
├── private_dot_ssh          # SSH configs (private)
├── pkgs                     # Package state manifests
├── run_once_*               # One-time bootstrap scripts
├── .chezmoiexternal.toml    # External resources (themes, configs)
├── .chezmoiignore           # Ignore rules
├── Justfile                 # Task automation
└── README.md
```

---

## Workflow

### Fresh Machine

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/nathanielvarona/dotfiles/main/install.sh)"
```

---

### After Installing New Tools

```bash
just dump-all
git commit -m "update package state"
```

---

## Design Principles

- Declarative environment configuration
- Idempotent automation
- Cross-platform consistency
- Minimal manual setup
- Separation of config vs state

---

## Key Features

- Single source of truth for configs
- OS-aware templating (chezmoi)
- Unified Zsh + PowerShell environments
- Automated bootstrap (Homebrew + shell + locale)
- Reproducible package environments

---

## License

[MIT](./LICENSE)
