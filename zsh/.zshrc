LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8

LSCOLORS="ExGxFxDxCxDxDxhbhdacEc"
LS_COLORS="${LSCOLORS}"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "`which brew`" ]] then
    # If you're using macOS, you'll want this enabled
    eval "$(`which brew` shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
# Download Zinit, if it's not there yet
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

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
HISTFILE=~/.zsh_history
HISTFILESIZE=1000000000
HISTSIZE=1000000000
HISTTIMEFORMAT="[%F %T] "
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS

# Additional completion definitions for zs
if type brew &>/dev/null
then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
fi

# ZSH-HISTORY-SUBSTRING-SEARCH Plugin
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=0
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=0

# ZSH-AUTOSUGGESTIONS Plugin
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=242"

# ZSH_HIGHLIGHT_HIGHLIGHTERS
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[arg0]=fg=green

source <(fnm env)
source <(podman completion zsh)

# GNU Utils
PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
PATH="/usr/local/opt/inetutils/libexec/gnubin:$PATH"
PATH="$PATH:~/.local/bin"

PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

LDFLAGS="-L/usr/local/opt/readline/lib"
CPPFLAGS="-I/usr/local/opt/readline/include"

PATH="/usr/local/opt/openssl/bin:$PATH"
LDFLAGS="-L/usr/local/opt/openssl/lib"
CPPFLAGS="-I/usr/local/opt/openssl/include"

LDFLAGS="-L/usr/local/opt/zlib/lib"
CPPFLAGS="-I/usr/local/opt/zlib/include"
PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"

HOMEBREW_EDITOR=code

# Alias
alias zsh_history="fc -il 1"
alias meld=/Applications/Meld.app/Contents/MacOS/Meld
alias ls='ls --color'

# RBENV
eval "$(rbenv init - zsh)"

# DIRENV
eval "$(direnv hook zsh)"

# ASDF
ASDF_DIR='/usr/local/opt/asdf/libexec'
. /usr/local/opt/asdf/libexec/asdf.sh

# Pyenv Initialization
# PYENV_ROOT=$HOME/.pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# eval "$(pyenv init -)"

if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

[ -f /usr/local/opt/dvm/dvm.sh ] && . /usr/local/opt/dvm/dvm.sh

PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# added by travis gem
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

PATH="$HOME/go/bin:$PATH"

# GOENV_ROOT="$HOME/.goenv"
# PATH="$GOENV_ROOT/bin:$PATH"
# eval "$(goenv init -)"
# PATH="$GOROOT/bin:$PATH"
# PATH="$PATH:$GOPATH/bin"

PATH="/usr/local/sbin:$PATH"

# Define the highlight command
HIGHLIGHT_CMD=( $(which highlight) --out-format xterm256 --line-numbers --force --style moria )
# Use "highlight" in place of "cat"
cath() {
    ${HIGHLIGHT_CMD[@]} "$@"
}

# Use "less" in place of "more"
# Set less default options as environment variable
export LESS="--RAW-CONTROL-CHARS --long-prompt --line-numbers --hilite-search --ignore-case --status-column --underline-special"
# Pipe highlight to less
export LESSOPEN="| ${HIGHLIGHT_CMD[@]} %s"

eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"

if [[ -a ~/.secrets ]]; then
    source ~/.secrets
fi

# Define the directory to search (change as needed)
source_dir=~/.scripts/

# Loop through all files ending with *.source.sh recursively
for source_file in $(find "$source_dir" -type f -name "*.source.sh" -print); do
    source "$source_file"
done

# Generated using `/usr/local/anaconda3/bin/conda init zsh`
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/usr/local/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# fabric is an open-source framework for augmenting humans using AI.
if [ -f "$HOME/.config/fabric/fabric-bootstrap.inc" ]; then
    . "$HOME/.config/fabric/fabric-bootstrap.inc"
fi
