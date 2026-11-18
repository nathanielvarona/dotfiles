# Tiling Manager

Windows uses [GlazeWM](https://github.com/glzr-io/glazewm) as the active tiling window manager. YASB provides the status bar, and PowerShell is the daily shell. Komorebi is archived under `dot_config/komorebi/` for future experiments and is not launched by default.

## Files

| Purpose | Repository path | Live path |
| :--- | :--- | :--- |
| GlazeWM config | `dot_glzr/glazewm/config.yaml` | `~/.glzr/glazewm/config.yaml` |
| YASB config | `dot_config/yasb/config.yaml` | `~/.config/yasb/config.yaml` |
| PowerShell profile | `dot_config/powershell/Microsoft.PowerShell_profile.ps1.tmpl` | `~/.config/powershell/Microsoft.PowerShell_profile.ps1` |

## Core shortcuts

| Action | Binding |
| :--- | :--- |
| Reload GlazeWM config | `Alt+Shift+R` |
| Pause / resume tiling | `Alt+Shift+P` |
| Redraw windows | `Alt+Shift+W` |
| Exit GlazeWM | `Alt+Shift+E` |

Reload after editing the config:

```powershell
glazewm command wm-reload-config
```

## Binding mode indicator

YASB includes the GlazeWM Binding Mode widget. It appears next to the tiling-direction indicator only while a binding mode is active, such as `resize`. Left-click cycles modes, middle-click toggles the label, and right-click disables the active mode.

## Mental model

- **Focus** changes which window receives input.
- **Move** changes the position of a window inside the current workspace.
- **Resize** changes a window’s width or height.
- **Workspace** is a named virtual desktop (`1` through `10`).
- **Tiling direction** controls whether the next window is placed to the right/down or left/up.
- **Binding mode** temporarily remaps keys. The only current mode is `resize`.

## Modifier convention

This config uses `Alt` as the main modifier because Windows reserves many `Super` (Windows key) shortcuts. Keep that convention unless there is a strong reason to break it.

## Keybinding cheatsheet

See [cheatsheets/glazewm.md](./cheatsheets/glazewm.md) for every binding grouped by task.

## Known binding overlaps

The current config assigns some keys more than once. At least one action on each of these keys is likely unreachable, so verify the intended behavior before relying on it:

| Binding | Assigned actions |
| :--- | :--- |
| `Alt+J` | Focus down and toggle tiling direction |
| `Alt+O` | Resize height +2% and set floating centered |
| `Alt+Shift+F` | Move workspace right and open Explorer |
| `Alt+Shift+Q` | Close window and open Calculator |

Resolve an overlap by giving one action a different key, then update both this note and the cheatsheet.

## Maintenance

When changing `dot_glzr/glazewm/config.yaml`:

1. Update the cheatsheet in the same commit.
2. Run `chezmoi apply ~/.glzr/glazewm/config.yaml`.
3. Reload with `Alt+Shift+R` or `glazewm command wm-reload-config`.
4. Add a one-line comment above the changed binding group in the config.
