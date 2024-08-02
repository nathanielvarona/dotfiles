# Get the desired config index (default to 7: Robby Russell)
p10k_config_index=1

# Function to retrieve the path to the Powerlevel10k config directory
_get_p10k_config_path() {
  local config_path="$(find "$HOME/.local/share/zinit/plugins" -name 'romkatv*' | grep --color=never 'powerlevel10k')/config"
  [[ -d "$config_path" ]] || { echo "Error: Powerlevel10k config directory not found"; exit 1; }
  echo "$config_path"
}

# Array of potential Powerlevel10k config files
# Indices correspond to config numbers
p10k_configs=(
  "$HOME/.p10k-custom.zsh"  # 1: Custom config
  "$(_get_p10k_config_path)/p10k-classic.zsh"  # 2: Classic
  "$(_get_p10k_config_path)/p10k-lean-8colors.zsh"  # 3: Lean 8 colors
  "$(_get_p10k_config_path)/p10k-lean.zsh"  # 4: Lean
  "$(_get_p10k_config_path)/p10k-pure.zsh"  # 5: Pure
  "$(_get_p10k_config_path)/p10k-rainbow.zsh"  # 6: Rainbow
  "$(_get_p10k_config_path)/p10k-robbyrussell.zsh"  # 7: Robby Russell
)

# Get the config path based on the index
p10k_config="${p10k_configs[$p10k_config_index]}"

# Source the selected config file
source "$p10k_config"
