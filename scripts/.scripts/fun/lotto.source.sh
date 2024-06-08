# Function to generate Lotto numbers
lotto() {
  if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    echo "Usage: lotto <selected_numbers> <total_selections> [combinations]"
    return 1
  fi

  local selected_numbers=$1
  local total_selections=$2
  local combinations=${3:-1}

  # Input validation
  if [[ "$selected_numbers" -le 0 || "$total_selections" -le 0 || "$combinations" -le 0 ]]; then
    echo "All values must be greater than zero."
    return 1
  fi

  if [[ "$selected_numbers" -gt "$total_selections" ]]; then
    echo "Selected numbers cannot be greater than total selections."
    return 1
  fi

  # Generate combinations
  echo "Generating $combinations combination(s) of $selected_numbers random numbers out of $total_selections selections:"
  for ((i = 1; i <= combinations; i++)); do
    numbers=($(shuf -i 1-"$total_selections" -n "$selected_numbers" | sort -n))
    echo "Combination $i: ${numbers[*]}"
  done
}
