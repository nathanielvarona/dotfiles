# Use "less" in place of "more"
# Set less default options as environment variable
export LESS="--raw-control-chars --long-prompt --line-numbers --hilite-search --ignore-case --status-column --underline-special"
# Pipe highlight to less
export LESSOPEN="| ${HIGHLIGHT_CMD[@]} %s"
