# ============================================================
# Dotfiles Installer (Windows PowerShell)
# ============================================================

$ErrorActionPreference = "Stop"

# ------------------------------------------------------------
# Platform Safety Check
# ------------------------------------------------------------

if (-not $IsWindows -and $env:OS -ne "Windows_NT")
{
  Write-Error "install.ps1 only supports Windows PowerShell or PowerShell on Windows"
  exit 1
}

$Repo = "nathanielvarona"

Write-Host ""
Write-Host "Installing dotfiles from $Repo..."
Write-Host ""

# ------------------------------------------------------------
# Ensure ~/.local/bin exists
# ------------------------------------------------------------

$BinDir = Join-Path $HOME ".local\bin"

if (-not (Test-Path $BinDir))
{
  New-Item -ItemType Directory -Path $BinDir -Force | Out-Null

  Write-Host "Created local bin directory"
  Write-Host "  Path : $BinDir"
  Write-Host ""
}

# Add to current session PATH
if ($env:Path -notlike "*$BinDir*")
{
  $env:Path = "$BinDir;$env:Path"
}

# ------------------------------------------------------------
# Install chezmoi if missing
# ------------------------------------------------------------

if (-not (Get-Command chezmoi -ErrorAction SilentlyContinue))
{
  Write-Host "Installing chezmoi..."

  $chezmoiInstallScript = Join-Path $env:TEMP "chezmoi-install.ps1"

  Invoke-WebRequest `
    -Uri "https://chezmoi.io/get.ps1" `
    -OutFile $chezmoiInstallScript

  & powershell.exe `
    -NoProfile `
    -ExecutionPolicy Bypass `
    -File $chezmoiInstallScript `
    -BinDir $BinDir

  Write-Host "Installed chezmoi"
  Write-Host ""
}

$Chezmoi = (Get-Command chezmoi).Source

# ------------------------------------------------------------
# Apply Dotfiles (Remote Source)
# ------------------------------------------------------------

Write-Host "Applying dotfiles..."
Write-Host "  Repository : $Repo"
Write-Host ""

& $Chezmoi init --apply $Repo
