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
Install-WingetPackage choco       Chocolatey.Chocolatey
Install-WingetPackage just        Casey.Just
Install-WingetPackage pwsh        Microsoft.PowerShell
Install-WingetPackage rg          BurntSushi.ripgrep.MSVC
Install-WingetPackage fd          sharkdp.fd
Install-WingetPackage gcc         BrechtSanders.WinLibs.POSIX.UCRT
Install-WingetPackage nvim        Neovim.Neovim
Install-WingetPackage lazygit     JesseDuffield.lazygit
Install-WingetPackage gh          GitHub.cli
Install-WingetPackage ""          Google.Chrome

# Refresh PATH for current session
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") +
";" +
[System.Environment]::GetEnvironmentVariable("Path", "User")

# Install Nerd Font Symbols
if (Test-Command choco)
{
  choco install nerd-fonts-nerdfontssymbolsonly --confirm --accept-license
}

# Verify chezmoi
$Chezmoi = (Get-Command chezmoi -ErrorAction Stop).Source

Write-Host ""
Write-Host "Applying dotfiles..."
Write-Host ""

& $Chezmoi init --apply $Repo
