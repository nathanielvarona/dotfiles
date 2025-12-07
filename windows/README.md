# Windows Installation

## PowerShell

### Installation

1. Install PowerShell:

```bash
winget install Microsoft.PowerShell --source winget
# or from MSStore: winget install 9MZ1SNWT0N5D
```

2. Install Oh-My-Posh:

```bash
winget install JanDeDobbeleer.OhMyPosh --source winget
# or from MSStore: winget install XP8K0HKJFRXGCK
```

3. Install NerdFont:

```bash
oh-my-posh font install meslo
```

4. Set Execution Policy:

```bash
Get-ExecutionPolicy -List
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Setup

1. Run the sync script:

```bash
bash ./sync.sh
```

## Windows Subsystem for Linux (WSL)

### Installation

1. Update and install ZSH:

```bash
sudo apt update
sudo apt install zsh
sudo chsh -s $(which zsh) $USER
```

2. Install Homebrew:

```bash
sudo apt-get install build-essential procps curl file git
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

3. Install Zinit and Oh-My-Posh:

```bash
brew install zinit
brew install oh-my-posh
```

### Setup

1. Copy WSL configuration:

```bash
cp wsl.zsh ~/.wsl.zsh
echo -n "\nsource ~/.wsl.zsh" >> ~/.zshrc
```
