@echo off
setlocal

set "old=%~1"
set "new=%~2"

if not exist "%old%" set "old=/dev/null"
if not exist "%new%" set "new=/dev/null"

git --no-pager diff --no-index --no-ext-diff "%old%" "%new%" ^
  | delta --paging=never --line-numbers
