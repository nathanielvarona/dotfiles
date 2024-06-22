#!/bin/bash

# Define a function to manage Open WebUI containers
open_webui() {
  # Define the container name
  local container_name="open-webui"

  # Define a nested function to display usage information
  show_usage() {
    echo -n -e "\n"
    echo "Usage: $(basename "$0") <arg>"
    echo "arg:"
    echo "  run       - Run the Open WebUI container"
    echo "  remove    - Force remove the Open WebUI container"
    echo "  status    - Display the status of the Open WebUI container"
  }

  # Check if at least one argument is provided
  if [ $# -eq 0 ]; then
    echo "Error: No argument provided"
    show_usage
    return 1
  fi

  # Handle different arguments using a case statement
  case "$1" in
  # Run the Open WebUI container
  run)
    docker run \
      -d \
      -p 3000:8080 \
      --add-host=host.docker.internal:host-gateway \
      -v ~/.open-webui:/app/backend/data \
      --name $container_name \
      --restart always \
      ghcr.io/open-webui/open-webui:main
    ;;
  # Force remove the Open WebUI container
  remove)
    docker rm --force $container_name
    ;;
  # Display the status of the Open WebUI container
  status)
    docker ps -a --format "{{.Names}}: {{.Status}}" --filter name=^/$container_name$
    ;;
  # Invalid argument
  *)
    echo "Error: Invalid argument '$1'"
    show_usage
    return 1
    ;;
  esac
}

# Call the open_webui function with the provided arguments
open_webui "$@"
