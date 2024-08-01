# Use Default Locale Settings
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

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
zinit light Aloxaf/fzf-tab

# A CLI interface to git that relies heavily on fzf
zinit ice as"program" pick"bin/git-fuzzy"
zinit light bigH/git-fuzzy

# OMZ Plugins
zinit snippet OMZ::plugins/git
zinit snippet OMZ::plugins/extract
zinit snippet OMZ::plugins/gnu-utils
zinit snippet OMZ::plugins/common-aliases

# Source fzf
if [ -f ~/.fzfrc ]; then
  source ~/.fzfrc
fi

# Command-line fuzzy finder written in Go
source <(fzf --zsh)

# Shell extension to navigate your filesystem faster
source <(zoxide init --cmd cd zsh)

# Jump around (same with zoxide) with fzf
zinit load agkozak/zsh-z

# Atuin Command History Database (Vanilla Setup)
# export ATUIN_NOBIND="true"
# # eval "$(atuin init zsh)"
# zinit load atuinsh/atuin

# bindkey '^r' atuin-search

# bind to the up key, which depends on terminal mode
# bindkey '^[[A' atuin-up-search
# bindkey '^[OA' atuin-up-search

# Combine Atuin and FZF
atuin-setup() {
if ! which atuin &> /dev/null; then return 1; fi
  bindkey '^E' _atuin_search_widget

  export ATUIN_NOBIND="true"
  eval "$(atuin init zsh)"
  fzf-atuin-history-widget() {
    local selected num
    setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null

    # local atuin_opts="--cmd-only --limit ${ATUIN_LIMIT:-5000}"
    local atuin_opts="--cmd-only"
    local fzf_opts=(
      --height=${FZF_TMUX_HEIGHT:-100%}
      --tac
      "-n2..,.."
      --tiebreak=index
      "--query=${LBUFFER}"
      "+m"
      '--preview=echo {}'
      "--preview-window=down:3:hidden:wrap"
      "--bind=?:toggle-preview"
      "--bind=ctrl-d:reload(atuin search $atuin_opts -c $PWD),ctrl-r:reload(atuin search $atuin_opts)"
    )

    selected=$(
      eval "atuin search ${atuin_opts}" |
        fzf "${fzf_opts[@]}"
    )
    local ret=$?
    if [ -n "$selected" ]; then
      # the += lets it insert at current pos instead of replacing
      LBUFFER+="${selected}"
    fi
    zle reset-prompt
    return $ret
  }
  zle -N fzf-atuin-history-widget
  bindkey '^R' fzf-atuin-history-widget
}
atuin-setup

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
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
export ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
export ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
export ZSH_HIGHLIGHT_STYLES[arg0]=fg=green

# GNU Bins
# NOTE: Some were internally loaded in the $PATH if without conflicts
#
# export PATH="/usr/local/opt/inetutils/libexec/gnubin:$PATH"
# export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
# export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
# export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"

###
# If other project sources require these libraries as dependencies for builds.
###

# Object-file caching compiler wrapper
export PATH="/usr/local/opt/ccache/libexec:$PATH"

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
export PATH="/usr/local/opt/sqlite/bin:$PATH"
# For compilers to find sqlite you may need to set:
export LDFLAGS="-L/usr/local/opt/sqlite/lib $LDFLAGS"
export CPPFLAGS="-I/usr/local/opt/sqlite/include $CPPFLAGS"
# For pkg-config to find sqlite you may need to set:
# export PKG_CONFIG_PATH="/usr/local/opt/sqlite/lib/pkgconfig"

# For compilers to find postgresql@16 you may need to set:
export LDFLAGS="-L/usr/local/opt/postgresql@16/lib $LDFLAGS"
export CPPFLAGS="-I/usr/local/opt/postgresql@16/include $CPPFLAGS"
# For pkg-config to find postgresql@16 you may need to set:
# export PKG_CONFIG_PATH="/usr/local/opt/postgresql@16/lib/pkgconfig"

# Zlib
# For compilers to find zlib you may need to set:
export LDFLAGS="-L/usr/local/opt/zlib/lib $LDFLAGS"
export CPPFLAGS="-I/usr/local/opt/zlib/include $CPPFLAGS"
# For pkg-config to find zlib
# export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"

# LLVM
# If you need to have llvm first in your PATH, run:
export PATH="/usr/local/opt/llvm/bin:$PATH"
# To use the bundled libc++ please add the following LDFLAGS:
# export LDFLAGS="-L/usr/local/opt/llvm/lib/c++ -Wl,-rpath,/usr/local/opt/llvm/lib/c++ $LDFLAGS"
# For compilers to find llvm you may need to set:
export LDFLAGS="-L/usr/local/opt/llvm/lib $LDFLAGS"
export CPPFLAGS="-I/usr/local/opt/llvm/include $CPPFLAGS"

# C and C++ Compilers with `ccache` an Object-file caching compiler wrapper
#
# Apple `clang` (from Xcode Developer Toolchains)
# export CC="ccache gcc"
# export CXX="ccache g++"
#
# Homebrew `clang` (from LLVM)
export CC="ccache clang"
export CXX="ccache clang++"

# ls colors
# export LSCOLORS="ExGxFxDxCxDxDxhbhdacEc"
# export LS_COLORS=${LSCOLORS}
# WARNING: Vivid is not working Properly on macOS Terminal
# export LS_COLORS="$(vivid generate zenburn)"

# Alias (`ls` with colors)
# alias ls="ls --color"

# LSD (LSDeluxe)
alias ls='lsd'

# Alias (others)
alias zsh_history="fc -il 1"
alias meld="/Applications/Meld.app/Contents/MacOS/Meld"

# LazyGit Alias
alias lg='lazygit'

# Tmux and Tmuxp Alias
alias tpl='tmuxp load'
alias tmk='tmux kill-session -t'

# ASDF Tools Version Manager
export ASDF_DIR='/usr/local/opt/asdf/libexec'
. /usr/local/opt/asdf/libexec/asdf.sh

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
# eval "$(rbenv init - zsh)"
zinit snippet OMZ::plugins/rbenv

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
# if ! [[ -e "$ZSH_CACHE_DIR/completions/_poetry" ]]; then
#   poetry completions zsh > $ZSH_CACHE_DIR/completions/_poetry
# fi
# With OhMyZsh
zinit snippet OMZ::plugins/poetry

# Perl Initialization
# PERL_MM_OPT="INSTALL_BASE=$HOME/.perl5" cpan local::lib
eval "$(perl -I$HOME/.perl5/lib/perl5 -Mlocal::lib=$HOME/.perl5)"
export PERL5LIB="/Library/Developer/CommandLineTools/usr/share/git-core/perl:$PERL5LIB"

# Go Binary Path
export PATH="$HOME/go/bin:$PATH"

# User Binaries Path
export PATH="$HOME/.local/bin:$PATH"

# Homebrew keg-only packages
# postgresql@16
export PATH="/usr/local/opt/postgresql@16/bin:$PATH"

# Directory Enviornment Varaibles `reads .envrc or .env`
# eval "$(direnv hook zsh)"
# With OhMyZsh
zinit snippet OMZ::plugins/direnv

# Docker Client Version Manager
[ -f /usr/local/opt/dvm/dvm.sh ] && . /usr/local/opt/dvm/dvm.sh

# Kubernetes Plugin Manager
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

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
if [[ -e "`asdf where kubectx`/completion" ]]; then
  FPATH="`asdf where kubectx`/completion:${FPATH}"
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
