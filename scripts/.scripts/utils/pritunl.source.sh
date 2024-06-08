# Define a private function to read file data or download from URL
# This function is used internally to fetch the profile data
__get_profile_data() {
  # Check if the input is a file
  if [ -f "$1" ]; then
    # If it's a file, read its contents
    cat "$1"
  else
    # If it's not a file, assume it's a URL and download the data
    curl -sSL "$1"
  fi
}

# Define a public function to encode a profile and copy it to the clipboard
# This function takes a file path or URL as input, encodes the data to base64,
# and copies it to the clipboard
encode_profile_and_copy() {
  # Check if a file path or URL is provided as an argument
  if [ $# -eq 0 ]; then
    # If no argument is provided, print an error message and usage instructions
    echo "Error: No argument provided"
    echo "Usage: encode_profile_and_copy <url or file path>"
    echo "Examples:"
    echo "  Using a URL: encode_profile_and_copy https://vpn.domain.tld/key/a1b2c3d4e5.tar"
    echo "  Using a local file path: encode_profile_and_copy ./pritunl.profile.tar"
    return 1
  fi

  # Get the profile data using the private function
  __get_profile_data "$1" |
  # Encode the data to base64
  base64 --wrap 0 |
  # Copy the encoded data to the clipboard
  {
    # Use pbcopy for macOS
    pbcopy
  } || {
    # Use xclip or xsel for Linux or WSL
    xclip -selection clipboard || xsel --clipboard --input
  }
}
