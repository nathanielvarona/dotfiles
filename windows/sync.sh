#!/bin/bash

# Copy PowerShell 5 Config
cp -rfv ./WindowsPowerShell "${HOME}"/Documents/

# Copy PowerShell 7 Config
cp -rfv ./WindowsPowerShell/ ./PowerShell/
cp -rfv ./PowerShell "${HOME}"/Documents/

# Copy Oh-My-Posh Configuation
cp -rfv ../.config/ohmyposh/ ./OhMyPosh/
cp -rfv ./OhMyPosh "${HOME}"/Documents/

# Cleanup
rm -Rf ./OhMyPosh
rm -Rf ./PowerShell
