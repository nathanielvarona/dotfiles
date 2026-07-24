@echo off
set "old=%~1"
set "new=%~2"
set "old=%old:\=/%"
set "new=%new:\=/%"

git --no-pager diff --no-index --no-ext-diff "%old%" "%new%" ^
  | delta --paging=never --line-numbers
