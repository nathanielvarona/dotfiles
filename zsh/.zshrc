# Load Default Formats
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LSCOLORS="ExGxFxDxCxDxDxhbhdacEc"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-\%(:-%n).zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-\%(:-%n).zsh"
fi

# Homebrew Intialization
if [[ -f "/usr/local/bin/brew" ]]; then
  # If you're using macOS, you'll want this enabled
  eval "$(/usr/local/bin/brew shellenv)"
fi
export HOMEBREW_EDITOR="code"

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
# Download Zinit, if it's not there yet
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
# Source/Load zinit
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

# Add in snippets
zinit snippet OMZP::aws
zinit snippet OMZP::git
zinit snippet OMZP::kubectl

# OMZ Shorthand Syntax
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

# User Binaries Path
export PATH="$PATH:$HOME/.local/bin"

# GNU Bins
export PATH="/usr/local/opt/inetutils/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"

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

# Object-file caching compiler wrapper
export PATH="/usr/local/opt/ccache/libexec:$PATH"

# Alias (`ls` with colors)
LS_COLORS="${LSCOLORS}"
alias ls="ls --color"

# Alias (others)
alias zsh_history="fc -il 1"
alias meld="/Applications/Meld.app/Contents/MacOS/Meld"

# Node Version Manager
source <(fnm env)

# Ruby Version Manager
eval "$(rbenv init - zsh)"

# Python: Anacoda Initialization
eval "$(/usr/local/anaconda3/bin/conda shell.zsh hook)"

# Python Version Manager
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
if which pyenv-virtualenv-init >/dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Go Version Manager
eval "$(goenv init -)"

# Perl Initialization
eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"

# Directory Enviornment Varaibles `reads .envrc or .env`
eval "$(direnv hook zsh)"

# ASDF Tools Version Manager
export ASDF_DIR='/usr/local/opt/asdf/libexec'
. /usr/local/opt/asdf/libexec/asdf.sh

# Docker Client Version Manager
[ -f /usr/local/opt/dvm/dvm.sh ] && . /usr/local/opt/dvm/dvm.sh

# Kubernetes Plugin Manager
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# iTerm2 Shell Integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# added by travis gem
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

# Define the highlight command
export HIGHLIGHT_CMD=($(which highlight) --out-format xterm256 --line-numbers --force --style moria)
# Use "highlight" in place of "cat"
cath() {
  ${HIGHLIGHT_CMD[@]} "$@"
}

# Use "less" in place of "more"
# Set less default options as environment variable
export LESS="--raw-control-chars --long-prompt --line-numbers --hilite-search --ignore-case --status-column --underline-special"
# Pipe highlight to less
export LESSOPEN="| ${HIGHLIGHT_CMD[@]} %s"

# CLI Environment Variable Secrets (such as API Keys, Secrets, Tokens)
if [[ -e ~/.secrets ]]; then
  source ~/.secrets
fi

# Define the directory to search (change as needed)
source_dir=~/.scripts/source/
# Loop through all files ending with *.source.sh recursively
for source_file in $(find "$source_dir" -type f -name "*.source.sh" -print); do
  source "$source_file"
done
export PATH="$PATH:$HOME/.scripts/bin"

# fabric is an open-source framework for augmenting humans using AI.
if [ -f "$HOME/.config/fabric/fabric-bootstrap.inc" ]; then
  . "$HOME/.config/fabric/fabric-bootstrap.inc"
fi

# Zsh Custom Completion
if [[ -e "$HOME/.zsh_custom_completions" ]]; then
  FPATH="$HOME/.zsh_custom_completions:${FPATH}"
fi

# Additional completion definitions for zsh (Mostly Homebrew Installed Packages)
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Reload Completion
autoload -U +X compinit
compinit

# Pritunl Client Completion
source <(pritunl-client completion zsh)
