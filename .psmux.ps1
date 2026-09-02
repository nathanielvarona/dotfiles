# -----------------------------------------------------------------------------
# Safety Check: PSMUX Loader
# -----------------------------------------------------------------------------
# This layout must be executed through the `psmux-load` helper.
# Running the file directly is blocked to prevent accidental session creation.
# -----------------------------------------------------------------------------
if ($env:PSMUX_LOAD_ACTIVE -ne "True")
{
    Write-Warning "Execution blocked: This layout file must be loaded through the 'psmux-load' function."
    return
}

# -----------------------------------------------------------------------------
# Safety Check: Existing PSMUX Session
# -----------------------------------------------------------------------------
# PSMUX exposes TMUX inside its panes for tmux compatibility.
# Prevent this layout from creating a nested PSMUX session.
# -----------------------------------------------------------------------------
if ($env:TMUX)
{
    Write-Warning "Execution blocked: Already running inside a PSMUX session. Detach from the current session before loading this layout."
    return
}

# =============================================================================
# Session: dotfiles
# =============================================================================

# Create the detached session.
# The first window is explicitly named "editor".
psmux new-session -d -s 'dotfiles' -n 'editor'

# =============================================================================
# Window 1: editor
# =============================================================================

# The newly created session starts with one active pane.
# Send Neovim to that pane without explicitly specifying a pane target.
psmux send-keys 'nvim .' Enter

# Split the editor window vertically.
# The new bottom pane receives 20% of the height.
psmux split-window -v -p 20

# The newly created pane becomes the active pane.
# Display hidden files here.
psmux send-keys 'ls -a' Enter

# Select the top/editor pane.
psmux select-pane -U

# =============================================================================
# Window 2: vcs
# =============================================================================

# Create the VCS window.
psmux new-window -t 'dotfiles' -n 'vcs'

# The new window starts with one active pane.
# Launch LazyGit there.
psmux send-keys 'lazygit' Enter

# Split the VCS window vertically.
psmux split-window -v -p 20

# The newly created bottom pane becomes active.
# Display the installed Git version.
psmux send-keys 'git --version' Enter

# Return to the LazyGit pane.
psmux select-pane -U

# =============================================================================
# Finalize Layout
# =============================================================================

# Select the editor window.
psmux select-window -t 'dotfiles:1'

# Attach to the session.
psmux attach-session -t 'dotfiles'
