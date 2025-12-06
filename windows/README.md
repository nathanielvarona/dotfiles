# Windows Install

Using Oh-My-Posh Terminal Prompt

## PowerShell

### Installation

```powershell
winget install JanDeDobbeleer.OhMyPosh --source winget
```

```powershell
oh-my-posh font install meslo
```

```powershell
Get-ExecutionPolicy -List
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Setup

```bash
bash ./sync.sh
```
