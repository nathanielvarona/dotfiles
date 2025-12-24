#!/bin/bash

# Default GPG recipient email
GPG_RECIPIENT_EMAIL=${GPG_RECIPIENT_EMAIL:-}
GPG_RECIPIENT=$(gpg --list-keys --with-colons | awk -F: '$1 == "uid" && $10 ~ "'"$GPG_RECIPIENT_EMAIL"'" {print $10; exit}')

if [ -z "$GPG_RECIPIENT" ]; then
  echo "Error: GPG recipient not found."
  exit 1
fi

# gpg_tool function for encrypting/decrypting files
gpg_tool() {

  # Define a nested function to display usage information
  show_usage() {
    echo -e "\nUsage: $(basename "$0") <command> <file>\n"
    echo "command:"
    echo "  encrypt     - Encrypt a file using GPG"
    echo "  decrypt     - Decrypt a GPG encrypted file"
    echo -e "\n"
  }

  # Check if at least two arguments are provided
  if [ $# -lt 2 ]; then
    echo -e "\nError: Insufficient arguments provided\n"
    show_usage
    return 1
  fi

  # Handle command
  case "$1" in
    encrypt)
      # Check if file exists
      if [ ! -f "$2" ]; then
        echo "Error: File not found."
        return 1
      fi
      # Encrypt file using GPG
      gpg --output "$2.gpg" --encrypt --recipient "$GPG_RECIPIENT" "$2"
      ;;
    decrypt)
      # Check if file exists
      if [ ! -f "$2" ]; then
        echo "Error: File not found."
        return 1
      fi
      # Decrypt file using GPG
      gpg --output "${2%.gpg}" --decrypt "$2"
      ;;
    *)
      # Show usage
      echo "Error: Invalid command '$1'"
      show_usage
      return 1
      ;;
  esac

}

# Call gpg_tool with args
gpg_tool "$@"
