# ============================================================
# Dotfiles Installer (Windows PowerShell)
# ============================================================

$ErrorActionPreference = "Stop"

if (-not $IsWindows -and $env:OS -ne "Windows_NT")
{
  throw "install.ps1 only supports Windows."
}

$Repo = "nathanielvarona"

function Test-Command
{
  param([string]$Name)
  return $null -ne (Get-Command $Name -ErrorAction SilentlyContinue)
}

function Install-WingetPackage
{
  param(
    [string]$Command,
    [string]$WingetId
  )

  if (Test-Command $Command)
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

# ------------------------------------------------------------
# Requirements
# ------------------------------------------------------------

if (-not (Test-Command winget))
{
  throw "winget is required. Please install App Installer from the Microsoft Store."
}

Write-Host ""
Write-Host "Configuring PowerShell..."
Write-Host ""

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

Install-WingetPackage git         Microsoft.Git
Install-WingetPackage delta       dandavison.delta
Install-WingetPackage fzf         junegunn.fzf
Install-WingetPackage oh-my-posh  JanDeDobbeleer.OhMyPosh
Install-WingetPackage chezmoi     twpayne.chezmoi

# Refresh PATH for current session
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") +
";" +
[System.Environment]::GetEnvironmentVariable("Path", "User")

# Install Nerd Font Symbols
if (Test-Command oh-my-posh)
{
  oh-my-posh font install NerdFontsSymbolsOnly
}

# Verify chezmoi
$Chezmoi = (Get-Command chezmoi -ErrorAction Stop).Source

Write-Host ""
Write-Host "Applying dotfiles..."
Write-Host ""

& $Chezmoi init --apply $Repo
