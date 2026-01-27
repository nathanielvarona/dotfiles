if [[ "$OSTYPE" == "darwin"* ]]; then
  . "$HOME/.config/zsh/mac.zsh"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  . "$HOME/.config/zsh/linux.zsh"
fi
