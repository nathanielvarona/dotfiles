#!/bin/zsh

# Define the go-tool function
function go-tool() {
  # Define local variables
  local go_version="$2"

  # Define a nested function to display Go environment details
  go_env_details() {
    echo "Go Environment Details:"
    echo "------------------------------------------ "
    echo "Go Root:    $(go env GOROOT)"
    echo "Go Binary:  $(which go)"
    echo "Go Version: $(go version)"
    echo "Go Path:    $(go env GOPATH)"
    echo "Go OS/Arch: $(go env GOOS)/$(go env GOARCH)"
    echo "-------------------------------------------"
  }

  # Define a nested function to switch Go versions
  switch_go_version() {
    # Check if the requested version is "system"
    if [ $go_version == "system" ]; then
      # If the "go" alias exists, remove it
      if alias go >/dev/null 2>&1; then
        unalias go
      fi
      # Display Go environment details
      go_env_details
    else
      # Construct the path to the Go version binary
      local go_version_bin=$(which go$go_version)
      # Check if the binary exists
      if [ -f "$go_version_bin" ]; then
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

  # Handle the main logic based on the first argument
  case "$1" in
  install)
    # Install a Go version
    echo "Installing Go Version"
    # Install the requested Go version
    go install golang.org/dl/go$go_version@latest
    # Download the Go version regardless of existing installation
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
      echo "system"
    fi
    for file in $HOME/sdk/go*; do
      echo $(basename $file | sed 's/^go//')
    done
    ;;
  *)
    # Display usage instructions if the input is invalid
    echo "Usage: go-tool <install|use|uninstall|list> <version|system>"
    echo "  install: Install a Go version"
    echo "  use: Switch to a Go version"
    echo "  uninstall: Uninstall a Go version"
    echo "  list: List installed Go versions"
    ;;
  esac
}
