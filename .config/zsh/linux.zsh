# wsl.zsh - Configuration file for WSL (Windows Subsystem for Linux) ZSH environment

# Installation:
# Copy this file to your home directory:
#   cp wsl.zsh ~/.wsl.zsh
# Or create a new file and paste the contents:
#   vim ~/.wsl.zsh

# Usage:
# Load this script in your `~/.zshrc` file by adding the following line:
# echo -n "\nsource ~/.wsl.zsh" >> ~/.zshrc

# Initialize Homebrew environment
# Load Homebrew's shell environment variables
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Configure Oh My Posh prompt
# Initialize Oh My Posh with the specified configuration file
eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/zen.omp.toml)"

# Initialize Zinit plugin manager
# Load Zinit and create the completions directory if it doesn't exist
source /home/linuxbrew/.linuxbrew/opt/zinit/zinit.zsh
[[ ! -e $ZSH_CACHE_DIR/completions ]] && mkdir -p $ZSH_CACHE_DIR/completions

# Command-line fuzzy finder written in Go
source <(fzf --zsh)

# Load ZSH plugins
# Load plugins for history substring search, syntax highlighting, autosuggestions, and completions
zinit light zsh-users/zsh-history-substring-search
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# Configure ZSH-HISTORY-SUBSTRING-SEARCH plugin
# Bind keys for history substring search
bindkey '\eOA' history-substring-search-up
bindkey '\eOB' history-substring-search-down

# Configure ZSH-HISTORY-SUBSTRING-SEARCH options
# Ensure unique history entries and disable highlighting for found/not found entries
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=0
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=0

# Configure ZSH-AUTOSUGGESTIONS plugin
# Set autosuggestions highlight style
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=242"

# Configure ZSH syntax highlighting
# Define highlighters and styles for syntax highlighting
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(
  main
  brackets
  pattern
)
export ZSH_HIGHLIGHT_STYLES['unknown-token']=fg=red
export ZSH_HIGHLIGHT_STYLES['suffix-alias']=fg=green,underline
export ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
export ZSH_HIGHLIGHT_STYLES[arg0]=fg=green
