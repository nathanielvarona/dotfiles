#!/bin/bash

# Define colors for output
YELLOW='\033[33m'
GREEN='\033[32m'
CYAN='\033[36m'
RED='\033[31m'
RESET='\033[0m'

# Define a function to manage Open WebUI containers
open_webui() {
  # Define the container name
  local container_name="open-webui"

  # Define a nested function to display usage information
  show_usage() {
    # Display usage message with colors and formatting
    echo -e "\nUsage: $(basename "$0") <arg>\n"
    echo "arg:"
    echo "  start       - Run the Open WebUI container"
    echo "  stop        - Force remove the Open WebUI container"
    echo "  status      - Display the status of the Open WebUI container"
    echo -e "\n"
  }

  # Check if at least one argument is provided
  if [ $# -eq 0 ]; then
    # Display error message if no argument is provided
    echo -e "${YELLOW}\nError: No argument provided\n${RESET}"
    show_usage
    return 1
  fi

  # Handle different arguments using a case statement
  case "$1" in
  # Run the Open WebUI container
  start)
    # Check if the container exists before attempting to start it
    if [ -n "$(docker ps -q -f name=$container_name)" ]; then
      # Display message if the container is already running
      echo -e "${YELLOW}\nOpen WebUI container already started${RESET}\n"
    else
      # Run the container and capture the container ID from the stdout output
      container_id=$(
        docker run \
          --detach \
          --publish 3000:8080 \
          --add-host=host.docker.internal:host-gateway \
          --volume ~/.open-webui:/app/backend/data \
          --name $container_name \
          --restart always \
          ghcr.io/open-webui/open-webui:main
      )
      # Display success message with the container ID
      echo -e "\nOpen WebUI container started successfully with ID: ${GREEN}$container_id${RESET}\n"
    fi
    ;;
  # Force remove the Open WebUI container
  stop)
    # Check if the container exists before attempting to remove it
    if [ -n "$(docker ps -q -f name=$container_name)" ]; then
      # Display message for stopping and removing the container
      echo -e "\nStopping: ${YELLOW}$(docker stop $container_name)${RESET}"
      echo -e "Removing: ${RED}$(docker rm $container_name)${RESET}\n"
    else
      # Display error message if the container is not found
      echo -e "${YELLOW}\nError: Container '$container_name' not found${RESET}\n"
    fi
    ;;
  # Display the status of the Open WebUI container
  status)
    # Check if the container exists before displaying its status
    if [ -n "$(docker ps -q -f name=$container_name)" ]; then
      # Display the status of the container
      echo -e "\nOpen WebUI container status: ${CYAN}$(docker ps -a --format "{{.Names}} is {{.Status}}" --filter name=^/$container_name$)${RESET}\n"
    else
      # Display error message if the container is not found
      echo -e "${YELLOW}\nError: Container '$container_name' not found${RESET}\n"
    fi
    ;;
  # Invalid argument
  *)
    # Display error message for invalid arguments
    echo -e "${YELLOW}\nError: Invalid argument '$1'${RESET}\n"
    show_usage
    return 1
    ;;
  esac
}

# Call the open_webui function with the provided arguments
open_webui "$@"
