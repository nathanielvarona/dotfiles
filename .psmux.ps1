# -----------------------------------------------------------------------------
# Ensure this layout is only executed via the `psmux-load` helper.
# This prevents accidental execution outside of the PSMUX initialization flow.
# -----------------------------------------------------------------------------
if ($env:PSMUX_LOAD_ACTIVE -ne "True")
{
  Write-Warning "Execution blocked: This layout file must be loaded through the 'psmux-load' function."
  return
}

# -----------------------------------------------------------------------------
# Prevent loading this layout from within an existing PSMUX session.
# Layouts create and attach to sessions, so running one from inside another
# session could result in nested sessions or unexpected behavior.
# -----------------------------------------------------------------------------
if ($env:TMUX)
{
  Write-Warning "Execution blocked: Already running inside a PSMUX session. Detach from the current session before loading this layout."
  return
}

# -----------------------------------------------------------------------------
# Create a new detached session named "dotfiles".
# The initial window is named "editor" to prevent automatic process-based names.
# -----------------------------------------------------------------------------
psmux new-session -d -s 'dotfiles' -n 'editor'

# =============================================================================
# Window: editor
# =============================================================================

# Split the window vertically, allocating 20% of the height to the bottom pane.
psmux split-window -v -p 20 -t 'dotfiles:editor'

# Launch Neovim in the primary (top) pane.
psmux send-keys -t 'dotfiles:editor.0' 'nvim .' Enter

# Display the directory contents in the secondary (bottom) pane.
psmux send-keys -t 'dotfiles:editor.1' 'ls -a' Enter

# Return focus to the editor pane.
psmux select-pane -t 'dotfiles:editor.0'

# =============================================================================
# Window: vcs
# =============================================================================

# Create a dedicated window for version control tasks.
psmux new-window -t 'dotfiles' -n 'vcs'

# Split the window vertically, allocating 20% of the height to the bottom pane.
psmux split-window -v -p 20 -t 'dotfiles:vcs'

# Launch LazyGit in the primary (top) pane.
psmux send-keys -t 'dotfiles:vcs.0' 'lazygit' Enter

# Display the installed Git version in the secondary (bottom) pane.
psmux send-keys -t 'dotfiles:vcs.1' 'git --version' Enter

# =============================================================================
# Attach Session
# =============================================================================

# Select the editor window before attaching so the session always starts there.
psmux select-window -t 'dotfiles:editor'

# Attach to the newly created session.
psmux attach-session -t 'dotfiles'
