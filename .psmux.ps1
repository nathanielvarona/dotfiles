# Place this at the very top of .psmux.ps1
if ($env:PSMUX_LOAD_ACTIVE -ne "True")
{
  Write-Warning "Execution blocked: This layout file must be loaded through the 'psmux-load' function."
  return
}

# 1. Initialize detached session
psmux new-session -d -s 'dotfiles'

# --- WINDOW 1: editor ---
# Split window vertically and assign the NEW bottom pane 20% size
psmux split-window -v -p 20 -t 'dotfiles:1.0'

# Focus the top pane (0) and open the editor
psmux send-keys -t 'dotfiles:1.0' 'nvim .' Enter
# Run list command in bottom 20% pane (1)
psmux send-keys -t 'dotfiles:1.1' 'ls -a' Enter
# Force final cursor focus onto the editor pane
psmux select-pane -t 'dotfiles:1.0'

# --- WINDOW 2: vcs ---
# Create second window
psmux new-window -t 'dotfiles'
# Split window vertically and assign the NEW bottom pane 20% size
psmux split-window -v -p 20 -t 'dotfiles:2.0'

# Run git client in top 80% pane (0)
psmux send-keys -t 'dotfiles:2.0' 'lazygit' Enter
# Run version check in bottom 20% pane (1)
psmux send-keys -t 'dotfiles:2.1' 'git --version' Enter

# --- FINAL ATTACH ---
# Switch active view back to the editor window and attach
psmux select-window -t 'dotfiles:1'
psmux attach-session -t 'dotfiles'
