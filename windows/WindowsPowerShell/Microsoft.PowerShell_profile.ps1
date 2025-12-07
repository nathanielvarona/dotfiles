# PowerShell 5.1 Compatibility

# Define the required version of the PSReadLine module
$requiredPSReadLineVersion = [Version]'2.3.6'

# Check if the required version of PSReadLine is installed
$psReadLineVersions = (Get-Module -Name PSReadLine -ListAvailable).Version
if (-not ($psReadLineVersions | Where-Object { $_ -ge $requiredPSReadLineVersion }))
{
  # Install the required version of PSReadLine if it's not already installed
  Write-Host "PSReadLine module outdated or missing. Installing the available latest version..."
  Install-Module -Name PSReadLine -AllowClobber -Force
  Write-Host "PSReadLine module installed."

  # Prompt the user to restart the PowerShell session
  Write-Host ""
  Write-Warning "Please exit this PowerShell session and reopen a new one to apply changes."
  Write-Host ""

  # Exit the current PowerShell session
  exit 0
}

# Import the PSReadLine module
Import-Module PSReadLine

# Configure Oh My Posh prompt
$configPath = Join-Path -Path $PSScriptRoot -ChildPath "../OhMyPosh/zen.omp.toml"
oh-my-posh init powershell --config $configPath | Invoke-Expression

# Configure PSReadLine options
# Enable command suggestion
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# Enable history search with Up/Down arrows
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

