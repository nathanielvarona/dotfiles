# Shell

## BASH

### Shell Scripts Linting and Formatting

To ensure consistency and cleanliness, use:

- Run `editorconfig-checker` to check for EditorConfig errors
- Run `shfmt --indent 2 --write ./<path>/<to>/<script>.sh` to format shell scripts

## ZSH

### Troubleshooting

Clear out the Completion Cache from ZSH

```bash
rm -f $HOME/.zcompdump && exec $SHELL -l
```
