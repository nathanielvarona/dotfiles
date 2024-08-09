# EnvPane

Set global environment variables for App does not respect XDG spec

## Installation and Upgrades

### One Liner Install Script

```bash
(cd ~/Library/PreferencePanes && rm -rf EnvPane.prefPane && curl -sL https://github.com/hschmidt/EnvPane/releases/download/releases%2F0.8/EnvPane-0.8.tar.bz2 | tar -xjf -)
```

### Initially Open the App

```bash
open ~/Library/PreferencePanes/EnvPane.prefPane
```

## Usage

GUI

1. Open `System Settings` > `Environment Variables`
2. Add `Name` and `Value` for your global environment variables.

CLI

Any valid changes are automatically applied.

```bash
vim ~/.MacOSX/environment.plist
```
