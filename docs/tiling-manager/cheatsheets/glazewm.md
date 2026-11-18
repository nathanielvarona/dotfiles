# GlazeWM Keybinding Cheatsheet

`Alt` is the primary modifier. `Shift` is written explicitly. Arrow-key alternatives are shown where configured.

## Focus windows

| Binding | Action |
| :--- | :--- |
| `Alt+H` / `Alt+Left` | Focus left |
| `Alt+J` / `Alt+Down` | Focus down |
| `Alt+K` / `Alt+Up` | Focus up |
| `Alt+L` / `Alt+Right` | Focus right |

## Move windows

| Binding | Action |
| :--- | :--- |
| `Alt+Shift+H` / `Alt+Shift+Left` | Move window left |
| `Alt+Shift+J` / `Alt+Shift+Down` | Move window down |
| `Alt+Shift+K` / `Alt+Shift+Up` | Move window up |
| `Alt+Shift+L` / `Alt+Shift+Right` | Move window right |

## Resize directly

| Binding | Action |
| :--- | :--- |
| `Alt+U` / `Alt+-` | Decrease width by 2% |
| `Alt+P` / `Alt+=` | Increase width by 2% |
| `Alt+O` / `Alt+Shift+-` | Increase height by 2% |
| `Alt+I` / `Alt+Shift+=` | Decrease height by 2% |

`Alt+O` also has a conflicting set-floating binding; see the known overlaps in the [main documentation](../README.md#known-binding-overlaps).

## Resize mode

Enter with `Alt+R`. Exit with `Esc` or `Enter`.

| Binding | Action |
| :--- | :--- |
| `H` / `Left` | Decrease width by 2% |
| `L` / `Right` | Increase width by 2% |
| `K` / `Up` | Increase height by 2% |
| `J` / `Down` | Decrease height by 2% |
| `Esc` / `Enter` | Exit resize mode |

## Window state and layout

| Binding | Action |
| :--- | :--- |
| `Alt+Shift+Space` / `Alt+T` | Toggle floating (centered) |
| `Alt+Shift+T` | Toggle tiling |
| `Alt+F` | Toggle fullscreen |
| `Alt+M` | Toggle minimized |
| `Alt+Q` / `Alt+W` / `Alt+Shift+Q` | Close window |
| `Alt+O` | Set floating (centered) |
| `Alt+V` / `Alt+J` | Toggle tiling direction |

`Alt+J` also focuses down, and `Alt+O` also resizes height. See the known overlaps.

## Workspaces

### Switch workspace

| Binding | Action |
| :--- | :--- |
| `Alt+1` … `Alt+9` | Focus workspace 1–9 |
| `Alt+0` | Focus workspace 10 |

### Move focused window to a workspace

| Binding | Action |
| :--- | :--- |
| `Alt+Shift+1` … `Alt+Shift+9` | Move window to workspace 1–9 and follow it |
| `Alt+Shift+0` | Move window to workspace 10 and follow it |

### Navigate active workspaces

| Binding | Action |
| :--- | :--- |
| `Alt+S` | Focus next active workspace |
| `Alt+A` | Focus previous active workspace |
| `Alt+D` | Focus recent workspace |

### Move a whole workspace between monitors

| Binding | Action |
| :--- | :--- |
| `Alt+Shift+A` | Move workspace left |
| `Alt+Shift+F` | Move workspace right |
| `Alt+Shift+D` | Move workspace up |
| `Alt+Shift+S` | Move workspace down |

## Launch applications

| Binding | Action |
| :--- | :--- |
| `Alt+Enter` | Open Alacritty |
| `Alt+Ctrl+Enter` | Open Alacritty with psmux |
| `Alt+Shift+B` / `Alt+Shift+Enter` | Open Chrome |
| `Alt+Shift+F` | Open Explorer |
| `Alt+Shift+N` | Open VS Code |
| `Alt+Shift+Q` | Open Calculator |

`Alt+Shift+F` also moves the workspace right, and `Alt+Shift+Q` also closes the focused window. See the known overlaps.

## System shortcuts

| Binding | Action |
| :--- | :--- |
| `Alt+Ctrl+L` | Lock the workstation |
| `Alt+Ctrl+A` | Open sound settings |
| `Alt+Ctrl+B` | Open Bluetooth settings |
| `Alt+Ctrl+D` | Open display settings |
| `Alt+Ctrl+N` | Open network settings |
| `Alt+Ctrl+P` | Open power and sleep settings |
| `Alt+Ctrl+V` | Open clipboard settings |
| `PrintScreen` | Capture a screenshot to the clipboard |

## Session control

| Binding | Action |
| :--- | :--- |
| `Alt+Shift+P` | Pause or resume GlazeWM |
| `Alt+Shift+R` | Reload configuration |
| `Alt+Shift+W` | Redraw all windows |
| `Alt+Shift+E` | Exit GlazeWM |
