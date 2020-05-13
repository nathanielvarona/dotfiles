export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export LSCOLORS="ExGxFxDxCxDxDxhbhdacEc"
LS_COLORS="${LSCOLORS}"

if [[ -a ~/.secrets ]]; then
    source ~/.secrets
fi

if (( ! ${fpath[(I)/usr/local/share/zsh/site-functions]} )); then
    FPATH=$FPATH:/usr/local/share/zsh/site-functions
fi

source <(antibody init)

export ZSH="$(antibody home)/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"
antibody bundle robbyrussell/oh-my-zsh
antibody bundle "
    robbyrussell/oh-my-zsh path:plugins/gnu-utils
    robbyrussell/oh-my-zsh path:plugins/common-aliases
    robbyrussell/oh-my-zsh path:plugins/asdf
    robbyrussell/oh-my-zsh path:plugins/docker
    robbyrussell/oh-my-zsh path:plugins/docker-compose
    robbyrussell/oh-my-zsh path:plugins/helm
    robbyrussell/oh-my-zsh path:plugins/kubectl
"

antibody bundle romkatv/powerlevel10k

antibody bundle zsh-users/zsh-completions
antibody bundle zsh-users/zsh-syntax-highlighting
antibody bundle zsh-users/zsh-history-substring-search
antibody bundle zsh-users/zsh-autosuggestions

# Prompt Mode
POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_DISABLE_RPROMPT=true
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=' ❱ '
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''
POWERLEVEL9K_STATUS_OK_IN_NON_VERBOSE=true
POWERLEVEL9K_STATUS_VERBOSE=false

# Prompt Figures
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs nvm rvm pyenv go_version aws kubecontext docker_machine background_jobs command_execution_time time status)

# Truncating Long Directories
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

# ZSH-HISTORY-SUBSTRING-SEARCH Plugin
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# ZSH-AUTOSUGGESTIONS Plugin
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=242"

# ZSH_HIGHLIGHT_HIGHLIGHTERS
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
ZSH_HIGHLIGHT_STYLES[arg0]=fg=green

export HOMEBREW_EDITOR=code

alias zsh_history="fc -il 1"
alias meld=/Applications/Meld.app/Contents/MacOS/Meld

PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

export LDFLAGS="-L/usr/local/opt/readline/lib"
export CPPFLAGS="-I/usr/local/opt/readline/include"

export PATH="/usr/local/opt/openssl/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"

export LDFLAGS="-L/usr/local/opt/zlib/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include"
export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"

# Pyenv Initialization
export PYENV_ROOT=$HOME/.pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

[ -f /usr/local/opt/dvm/dvm.sh ] && . /usr/local/opt/dvm/dvm.sh

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

nvm use --delete-prefix default --silent

meld_clean () {
    rm -rf ~/.local/share/meld
    rm -rf ~/Library/Preferences/org.gnome.meld.plist
    rm -rf ~/Library/Saved\ Application\ State/org.gnome.meld.savedState
}

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


# added by travis gem
[ -f /Users/nathanielvarona/.travis/travis.sh ] && source /Users/nathanielvarona/.travis/travis.sh

export PATH="$HOME/go/bin:$PATH"

# export GOENV_ROOT="$HOME/.goenv"
# export PATH="$GOENV_ROOT/bin:$PATH"
# eval "$(goenv init -)"
# export PATH="$GOROOT/bin:$PATH"
# export PATH="$PATH:$GOPATH/bin"

export PATH="/usr/local/sbin:$PATH"

# Pipe Highlight to less
export LESSOPEN="| $(which highlight) %s --out-format xterm256 -l --force -s solarized-light --no-trailing-nl"
export LESS=" -R"
alias less='less -m -N -g -i -J --line-numbers --underline-special'
alias more='less'

# Use "highlight" in place of "cat"
alias cath="highlight --out-format xterm256 --force -s moria --no-trailing-nl"
