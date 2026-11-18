# ============================================================
# Dotfiles Installer (Windows PowerShell)
# ============================================================
#
# Omarchy does not apply on Windows, so this installer remains the Windows
# bootstrap. It installs the shared toolchain, refreshes PATH, and applies the
# chezmoi source state.

$ErrorActionPreference = "Stop"

if (-not $IsWindows -and $env:OS -ne "Windows_NT")
{
  throw "install.ps1 only supports Windows."
}

$Repo = "nathanielvarona"

function Test-Command
{
  param([string]$Name)

  if (-not $Name)
  {
    return $false
  }

  return $null -ne (Get-Command $Name -ErrorAction SilentlyContinue)
}

function Install-WingetPackage
{
  param(
    [string]$Command,
    [string]$WingetId
  )

  if ($Command -and (Test-Command $Command))
  {
    Write-Host "✓ $Command already installed."
    return
  }

  Write-Host "Installing $WingetId..."

  winget install `
    --id $WingetId `
    --exact `
    --accept-package-agreements `
    --accept-source-agreements
}

# ============================================================
# Requirements
# ============================================================

if (-not (Test-Command winget))
{
  throw "winget is required. Please install App Installer from the Microsoft Store."
}

Write-Host ""
Write-Host "Configuring PowerShell..."
Write-Host ""

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Core bootstrap tools
Install-WingetPackage git         Microsoft.Git
Install-WingetPackage chezmoi     twpayne.chezmoi
Install-WingetPackage just        Casey.Just
Install-WingetPackage pwsh        Microsoft.PowerShell

# Shell and terminal tooling
Install-WingetPackage delta       dandavison.delta
Install-WingetPackage fzf         junegunn.fzf
Install-WingetPackage oh-my-posh  JanDeDobbeleer.OhMyPosh
Install-WingetPackage zoxide      ajeetdsouza.zoxide
Install-WingetPackage rg          BurntSushi.ripgrep.MSVC
Install-WingetPackage fd          sharkdp.fd
Install-WingetPackage bat         sharkdp.bat
Install-WingetPackage lsd         lsd-rs.lsd
Install-WingetPackage lazygit     JesseDuffield.lazygit
Install-WingetPackage gh          GitHub.cli

# Neovim toolchain
Install-WingetPackage tree-sitter tree-sitter.tree-sitter-cli
Install-WingetPackage lua         rjpcomputing.luaforwindows
Install-WingetPackage gcc         BrechtSanders.WinLibs.POSIX.UCRT
Install-WingetPackage nvim        Neovim.Neovim
Install-WingetPackage psmux       marlocarlo.psmux

# Package managers and extras
Install-WingetPackage choco       Chocolatey.Chocolatey
Install-WingetPackage " "         LibreHardwareMonitor.LibreHardwareMonitor
Install-WingetPackage " "         Microsoft.VisualStudio.BuildTools
Install-WingetPackage " "         Google.Chrome

# ============================================================
# PATH and font setup
# ============================================================

# Refresh PATH for the current session so newly installed tools are visible.
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path", "User")

if (Test-Command choco)
{
  choco install nerd-fonts-nerdfontssymbolsonly --confirm --accept-license
}

# ============================================================
# Apply dotfiles
# ============================================================

$Chezmoi = (Get-Command chezmoi -ErrorAction Stop).Source

# Back up an existing .config directory before chezmoi overwrites managed files.
$ConfigPath = Join-Path $HOME ".config"
if (Test-Path $ConfigPath)
{
  $BackupPath = "$ConfigPath.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
  Write-Host "Backing up existing .config to $BackupPath"
  Copy-Item -Path $ConfigPath -Destination $BackupPath -Recurse -Force
}

Write-Host ""
Write-Host "Applying dotfiles..."
Write-Host ""

& $Chezmoi init --apply --force $Repo
}