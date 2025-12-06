# Windows Installation

Using Oh-My-Posh Terminal Prompt

## PowerShell

### Installation

Upgrade/Install PowerShell

```powershell
winget install Microsoft.PowerShell --source winget

# From MSStore
winget install 9MZ1SNWT0N5D
```

Install Oh-My-Posh

```powershell
winget install JanDeDobbeleer.OhMyPosh --source winget

# From MSStore
winget install XP8K0HKJFRXGCK
```

Install NerdFont

```powershell
oh-my-posh font install meslo
```

Set Execution Policy

```powershell
Get-ExecutionPolicy -List
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Setup

```bash
bash ./sync.sh
```

## Windows Subsystem for Linux (WSL)

### Installation

```bash
sudo apt update
sudo apt install zsh
```

```bash
sudo chsh -s $(which zsh) $USER
```

Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install Zinit

```bash
brew install zinit
```

Install Oh-My-Posh

```bash
brew install oh-my-posh
```
