#!/bin/bash

set -x

# Synchronize configuration files to the user's home directory

# Copy PowerShell 5.1 configuration files
# Copy the WindowsPowerShell directory to the user's Documents directory
cp -rf ../../.config/powershell/ "${HOME}"/Documents/WindowsPowerShell

# Copy PowerShell 7.5 configuration files
# First, copy the WindowsPowerShell directory to the local PowerShell directory
# Then, copy the PowerShell directory to the user's Documents directory
cp -rf ../../.config/powershell/ "${HOME}"/Documents/PowerShell

# Copy Oh My Posh configuration files
# Copy the Oh My Posh configuration directory to the local OhMyPosh directory
# Then, copy the OhMyPosh directory to the user's Documents directory
cp -rf ../../.config/ohmyposh/ "${HOME}"/Documents/ohmyposh

# Copy Windows Subsystem for Linux configuration files
# Copy the WindowsSubsystemforLinux directory to the user's Documents directory
DEST_DIR="${HOME}/Documents/WindowsSubsystemforLinux/"
if [ ! -d "$DEST_DIR" ]; then
  mkdir -p "$DEST_DIR"
fi
cp -rf ../../.config/zsh/linux.zsh "$DEST_DIR"/wsl.zsh

# Generate Vim Configuration
cat ../../.config/vim/options.vim \
  ../../.config/vim/keybinds.vim \
  ../../.config/vim/plugins.vim \
  > "$DEST_DIR"/wsl.vimrc
