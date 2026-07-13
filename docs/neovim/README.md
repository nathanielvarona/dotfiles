# NeoVim Specific Resource

## Troubleshooting

> [!NOTE]
> Applies to `lazyvim`, `astronvim`, `nvchad`, and `kickstartvim` only!
>
> For `LunarVim` kindly check the document [LunarVim Installation](https://www.lunarvim.org/docs/installation).

### Reset NeoVim State

Default Neovim Directory

```bash
rm -Rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```

Isolated Neovim Applications using `$NVIM_APPNAME` Enviornment Variables

See <https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME>

For macOS and Linux/WSL

```bash
export NVIM_APPNAME=lazyvim
rm -Rf ~/.local/share/${NVIM_APPNAME} ~/.local/state/${NVIM_APPNAME} ~/.cache/${NVIM_APPNAME}
```

For Windows (PowerShell)

```powershell
$env:NVIM_APPNAME = "lazyvim"
rm -Path "~/.cache/$env:NVIM_APPNAME", "~/AppData/Local/$env:NVIM_APPNAME-data" -Recurse -Force
```
