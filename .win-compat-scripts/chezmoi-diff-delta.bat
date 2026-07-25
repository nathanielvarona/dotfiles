@echo off
setlocal enabledelayedexpansion

set "old=%~1"
set "new=%~2"

:: Use virtual empty file
set "black_hole=NUL"

:: Substitute missing files with the empty temporary file
if not exist "%old%" set "old=%black_hole%"
if not exist "%new%" set "new=%black_hole%"

:: Convert all backslashes to forward slashes for Git for Windows
set "old=!old:\=/!"
set "new=!new:\=/!"

:: Execute the diff safely with uniform forward slash paths
git --no-pager diff --no-index --no-ext-diff "%old%" "%new%" ^
  | delta --paging=never --line-numbers
