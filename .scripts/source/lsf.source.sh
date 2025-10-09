#!/bin/zsh

# Get the raw full path of a file

lsf() {
  ls --icon never --color never $(pwd)/$1
}
