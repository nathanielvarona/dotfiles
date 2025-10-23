# Scheme name: GitHub Dark Default

_gen_fzf_github_dark_default_opts() {
  local color00='#0d1117' # Background
  local color01='#161b22' # Lighter Background
  local color02='#313244' # Not used, but can be for additional customization
  local color03='#45475a' # Not used, but can be for additional customization
  local color04='#8b949e' # Comment
  local color05='#c9d1d9' # Foreground
  local color06='#39c5cf' # Cyan
  local color07='#58a6ff' # Blue
  local color08='#ff7b72' # Red
  local color09='#d29922' # Orange
  local color0A='#e3b341' # Yellow
  local color0B='#3fb950' # Green
  local color0C='#39c5cf' # Cyan
  local color0D='#58a6ff' # Blue
  local color0E='#bc8cff' # Purple
  local color0F='#c9d1d9' # Not used, but can be for additional customization

  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS""\
    --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D""\
    --color=fg:$color05,header:$color0D,info:$color0A,pointer:$color0C""\
    --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"
}
_gen_fzf_github_dark_default_opts

# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd) fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export | unset) fzf --preview "eval 'echo \${}'" "$@" ;;
    ssh) fzf --preview 'dig {}' "$@" ;;
    *) fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

###
# ---------------------------------------------------------
# Redefine this function to change the options
# https://github.com/junegunn/fzf-git.sh
#
# Keybinds:
# "CTRL-G + CTRL-H" - for commit Hashes
#

source ~/Projects/contribute/fzf-git.sh/fzf-git.sh

_fzf_git_fzf() {
  fzf-tmux -p80%,60% -- \
    --layout=reverse --multi --height=50% --min-height=20 --border \
    --border-label-pos=2 \
    --color='header:italic:underline,label:blue' \
    --preview-window='right,50%,border-left' \
    --bind='ctrl-/:change-preview-window(down,50%,border-top|hidden|)' "$@"
}

fgco() {
  _fzf_git_each_ref --no-multi | xargs git checkout
}

fgswt() {
  cd "$(_fzf_git_worktrees --no-multi)"
}

#
# ---------------------------------------------------------
###

###
# ---------------------------------------------------------
# Combine Atuin to FZF
# Use the `CTRL+E` to access Atuin UI
#

combine_fzf_atuin() {
  if ! which atuin &> /dev/null; then return 1; fi
  bindkey '^E' _atuin_search_widget

  export ATUIN_NOBIND="true"
  eval "$(atuin init zsh)"
  fzf-atuin-history-widget() {
    local selected num
    setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null

    # local atuin_opts="--cmd-only --limit ${ATUIN_LIMIT:-5000}"
    local atuin_opts="--cmd-only"
    local fzf_opts=(
      --height=${FZF_TMUX_HEIGHT:-40%}
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
      eval "atuin search ${atuin_opts}" \
                                        | fzf "${fzf_opts[@]}"
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
combine_fzf_atuin

# GitHub Gist: https://gist.github.com/nikvdp/f72ff1776815861c5da78ceab2847be2
# make sure you have `tac` [1] (if on on macOS) and `atuin` [2] installed, then drop the below in your ~/.zshrc
#
# [1]: https://unix.stackexchange.com/questions/114041/how-can-i-get-the-tac-command-on-os-x
# [2]: https://github.com/ellie/atuin

# atuin-setup() {
#   ! hash atuin && return
#   bindkey '^E' _atuin_search_widget
#
#   export ATUIN_NOBIND="true"
#   eval "$(atuin init zsh)"
#   fzf-atuin-history-widget() {
#     local selected num
#     setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null
#     selected=$(atuin search --cmd-only --limit ${ATUIN_LIMIT:-5000} | tac |
#       FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS --query=${LBUFFER} +m" fzf)
#     local ret=$?
#     if [ -n "$selected" ]; then
#       # the += lets it insert at current pos instead of replacing
#       LBUFFER+="${selected}"
#     fi
#     zle reset-prompt
#     return $ret
#   }
#   zle -N fzf-atuin-history-widget
#   bindkey '^R' fzf-atuin-history-widget
# }
#
# atuin-setup

#
# ---------------------------------------------------------
###
