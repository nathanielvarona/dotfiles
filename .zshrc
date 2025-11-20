# Use Default Locale Settings
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# XDG Base Directory Specification
# Stores application configuration files.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
# Stores temporary cache data.
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
# Stores application data.
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
# Stores persistent application state data.
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Personal Environment Variables
# Such as Vendor Keys/Credentials and/or API Secrets/Tokens
if [[ -e ~/.secrets ]]; then
  source ~/.secrets
fi

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Forcing Apps to use XDG Spec
export VSCODE_APPDATA="${XDG_CONFIG_HOME}"  # NOTE: Also available in `EnvPane`
export GNUPGHOME="${XDG_CONFIG_HOME}/gnupg" # TODO: Evaluate first the Apps I commonly use the requires GnuPG

# Homebrew Initialization
eval "$(/usr/local/bin/brew shellenv)"

# Zinit Setup and Initialization
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

[[ ! -e $ZSH_CACHE_DIR/completions ]] && mkdir -p $ZSH_CACHE_DIR/completions

# Add in Powerlevel10k
zinit ice depth=1
zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Add in zsh plugins
zinit light zsh-users/zsh-history-substring-search
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# OMZ Plugins
zinit snippet OMZ::plugins/git
zinit snippet OMZ::plugins/extract
zinit snippet OMZ::plugins/gnu-utils
zinit snippet OMZ::plugins/common-aliases

# Command-line fuzzy finder written in Go
source <(fzf --zsh)

# Atuin Command History Database (Vanilla Setup)
export ATUIN_NOBIND="true"
eval "$(atuin init zsh)"
# zinit load atuinsh/atuin

bindkey '^Y' atuin-search

# bind to the up key, which depends on terminal mode
# bindkey '^[[A' atuin-up-search
# bindkey '^[OA' atuin-up-search

# fzf is a general-purpose command-line fuzzy finder.
# https://github.com/junegunn/fzf
function init_fzfrc() {
  [[ ! -f ~/.fzfrc.zsh ]] || source ~/.fzfrc.zsh
}

# Replace zsh's default completion selection menu with fzf!
# https://github.com/Aloxaf/fzf-tab
zinit light Aloxaf/fzf-tab

# A CLI interface to git that relies heavily on fzf
# https://github.com/bigH/git-fuzzy
# Usage: "[git-fuzzy | git fuzzy] <GIT_SUBCOMMAND>"
zinit ice as"program" pick"bin/git-fuzzy"
zinit light bigH/git-fuzzy

# Utility tool for using git interactively.
# https://github.com/wfxr/forgit
# Usage: "[git-forgit | git forgit] <GIT_SUBCOMMAND>"
zinit ice as"program" pick"bin/git-forgit"
zinit load wfxr/forgit

# Shell extension to navigate your filesystem faster
source <(zoxide init --cmd cd zsh)

# Jump around (same with zoxide) with fzf
zinit load agkozak/zsh-z

eval $(thefuck --alias wtf)

# History
export HISTFILE=~/.zsh_history
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
export HISTTIMEFORMAT="[%F %T] "
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS

# ZSH-HISTORY-SUBSTRING-SEARCH Plugin
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=0
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=0

# ZSH-AUTOSUGGESTIONS Plugin
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=242"

# ZSH_HIGHLIGHT_HIGHLIGHTERS
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(
  main
  brackets
  pattern
  # cursor
)
export ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
export ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
export ZSH_HIGHLIGHT_STYLES[arg0]=fg=green

# Zsh Vi Mode
# zinit ice depth=1
# zinit light jeffreytse/zsh-vi-mode
# Fix zsh-history-substring-search behaviour
# zvm_after_init_commands+=(
#   init_fzfrc
#   "bindkey '^[[A' history-substring-search-up"
#   "bindkey '^[[B' history-substring-search-down"
# )
# export ZVM_VI_EDITOR=vim
# export ZVM_SYSTEM_CLIPBOARD_ENABLED=true

# GNU Bins
# NOTE: Some were internally loaded in the $PATH if without conflicts
#
# export PATH="/usr/local/opt/inetutils/libexec/gnubin:$PATH"
# export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
# export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
# export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"

###
# If other project sources require these libraries as dependencies for builds.
# ---------------------------------------------------------
#

# OpenSSL
# export PATH="/usr/local/opt/openssl/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl/lib $LDFLAGS"
export CPPFLAGS="-I/usr/local/opt/openssl/include $CPPFLAGS"

# Readline
# For compilers to find readline you may need to set:
export LDFLAGS="-L/usr/local/opt/readline/lib"
export CPPFLAGS="-I/usr/local/opt/readline/include"
# For pkg-config to find readline you may need to set:
# export PKG_CONFIG_PATH="/usr/local/opt/readline/lib/pkgconfig"

# SQLite
# If you need to have sqlite first in your PATH, run:
# export PATH="/usr/local/opt/sqlite/bin:$PATH"
# For compilers to find sqlite you may need to set:
# export LDFLAGS="-L/usr/local/opt/sqlite/lib $LDFLAGS"
# export CPPFLAGS="-I/usr/local/opt/sqlite/include $CPPFLAGS"
# For pkg-config to find sqlite you may need to set:
# export PKG_CONFIG_PATH="/usr/local/opt/sqlite/lib/pkgconfig"

# For compilers to find postgresql@16 you may need to set:
export LDFLAGS="-L/usr/local/opt/postgresql@18/lib $LDFLAGS"
export CPPFLAGS="-I/usr/local/opt/postgresql@18/include $CPPFLAGS"
# For pkg-config to find postgresql@16 you may need to set:
# export PKG_CONFIG_PATH="/usr/local/opt/postgresql@16/lib/pkgconfig"

# Zlib
# For compilers to find zlib you may need to set:
# export LDFLAGS="-L/usr/local/opt/zlib/lib $LDFLAGS"
# export CPPFLAGS="-I/usr/local/opt/zlib/include $CPPFLAGS"
# For pkg-config to find zlib
# export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"

# Bzip2
# If you need to have bzip2 first in your PATH, run:
# export PATH="/usr/local/opt/bzip2/bin:$PATH"
# For compilers to find bzip2 you may need to set:
# export LDFLAGS="-L/usr/local/opt/bzip2/lib $LDFLAGS"
# export CPPFLAGS="-I/usr/local/opt/bzip2/include $PPFLAGS"

# OpenBlas
# For compilers to find openblas you may need to set:
# export LDFLAGS="-L/usr/local/opt/openblas/lib $LDFLAGS"
# export CPPFLAGS="-I/usr/local/opt/openblas/include $CPPFLAGS"
# For pkg-config to find openblas you may need to set:
# export PKG_CONFIG_PATH="/usr/local/opt/openblas/lib/pkgconfig"

# ncurses
# If you need to have ncurses first in your PATH, run:
# export PATH="/usr/local/opt/ncurses/bin:$PATH"
# For compilers to find ncurses you may need to set:
# export LDFLAGS="-L/usr/local/opt/ncurses/lib $LFLAGS"
# export CPPFLAGS="-I/usr/local/opt/ncurses/include $CPPFLAGS"
# For pkgconf to find ncurses you may need to set:
# export PKG_CONFIG_PATH="/usr/local/opt/ncurses/lib/pkgconfig"

# Tcl programming language and Tk graphical user interface toolkit (Version 8)
# If you need to have tcl-tk@8 first in your PATH, run:
# export PATH="/usr/local/opt/tcl-tk@8/bin:$PATH"
# For compilers to find tcl-tk@8 you may need to et:
# export LDFLAGS="-L/usr/local/opt/tcl-tk@8/lib $LDFLAGS"
# export CPPFLAGS="-I/usr/local/opt/tcl-tk@8/include $CPPFLAGS"
# For pkgconf to find tcl-tk@8 you may need to set:
# export PKG_CONFIG_PATH="/usr/local/opt/tcl-tk@8/lib/pkgconfig"

# srtp - Implementation of the Secure Real-time Transport Protocol
export CFLAGS="-I/usr/local/opt/srtp/include $CFLAGS"
export LDFLAGS="-L/usr/local/opt/srtp/lib $LDFLAGS"

# Linear Algebra PACKage
# For compilers to find lapack you may need to set:
# export LDFLAGS="-L/usr/local/opt/lapack/lib"
# export CPPFLAGS="-I/usr/local/opt/lapack/include"
# For pkgconf to find lapack you may need to set:
# export PKG_CONFIG_PATH="/usr/local/opt/lapack/lib/pkgconfig"
# For cmake to find lapack you may need to set:
# export CMAKE_PREFIX_PATH="/usr/local/opt/lapack"

# Comment LLVM settings to only use Apple `clang` (from Xcode Developer Toolchains)
# Homebrew `clang` (from LLVM)
# If you need to have llvm first in your PATH, run:
# export PATH="/usr/local/opt/llvm/bin:$PATH"
# To use the bundled libc++ please add the following LDFLAGS:
# export LDFLAGS="-L/usr/local/opt/llvm/lib/c++ -Wl,-rpath,/usr/local/opt/llvm/lib/c++ $LDFLAGS"
# For compilers to find llvm you may need to set:
# export LDFLAGS="-L/usr/local/opt/llvm/lib $LDFLAGS"
# export CPPFLAGS="-I/usr/local/opt/llvm/include $CPPFLAGS"
# For cmake to find llvm you may need to set:
# export CMAKE_PREFIX_PATH="/usr/local/opt/llvm"

# ccache - Object-file caching compiler wrapper
# export PATH="/usr/local/opt/ccache/libexec:$PATH"

# C and C++ Compilers with `ccache` an Object-file caching compiler wrapper
# export CC="ccache clang"
# export CXX="ccache clang++"

# Headers without ccache
export CC="clang"
export CXX="clang++"

# Fallback Library
# export DYLD_FALLBACK_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_FALLBACK_LIBRARY_PATH"

#
# ---------------------------------------------------------
###

# ls colors
# export LSCOLORS="ExGxFxDxCxDxDxhbhdacEc"
# export LS_COLORS=${LSCOLORS}
# WARNING: Vivid is not working Properly on macOS Terminal
export LS_COLORS="$(vivid generate zenburn)"

# Alias (`ls` with colors)
# alias ls="ls --color"

# LSD (LSDeluxe)
alias ls='lsd'

# TODO: Evaluate the Functionality (`lsd` has the features I need for now)
# INFO: Winning in Terms of Speed using `hyperfine "eza -la --icons" "lsd -la"`
# eza - A modern replacement for ls.
# alias ls='eza -la --icons'

# Alias (others)
alias zsh_history="fc -il 1"
alias meld="/Applications/Meld.app/Contents/MacOS/Meld"

# LazyGit Alias
alias lg='lazygit'

# Tmux and Tmuxp Alias
alias tpl='tmuxp load'
alias tmk='tmux kill-session -t'

# ASDF Tools Version Manager
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# ASDF Plugins/Apps
# With OhMyZsh
zinit snippet OMZ::plugins/argocd
zinit snippet OMZ::plugins/helm
zinit snippet OMZ::plugins/kind
zinit snippet OMZ::plugins/kubectl
zinit snippet OMZ::plugins/kubectx
zinit snippet OMZ::plugins/minikube

# Node Version Manager
source <(fnm env)

# Ruby Version Manager
eval "$(rbenv init - zsh)"
# zinit snippet OMZ::plugins/rbenv

# Anaconda Initialization (Python)
export CONDA_AUTO_ACTIVATE_BASE=false
eval "$(/usr/local/anaconda3/bin/conda shell.zsh hook)"

# Python Version Manager
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
# if which pyenv-virtualenv-init >/dev/null; then
#   eval "$(pyenv virtualenv-init -)"
# fi
zinit snippet OMZ::plugins/pyenv

# Poetry Apps (Python Packages)
export POETRY_CACHE_DIR="$XDG_CACHE_HOME/pypoetry"
export POETRY_VIRTUALENVS_PREFER_ACTIVE_PYTHON="true"
export POETRY_VIRTUALENVS_OPTIONS_ALWAYS_COPY="true"

# if ! [[ -e "$ZSH_CACHE_DIR/completions/_poetry" ]]; then
#   poetry completions zsh > $ZSH_CACHE_DIR/completions/_poetry
# fi
# With OhMyZsh
zinit snippet OMZ::plugins/poetry

# Perl Initialization
[[ ! -d $HOME/.perl5 ]] && PERL_MM_OPT="INSTALL_BASE=$HOME/.perl5" cpan local::lib
eval "$(perl -I$HOME/.perl5/lib/perl5 -Mlocal::lib=$HOME/.perl5)"
export PERL5LIB="/Library/Developer/CommandLineTools/usr/share/git-core/perl:$PERL5LIB"

# Go Binary Path
export PATH="$HOME/go/bin:$PATH"

# Lua / LuaRocks Binary Path
export PATH="$HOME/.luarocks/bin:$PATH"

# Rust / Cargo Binary Path
export PATH="$HOME/.cargo/bin:$PATH"

# User Binaries Path
export PATH="$HOME/.local/bin:$PATH"

# Homebrew keg-only packages
# postgresql@18
export PATH="/usr/local/opt/postgresql@18/bin:$PATH"

# Directory Enviornment Varaibles `reads .envrc or .env`
# eval "$(direnv hook zsh)"
# With OhMyZsh
zinit snippet OMZ::plugins/direnv

# Docker Client Version Manager
[ -f /usr/local/opt/dvm/dvm.sh ] && . /usr/local/opt/dvm/dvm.sh

# Kubernetes Plugin Manager
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Mason (Neovim/LazyVim) Binaries
export PATH="${XDG_DATA_HOME:-$HOME}/lazyvim/mason/bin:$PATH"

# Ollama CLI Completion
# NOTE: This is Temporary until Ollam implement a Completion Generator Feature from the CLI
if ! [[ -e "$ZSH_CACHE_DIR/completions/_ollama" ]]; then
  curl -sSL -o $ZSH_CACHE_DIR/completions/_ollama \
    https://gist.githubusercontent.com/nathanielvarona/72d827ae3b90c71a655e8a7b33154e8a/raw/5a6a44efc6a07b6f937dbc596d9d7385b297dda8/_ollama.zsh
fi

# API documentation browser and code snippet manager
zinit snippet OMZ::plugins/dash

# Define the directory to search (change as needed)
source_dir=~/.scripts/autoload
# Loop through all files ending with *.source.sh recursively
for source_file in $(find "$source_dir" -type l -name "*.source.sh" -print); do
  source "$source_file"
done
export PATH="$PATH:$HOME/.scripts/bin"

# fabric is an open-source framework for augmenting humans using AI.
if [ -f "$HOME/.config/fabric/fabric-bootstrap.inc" ]; then
  . "$HOME/.config/fabric/fabric-bootstrap.inc"
fi

# Git Scripts
export PATH="$PATH:$HOME/Projects/contribute/git-scripts"

# Completion for Zinit OMZ Plugins
if [[ -e "$ZSH_CACHE_DIR/completions" ]]; then
  FPATH="$ZSH_CACHE_DIR/completions:${FPATH}"
fi

# Additional completion definitions for Zsh (Mostly Homebrew Installed Packages)
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# ASDF Plugin without Completion Generator, with only pre-generated completion file
#
# For `kubectx` completion, this directory also includes `kubens` completion
if [[ -e "$(asdf where kubectx)/completion" ]]; then
  FPATH="$(asdf where kubectx)/completion:${FPATH}"
fi

# Autoload Completion
autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit

# Pritunl Client Completion
source <(pritunl-client completion zsh)

# ASDF Plugins/Apps Completions
# IMPORTANT: The asdf plugin must be either installed and added to your $PATH or accessible through the ASDF Shim.
# NOTE: Some where commented as its already loaded from the Zinit OMZ Plugin
# source <(argocd completion zsh)
source <(eksctl completion zsh)
# source <(helm completion zsh)
# source <(kind completion zsh)
source <(kompose completion zsh)
# source <(kubectl completion zsh)
source <(kustomize completion zsh)
# source <(minikube completion zsh)
source <(tilt completion zsh)
source <(helmfile completion zsh)
source <(ct completion zsh) # helm-ct
complete -o nospace -C terraform terraform
complete -o nospace -C packer packer
complete -o nospace -C aws_completer aws

# Ngrok Completion
if command -v ngrok &>/dev/null; then
  eval "$(ngrok completion)"
fi

# See `~/.config/vim/vimrc` for Cursor Escape Codes
# Fixes Terminal Cursor in a Tmux with a VI Mode Keys Enabled
if [ -n "$TMUX" ]; then
  _fix_cursor() {
    echo -ne '\e[6 q'
  }
  precmd_functions+=(_fix_cursor)
fi

# Isolate Neovim configurations using the "NVIM_APPNAME" environment variable.
# This allows you to run different Neovim distributions with their own configurations.
# For more information, see: https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME

# NOTE: `LazyVim` and `AstroNvim`: Both offer enhanced VSCode integration with the `vscode-neovim` extension.

# LazyVim: Neovim setup powered by `lazy.nvim` to make it easy to customize and extend your config.
alias lazyvim="NVIM_APPNAME=lazyvim $(brew --prefix)/bin/nvim" # Neovim with LazyVim: https://github.com/LazyVim/LazyVim
# LunarVim: An IDE layer for Neovim with sane defaults. Completely free and community driven.
alias lunarvim='lvim' # Neovim with LunarVim: https://github.com/lunarvim/lunarvim
# AstroNvim: Aesthetically pleasing and feature-rich Neovim configuration that focuses on extensibility and usability.
alias astronvim="NVIM_APPNAME=astronvim $(brew --prefix)/bin/nvim" # Neovim with AstroNvim: https://github.com/AstroNvim/AstroNvim
# NvChad: Blazing fast Neovim config providing solid defaults and a beautiful UI
alias nvchad="NVIM_APPNAME=nvchad $(brew --prefix)/bin/nvim" # Neovim with NvChad: https://github.com/NvChad/NvChad
# kickstart.nvim: NOT a Neovim distribution, but instead a starting point for your configuration. (Vanilla-like experience)
alias kickstartvim="NVIM_APPNAME=kickstartvim $(brew --prefix)/bin/nvim" # Neovim with kickstart.nvim: https://github.com/nvim-lua/kickstart.nvim

# >>>> Vagrant command completion (start)
fpath=(/opt/vagrant/embedded/gems/gems/vagrant-2.4.1/contrib/zsh $fpath)
compinit
# <<<<  Vagrant command completion (end)

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
