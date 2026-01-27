# Windows Installation

## PowerShell

### Installation

Install PowerShell:

```bash
winget install Microsoft.PowerShell --source winget
# or from MSStore: winget install 9MZ1SNWT0N5D
```

Install Oh-My-Posh:

```bash
winget install JanDeDobbeleer.OhMyPosh --source winget
# or from MSStore: winget install XP8K0HKJFRXGCK
```

Install Fzf:

```bash
winget install junegunn.fzf --source winget
```

Install NerdFont:

```bash
oh-my-posh font install meslo
```

Set Execution Policy:

```bash
Get-ExecutionPolicy -List
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Uninstall Module Methods

Using Administraot privilege Command

```bash
pwsh -NoProfile -NonInteractive -Command "Uninstall-Module -Name PSReadLine -RequiredVersion 2.4.5"
```

### Setup

Run the sync script:

```bash
bash ./sync.sh
```

## Windows Subsystem for Linux (WSL)

### Installation

Update and install ZSH:

```bash
sudo apt update
sudo apt install zsh
sudo chsh -s $(which zsh) $USER
```

Install Homebrew:

```bash
sudo apt-get install build-essential procps curl file git
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install Zinit, Fzf and Oh-My-Posh:

```bash
brew install zinit
brew install fzf
brew install oh-my-posh
```

### Setup

Copy WSL configuration:

```bash
cp ./.config/zsh/linux.zsh ~/.wsl.zsh
echo -n "\n. ~/.wsl.zsh" >> ~/.zshrc
```
