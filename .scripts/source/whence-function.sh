#!/bin/zsh

# Define the whence_function function to locate the file where a Zsh function is defined
function whence_function {
    # Ensure the function is running in a Zsh-compatible environment
    emulate -L zsh

    # Initialize local variables
    local name locations ret=0

    # Loop over all provided function names
    for name; do
        # Search for the function definition file in the fpath directories
        locations=(${^fpath}/${name}(N))

        # If the function is found in at least one location
        if (( ${#locations} != 0 )); then
            # Print the first location where the function is found
            print -l -- $locations[1]
        else
            # Set the return code to 1 if the function is not found
            ret=1
        fi
    done

    # Return the status code (0 if all functions are found, 1 if any function is not found)
    return $ret
}

whence_function "$@"
