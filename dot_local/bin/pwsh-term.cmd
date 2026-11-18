@echo off
rem Neovim cannot spawn the pwsh App Execution Alias directly (E475), so this
rem shim gives it a real file to execute. Everything after the script name is
rem forwarded untouched to PowerShell 7.
pwsh.exe %*
