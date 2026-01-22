# ============================================================
# Cursor Shape (Modern Terminals Only)
# ============================================================
# Cursor shape values:
# 0 = Default (terminal-configured)
# 1 = Blinking Block
# 2 = Steady Block
# 3 = Blinking Underline
# 4 = Steady Underline
# 5 = Blinking Bar
# 6 = Steady Bar
#
# ANSI escape sequences are reliably supported only in
# PowerShell 7+ (and modern terminals). PowerShell 5.1
# will print these sequences literally, so we guard it.
if ($PSVersionTable.PSVersion.Major -ge 7)
{
  Write-Host -NoNewLine "`e[6 q"
}

# ============================================================
# Oh My Posh Prompt Initialization
# ============================================================
# Build the path to the Oh My Posh theme configuration
$configPath = Join-Path $PSScriptRoot "../ohmyposh/zen.omp.toml"

# Initialize Oh My Posh only if:
# - The oh-my-posh command exists
# - The configuration file is present
#
# This prevents profile errors and keeps startup silent
if (
  (Get-Command oh-my-posh -ErrorAction SilentlyContinue) -and
  (Test-Path $configPath)
)
{
  oh-my-posh init powershell --config $configPath | Invoke-Expression
}

# ============================================================
# PSReadLine Module Bootstrap
# ============================================================
# Minimum PSReadLine version required for stable behavior
# across PowerShell 5.1 and 7+
$MinPSReadLine = [Version]'2.3.6'

# Get the highest installed PSReadLine version (if any)
$InstalledPSReadLine = Get-Module PSReadLine -ListAvailable |
  Sort-Object Version -Descending |
  Select-Object -First 1

# Install or upgrade PSReadLine if missing or outdated
# - CurrentUser scope avoids admin privileges
# - AllowClobber prevents command conflicts
# - Errors are suppressed to avoid profile startup failures
if (-not $InstalledPSReadLine -or $InstalledPSReadLine.Version -lt $MinPSReadLine)
{
  Install-Module -Name PSReadLine -Repository PSGallery -Scope CurrentUser -Force -AllowClobber -ErrorAction SilentlyContinue

  # Prompt the user to restart the PowerShell session
  Write-Host ""
  Write-Warning "Please exit this PowerShell session and reopen a new one to apply changes."
  Write-Host ""

  # Exit the current PowerShell session
  exit 0
}

# ============================================================
# PSReadLine Configuration
# ============================================================
# Import PSReadLine only if it is available
if (Get-Module -ListAvailable PSReadLine)
{
  Import-Module PSReadLine

  # Enable command prediction based on history
  Set-PSReadLineOption -PredictionSource History

  # Keep the cursor at the end of the line when searching history
  Set-PSReadLineOption -HistorySearchCursorMovesToEnd

  # Enable incremental history search with arrow keys
  Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward
  Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}

# ============================================================
# PSFzf Module Bootstrap
# ============================================================
# Install PSFzf if it is not already available
# PSFzf integrates fzf with PSReadLine for fast navigation
if (-not (Get-Module -ListAvailable PSFzf))
{
  Install-Module -Name PSFzf -Repository PSGallery -Scope CurrentUser -Force -ErrorAction SilentlyContinue
}

# ============================================================
# PSFzf Configuration
# ============================================================
# Load PSFzf and configure key bindings if available
if (Get-Module -ListAvailable PSFzf)
{
  Import-Module PSFzf

  # Ctrl + R → fzf-powered reverse history search
  Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'

  # Ctrl + T → fzf-powered file/provider picker
  Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t'
}

# ============================================================
# Terminal-Icons Module Bootstrap
# ============================================================
# Install Terminal-Icons if it is not already available
# Provides nice icons in the terminal for files and folders
if (-not (Get-Module -ListAvailable Terminal-Icons))
{
  Install-Module -Name Terminal-Icons -Repository PSGallery -Scope CurrentUser -Force -ErrorAction SilentlyContinue
}

# Import Terminal-Icons if available
if (Get-Module -ListAvailable Terminal-Icons)
{
  Import-Module -Name Terminal-Icons
}
