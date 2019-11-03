export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

if [[ -a ~/.secrets ]]; then
    source ~/.secrets
fi

fpath=(/usr/local/share/zsh-completions $fpath)

source <(antibody init)

export ZSH="$(antibody home)/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"
antibody bundle robbyrussell/oh-my-zsh
antibody bundle "
    robbyrussell/oh-my-zsh path:plugins/gnu-utils
    robbyrussell/oh-my-zsh path:plugins/common-aliases
    robbyrussell/oh-my-zsh path:plugins/asdf
    robbyrussell/oh-my-zsh path:plugins/git
    robbyrussell/oh-my-zsh path:plugins/docker
    robbyrussell/oh-my-zsh path:plugins/docker-compose
    robbyrussell/oh-my-zsh path:plugins/helm
    robbyrussell/oh-my-zsh path:plugins/kubectl
    robbyrussell/oh-my-zsh path:plugins/aws
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
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs nvm rvm pyenv aws kubecontext docker_machine background_jobs command_execution_time time status)

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

PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

export LDFLAGS="-L/usr/local/opt/readline/lib"
export CPPFLAGS="-I/usr/local/opt/readline/include"
