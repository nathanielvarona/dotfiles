if [[ "$OSTYPE" == "darwin"* ]]; then
  . "$HOME/.config/zsh/mac.zshrc"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  . "$HOME/.config/zsh/linux.zshrc"
fi
