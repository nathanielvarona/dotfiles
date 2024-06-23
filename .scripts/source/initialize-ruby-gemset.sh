#!/bin/bash

# Function to initialize a Ruby project with rbenv and gemset
initialize_ruby_gemset() {
  # Check if arguments are provided
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Error: Please provide the Ruby version and gemset name as arguments"
    echo "Usage: $(basename "$0") <ruby_version> <gemset_name>"
    return 1
  fi

  # Set the Ruby version using rbenv
  echo "Setting Ruby version to $1..."
  rbenv local $1

  # Create a new gemset using the gemset plugin
  echo "Creating gemset $2..."
  rbenv gemset init $2

  # Rename the gemset file to the global compatible format
  echo "Renaming gemset file to .ruby-gemset..."
  mv .rbenv-gemsets .ruby-gemset

  # Display the current Ruby version and gemset
  echo "Ruby version: $(rbenv version)"
  echo "Gemset file: $(rbenv gemset file)"
  echo "Active gemset: $(rbenv gemset active)"

  # Initialize a new Gemfile
  echo "Initializing Gemfile..."
  bundle init

  # Display the Bundler version
  echo "Bundler version: $(bundle show)"

  echo "Done! Ruby and Gemset environment is set."

  # Provide next steps
  echo "You can now install your Gem packages"
  echo "Example: gem install <package>"
}

# Call the function
initialize_ruby_gemset "$@"
