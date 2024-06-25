# Define the highlight command
export HIGHLIGHT_CMD=(/usr/local/bin/highlight --out-format xterm256 --line-numbers --force --style moria --replace-tabs 2)
# Use "highlight" in place of "cat"
cath() {
  ${HIGHLIGHT_CMD[@]} "$@"
}
