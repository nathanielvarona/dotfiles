# Use Default Locale Settings
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Personal Environment Variables (such as Vendor Keys/Credentials and/or API Secrets/Tokens)
if [[ -e ~/.secrets ]]; then
  source ~/.secrets
fi

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

# Other Plugins
zinit load agkozak/zsh-z # jump around

# Command-line fuzzy finder written in Go
source <(fzf --zsh)
source <(zoxide init --cmd cd zsh)

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
export ZSH_HIGHLIGHT_STYLES[suffix\-alias]=fg=green,underline
export ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
export ZSH_HIGHLIGHT_STYLES[arg0]=fg=green

# Object-file caching compiler wrapper
export PATH="/usr/local/opt/ccache/libexec:$PATH"

# GNU Bins
# export PATH="/usr/local/opt/inetutils/libexec/gnubin:$PATH"
# export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
# export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
# export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"

###
# If other project sources require these libraries as dependencies for builds.
###

# Readline
# export LDFLAGS="-L/usr/local/opt/readline/lib"
# export CPPFLAGS="-I/usr/local/opt/readline/include"

# OpenSSL
# PATH="/usr/local/opt/openssl/bin:$PATH"
# export LDFLAGS="-L/usr/local/opt/openssl/lib"
# export CPPFLAGS="-I/usr/local/opt/openssl/include"

# Zlib
# export LDFLAGS="-L/usr/local/opt/zlib/lib"
# export CPPFLAGS="-I/usr/local/opt/zlib/include"
# # For pkg-config to find zlib
# export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"

## LLVM
# export PATH="/usr/local/opt/llvm/bin:$PATH"
# export LDFLAGS="-L/usr/local/opt/llvm/lib"
# export CPPFLAGS="-I/usr/local/opt/llvm/include"

# Alias (`ls` with colors)
# export LSCOLORS="ExGxFxDxCxDxDxhbhdacEc"
# alias ls="ls --color"

# LSD (LSDeluxe)
alias ls='lsd'

# Alias (others)
alias zsh_history="fc -il 1"
alias meld="/Applications/Meld.app/Contents/MacOS/Meld"

# ASDF Tools Version Manager
export ASDF_DIR='/usr/local/opt/asdf/libexec'
. /usr/local/opt/asdf/libexec/asdf.sh

# Node Version Manager
source <(fnm env)

# Ruby Version Manager
eval "$(rbenv init - zsh)"

# Anaconda Initialization (Python)
export CONDA_AUTO_ACTIVATE_BASE=false
eval "$(/usr/local/anaconda3/bin/conda shell.zsh hook)"

# Python Version Manager
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
if which pyenv-virtualenv-init >/dev/null; then
  eval "$(pyenv virtualenv-init -)"
fi

# Perl Initialization
# PERL_MM_OPT="INSTALL_BASE=$HOME/.perl5" cpan local::lib
eval "$(perl -I$HOME/.perl5/lib/perl5 -Mlocal::lib=$HOME/.perl5)"

# Go Binary Path
export PATH="$HOME/go/bin:$PATH"

# User Binaries Path
export PATH="$HOME/.local/bin:$PATH"

# Directory Enviornment Varaibles `reads .envrc or .env`
eval "$(direnv hook zsh)"

# Docker Client Version Manager
[ -f /usr/local/opt/dvm/dvm.sh ] && . /usr/local/opt/dvm/dvm.sh

# Kubernetes Plugin Manager
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

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

# Poetry Apps (Python Packages) Completion
if ! [[ -e "$HOME/.zfunc/_poetry" ]]; then
  poetry completions zsh > $HOME/.zfunc/_poetry
fi

# Ollama CLI Completion
if ! [[ -e "$HOME/.zfunc/_ollama.zsh" ]]; then
  curl -sSL -o $HOME/.zfunc/_ollama.zsh \
    https://gist.githubusercontent.com/nathanielvarona/72d827ae3b90c71a655e8a7b33154e8a/raw/5a6a44efc6a07b6f937dbc596d9d7385b297dda8/_ollama.zsh
fi

# Completion for Apps called from the Completion Function
if [[ -e "$HOME/.zfunc" ]]; then
  FPATH="$HOME/.zfunc:${FPATH}"
fi

# Additional completion definitions for zsh (Mostly Homebrew Installed Packages)
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Autoload Completion
autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit

# Pritunl Client Completion
source <(pritunl-client completion zsh)

# ASDF Plugins/Apps Completions
# Note: The asdf plugin must be either installed and added to your $PATH or accessible through the ASDF Shim.
source <(minikube completion zsh)
source <(kubectl completion zsh)
source <(helm completion zsh)
source <(kind completion zsh)
source <(argocd completion zsh)
source <(kustomize completion zsh)
source <(tilt completion zsh)
source <(eksctl completion zsh)
source <(kompose completion zsh)
source <(helmfile completion zsh)
source <(ct completion zsh) # helm-ct
complete -o nospace -C terraform terraform
complete -o nospace -C packer packer
complete -o nospace -C aws_completer aws

# Ngrok Completion
if command -v ngrok &>/dev/null; then
  eval "$(ngrok completion)"
fi
