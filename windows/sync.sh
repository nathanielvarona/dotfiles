#!/bin/bash

# Synchronize configuration files to the user's home directory

# Copy PowerShell 5.1 configuration files
# Copy the WindowsPowerShell directory to the user's Documents directory
cp -rfv ./WindowsPowerShell "${HOME}"/Documents/

# Copy PowerShell 7.5 configuration files
# First, copy the WindowsPowerShell directory to the local PowerShell directory
# Then, copy the PowerShell directory to the user's Documents directory
cp -rfv ./WindowsPowerShell/ ./PowerShell/
cp -rfv ./PowerShell "${HOME}"/Documents/

# Copy Oh My Posh configuration files
# Copy the Oh My Posh configuration directory to the local OhMyPosh directory
# Then, copy the OhMyPosh directory to the user's Documents directory
cp -rfv ../.config/ohmyposh/ ./OhMyPosh/
cp -rfv ./OhMyPosh "${HOME}"/Documents/

# Copy Windows Subsystem for Linux configuration files
# Copy the WindowsSubsystemforLinux directory to the user's Documents directory
cp -rfv ./WindowsSubsystemforLinux "${HOME}"/Documents/

# Clean up temporary directories
# Remove the local OhMyPosh and PowerShell directories
rm -Rf ./OhMyPosh
rm -Rf ./PowerShell
