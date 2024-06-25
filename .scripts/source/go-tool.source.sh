#!/bin/zsh

# Define the go-tool function
function go-tool() {
  # Define local variables
  local action="$1"
  local go_version="$2"

  # Define a nested function to display Go environment details
  go_env_details() {
    # Display Go environment details
    echo "Go Environment Details:"
    echo "------------------------------------------"
    echo "Go Root:    $(go env GOROOT)"                # Display Go root directory
    echo "Go Binary:  $(which go)"                     # Display Go binary location
    echo "Go Version: $(go version)"                   # Display Go version
    echo "Go Path:    $(go env GOPATH)"                # Display Go path
    echo "Go OS/Arch: $(go env GOOS)/$(go env GOARCH)" # Display Go OS and architecture
    echo "-------------------------------------------"
  }

  # Define a nested function to remove the "go" alias
  unalias_go() {
    # Check if the "go" alias exists
    if alias go >/dev/null 2>&1; then
      # Remove the "go" alias
      unalias go
    fi
  }

  # Define a nested function to switch Go versions
  switch_go_version() {
    # Check if the requested version is "system"
    if [ $go_version == "system" ]; then
      # Remove the "go" alias
      unalias_go
      # Display Go environment details
      go_env_details
    else
      # Construct the path to the Go version binary
      local go_version_bin=$(which go$go_version)
      # Check if the binary exists
      if [ -f "$go_version_bin" ]; then
        # Remove the "go" alias
        unalias_go
        # Define an alias for the Go version
        alias go=$go_version_bin
        # Display Go environment details
        go_env_details
      else
        # Display an error message if the binary does not exist
        echo "Error: Go version $go_version not installed."
      fi
    fi
  }

  # Handle the main logic based on the action
  case "$action" in
  install)
    # Install a Go version
    echo "Installing Go Version $go_version..."
    go install golang.org/dl/go$go_version@latest
    go$go_version download
    ;;
  use)
    # Switch to a Go version
    switch_go_version $go_version
    ;;
  uninstall)
    # Uninstall a Go version
    local go_root=$(go$go_version env GOROOT)
    local go_bin=$(which go$go_version)
    echo "Uninstalling Go version $go_version..."
    echo "This will remove the following directories:"
    echo "  * $go_root"
    echo "  * $go_bin"
    echo "Are you sure? (y/N) "
    read answer
    if [ "$answer" = "y" ]; then
      rm -Rf "$go_root" "$go_bin"
      echo "Uninstalled Go version $go_version successfully."
    else
      echo "Uninstallation cancelled."
    fi
    ;;
  list)
    # List installed Go versions
    if [ -f "/usr/local/bin/go" ]; then
      echo "system ($(/usr/local/bin/go version | cut -d ' ' -f 3 | sed 's/^go//'))"
    fi
    for file in $HOME/sdk/go*; do
      echo $(basename $file | sed 's/^go//')
    done
    ;;
  list-all)
    # List all available Go versions
    git ls-remote --tags https://github.com/golang/go "go*" |
      awk -F/go '{ print $2 }' |
      uniq |
      sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n |
      grep -v '^1\($\|\.0\|\.0\.[0-9]\|\.1\|\.1rc[0-9]\|\.1\.[0-9]\|.2\|\.2rc[0-9]\|\.2\.1\|.8.5rc5\)$' |
      tr '\n' '\n'
    ;;
  *)
    # Display usage instructions if the input is invalid
    echo "Usage: go-tool <install|use|uninstall|list|list-all> <version|system>"
    echo "  install: Install a Go version"
    echo "  use: Switch to a Go version"
    echo "  uninstall: Uninstall a Go version"
    echo "  list: List installed Go versions"
    echo "  list-all: List all available Go versions"
    ;;
  esac
}
