#!/bin/bash

rsync -aP ../.config/ohmyposh/ ./OhMyPosh/
rsync -aP -v ./WindowsPowerShell "${HOME}"/Documents/
rsync -aP -v ./OhMyPosh "${HOME}"/Documents/
rm -Rf ./OhMyPosh
