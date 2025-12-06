$configPath = Join-Path -Path $PSScriptRoot -ChildPath "../OhMyPosh/zen.omp.toml"
oh-my-posh init powershell --config $configPath | Invoke-Expression


# Enable Command Suggestion
# Equivalent to `zsh-users/zsh-autosuggestions`

# Powershell 5.1 Compatibility
if (-not (Get-Module -Name PSReadLine -ListAvailable))
{
  Write-Host "PSReadLine module not found. Installing..."
  Install-Module -Name PSReadLine -AllowClobber -Force
  Write-Host "PSReadLine module installed."
} else
{
  # Write-Host "PSReadLine module is already installed."
}

Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -HistorySearchCursorMovesToEnd


# Enable history search with Up/Down arrows
# Equivalent to `zsh-users/zsh-history-substring-search`

Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

