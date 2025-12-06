$configPath = Join-Path -Path $PSScriptRoot -ChildPath "../OhMyPosh/zen.omp.toml"
oh-my-posh init powershell --config $configPath | Invoke-Expression

