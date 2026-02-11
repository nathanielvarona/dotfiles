# NeoVim Specific Resource

## NeoVim Plugins

<https://neovimcraft.com/>

## Troubleshooting

> [!NOTE]
> Applies to `lazyvim`, `astronvim`, `nvchad`, and `kickstartvim` only!
>
> For `LunarVim` kindly check the document [LunarVim Installation](https://www.lunarvim.org/docs/installation).

### Reset LazyVim (NeoVim) Cache

#### Standard/Legacy Directory for Nvim

```bash
rm -Rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```

#### Isolated Neovim Applications using `$NVIM_APPNAME` Enviornment Variables

See <https://neovim.io/doc/user/starting.html#%24NVIM_APPNAME>

```bash
rm -Rf ~/.local/share/${NVIM_APPNAME} ~/.local/state/${NVIM_APPNAME} ~/.cache/${NVIM_APPNAME}
```
