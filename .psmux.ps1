if ($env:PSMUX_LOAD_ACTIVE -ne "True")
{
  Write-Warning "Execution blocked: This layout file must be loaded through the 'psmux-load' function."
  return
}

# 1. Initialize detached session
psmux new-session -d -s 'dotfiles' -n 'editor'

# --- WINDOW 1: editor ---
psmux split-window -v -p 20 -t 'dotfiles:editor'

psmux send-keys -t 'dotfiles:editor.0' 'nvim .' Enter
psmux send-keys -t 'dotfiles:editor.1' 'ls -a' Enter
psmux select-pane -t 'dotfiles:editor.0'

# --- WINDOW 2: vcs ---
psmux new-window -t 'dotfiles' -n 'vcs'

psmux split-window -v -p 20 -t 'dotfiles:vcs'

psmux send-keys -t 'dotfiles:vcs.0' 'lazygit' Enter
psmux send-keys -t 'dotfiles:vcs.1' 'git --version' Enter

# --- FINAL ATTACH ---
psmux select-window -t 'dotfiles:editor'
psmux attach-session -t 'dotfiles'
