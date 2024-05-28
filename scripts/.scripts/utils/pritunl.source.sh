# Define a function to encode a profile and copy it to the clipboard
encode_profile_and_copy() {
# Check if a file path is provided as an argument
if [ $# -eq 1 ] && [ -f "$1" ]; then
	# If a file path is provided, use that
	# Encode the file to base64 and copy to clipboard
	base64 -w 0 "$1" | {
	# Use pbcopy for macOS
	pbcopy
	} || {
	# Use xclip or xsel for Linux
	xclip -selection clipboard || xsel --clipboard --input
	}
else
	# Download the profile, convert to base64, and copy to clipboard
	curl -sSL "$1" | base64 -w 0 | {
	# Use pbcopy for macOS
	pbcopy
	} || {
	# Use xclip or xsel for Linux
	xclip -selection clipboard || xsel --clipboard --input
	}
fi
}

# Usage:
# encode_profile_and_copy <url or file path>

# Examples:
# Using a URL:
# encode_profile_and_copy https://vpn.domain.tld/key/a1b2c3d4e5.tar

# Using a local file path:
# encode_profile_and_copy ./pritunl.profile.tar

# Description:
# This script encodes a VPN profile to base64 and copies it to the clipboard.
# It can handle both URLs and local file paths as input.
# If a URL is provided, it will download the profile and then encode it.
# If a local file path is provided, it will read the file and encode its contents.
