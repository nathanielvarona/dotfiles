encode_profile_and_copy() { curl -k -sSL $1 | base64 -w 0 | pbcopy }
