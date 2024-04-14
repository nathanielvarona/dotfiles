autoload -Uz compinit
compinit

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export LSCOLORS="ExGxFxDxCxDxDxhbhdacEc"
LS_COLORS="${LSCOLORS}"

if [[ -a ~/.secrets ]]; then
    source ~/.secrets
fi

# Define the directory to search (change as needed)
source_dir=~/.scripts/

# Loop through all files ending with *.source.sh recursively
for source_file in $(find "$source_dir" -type f -name "*.source.sh" -print); do
    source "$source_file"
done

if (( ! ${fpath[(I)/usr/local/share/zsh/site-functions]} )); then
    FPATH=$FPATH:/usr/local/share/zsh/site-functions
fi

# source <(antibody init)

# export ZSH="$(antibody home)/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"
# antibody bundle robbyrussell/oh-my-zsh
# antibody bundle "
#     robbyrussell/oh-my-zsh path:plugins/gnu-utils
#     robbyrussell/oh-my-zsh path:plugins/common-aliases
#     robbyrussell/oh-my-zsh path:plugins/docker
#     robbyrussell/oh-my-zsh path:plugins/docker-compose
#     robbyrussell/oh-my-zsh path:plugins/helm
#     robbyrussell/oh-my-zsh path:plugins/kubectl
# "

# antibody bundle romkatv/powerlevel10k

# export PS1="$ "
# export PYENV_VIRTUALENV_DISABLE_PROMPT=1
# unset zle_bracketed_paste

# antibody bundle zsh-users/zsh-completions
# antibody bundle zsh-users/zsh-syntax-highlighting
# antibody bundle zsh-users/zsh-history-substring-search
# antibody bundle zsh-users/zsh-autosuggestions

source /usr/local/opt/antidote/share/antidote/antidote.zsh
# source <(antidote init)
# antidote bundle < ~/.zsh_plugins.txt
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt


export HISTFILE=~/.zsh_history
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
setopt INC_APPEND_HISTORY
export HISTTIMEFORMAT="[%F %T] "
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS

# Prompt Mode
POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_DISABLE_RPROMPT=true
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=' ❱ '
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''
POWERLEVEL9K_STATUS_OK_IN_NON_VERBOSE=true
POWERLEVEL9K_STATUS_VERBOSE=false

# Prompt Figures
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir direnv vcs nvm rbenv pyenv anaconda goenv go_version asdf aws kubecontext docker_machine background_jobs command_execution_time status)

# Gemset
# POWERLEVEL9K_RVM_SHOW_GEMSET=true

# Truncating Long Directories
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
# POWERLEVEL9K_SHORTEN_DELIMITER=""
# POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

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

export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

export LDFLAGS="-L/usr/local/opt/readline/lib"
export CPPFLAGS="-I/usr/local/opt/readline/include"

export PATH="/usr/local/opt/openssl/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"

export LDFLAGS="-L/usr/local/opt/zlib/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include"
export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"

# Pyenv Initialization
# export PYENV_ROOT=$HOME/.pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# eval "$(pyenv init -)"

if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

[ -f /usr/local/opt/dvm/dvm.sh ] && . /usr/local/opt/dvm/dvm.sh

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Node Version Manager
#export NVM_DIR="$HOME/.nvm"
#[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
#[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#nvm use --delete-prefix default --silent

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# added by travis gem
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

export PATH="$HOME/go/bin:$PATH"

# export GOENV_ROOT="$HOME/.goenv"
# export PATH="$GOENV_ROOT/bin:$PATH"
# eval "$(goenv init -)"
# export PATH="$GOROOT/bin:$PATH"
# export PATH="$PATH:$GOPATH/bin"

export PATH="/usr/local/sbin:$PATH"

# Pipe Highlight to less
# export LESSOPEN="| $(which highlight) %s --out-format xterm256 -l --force -s solarized-light --no-trailing-nl"
# export LESS=" -R"
# alias less='less -m -N -g -i -J --line-numbers --underline-special'
# alias more='less'

# Use "highlight" in place of "cat"
alias cath="highlight --out-format xterm256 --force -s moria --no-trailing-nl"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="~/Projects/contribute/git-fuzzy/bin:$PATH"

# Created by `userpath` on 2021-02-03 02:02:40
export PATH="$PATH:~/.local/bin"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"

# RVM for ZSH
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# ASDF
export ASDF_DIR='/usr/local/opt/asdf/libexec'
. /usr/local/opt/asdf/libexec/asdf.sh

# DIRENV
eval "$(direnv hook zsh)"

# Fix RVM Gemset Bundle Issue
# export LD_LIBRARY_PATH=$(brew --prefix openssl)/lib
# export CPATH=$(brew --prefix openssl)/include
# export PKG_CONFIG_PATH=$(brew --prefix openssl)/lib/pkgconfig

PATH="~/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="~/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="~/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"~/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=~/perl5"; export PERL_MM_OPT;

# RBENV
eval "$(rbenv init - zsh)"


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

# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="~/Library/Caches/fnm_multishells/4007_1683517959636/bin":$PATH
export FNM_NODE_DIST_MIRROR="https://nodejs.org/dist"
export FNM_MULTISHELL_PATH="~/Library/Caches/fnm_multishells/4007_1683517959636"
export FNM_VERSION_FILE_STRATEGY="local"
export FNM_DIR="~/Library/Application Support/fnm"
export FNM_LOGLEVEL="info"
export FNM_ARCH="x64"
autoload -U add-zsh-hook
_fnm_autoload_hook () {
    if [[ -f .node-version || -f .nvmrc ]]; then
    fnm use --silent-if-unchanged
fi

}

add-zsh-hook chpwd _fnm_autoload_hook \
    && _fnm_autoload_hook

rehash

PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
PATH="/usr/local/opt/inetutils/libexec/gnubin:$PATH"

source <(podman completion zsh)
