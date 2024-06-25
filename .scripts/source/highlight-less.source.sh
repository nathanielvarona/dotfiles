# Define the highlight command
export HIGHLIGHT_CMD=(/usr/local/bin/highlight --out-format xterm256 --line-numbers --force --style moria --replace-tabs 2)
# Use "highlight" in place of "cat"
cath() {
  ${HIGHLIGHT_CMD[@]} "$@"
}

# Use "less" in place of "more"
# Set less default options as environment variable
export LESS="--raw-control-chars --long-prompt --hilite-search --ignore-case --status-column --underline-special"
# Pipe highlight to less
export LESSOPEN="| ${HIGHLIGHT_CMD[@]} %s"
