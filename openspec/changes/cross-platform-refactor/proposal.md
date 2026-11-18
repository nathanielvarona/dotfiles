# Cross-Platform Refactor

## Why

The repository is public and claims support for macOS, native Linux, WSL2, and Windows, but the implementation drifted: a retired tiling-manager stack (3,465 lines) is still installed, platform routing lives as prose in one ignore file, WSL detection is duplicated inline, VS Code settings hardcode `/home/<user>` paths, and installers maintain package lists that already exist in `pkgs/`. The result is configuration that is larger than it needs to be, difficult to audit, and easy to apply to the wrong platform.

## What Changes

- Introduce one explicit platform model (`windows`, `wsl`, `linux`, `macos`) with a reusable detection helper; migrate every inline WSL check to it.
- Replace `.chezmoiignore.tmpl` prose blocks with a data-driven applicability map, keeping chezmoi's native `dot_*` layout.
- Delete the retired Komorebi stack (`applications.json`, `komorebi.json`, `komorebi.bar.json`, `whkdrc`), its packages (`LGUG2Z.komorebi`, `LGUG2Z.whkd`), and other dead configuration (`example.lua`, commented alternatives).
- Consolidate terminal theming into one Catppuccin Mocha token template consumed by Alacritty, Kitty, Ghostty, WezTerm, and Windows Terminal; keep every emulator.
- Render one tmux template into both tmux and psmux with platform-guarded directives.
- Make Windows Terminal's `settings.json` chezmoi-managed with pinned profile GUIDs; remove the one-shot font patch.
- Template VS Code settings per platform; remove hardcoded home paths repository-wide.
- Split `pkgs/` into `unix/` and `windows/`, delete the duplicate Scoop manifest, and make installers thin wrappers around `just bootstrap-<platform>`.
- Add a CI render matrix (including WSL), a personal-path guard, and a local `just doctor`.
- Restructure documentation into a README landing page plus `docs/macos.md`, `docs/linux.md`, `docs/wsl.md`, `docs/windows.md`.

**BREAKING**: Terminal color schemes change from GitHub Dark High Contrast / Google dark to Catppuccin Mocha. Shell prompts, keybindings, and supported tools are otherwise unchanged.

## Capabilities

### New Capabilities

- `platform-model`: one platform identity and one applicability map for every managed path.
- `shell-environment`: consistent zsh on Unix/WSL, PowerShell 7 primary on Windows, Clink-managed CMD.
- `terminals`: all terminal emulators preserved and sharing one theme source, with a documented primary per platform.
- `terminal-multiplexing`: one configuration rendered for both tmux and psmux.
- `editors`: platform-correct VS Code settings and a shared LazyVim setup.
- `windows-desktop`: GlazeWM, YASB, Scooter, and Clink as the supported Windows desktop surface.
- `wsl-integration`: a clean host/distro boundary with first-class WSL behavior.
- `package-management`: platform-scoped manifests, thin installers, and per-platform bootstrap.
- `verification-and-docs`: CI rendering, privacy guard, `just doctor`, and per-platform documentation.

### Modified Capabilities

None. The repository has no archived OpenSpec baseline; this change establishes the first living specs.

## Impact

- **Configuration**: `.chezmoiignore.tmpl`, `.chezmoitemplates/`, `dot_config/*`, `AppData/`, `Documents/`, `applications.json` (removed), `komorebi*.json` (removed), `run_once_12` (removed).
- **Tooling**: `Justfile`, `install.sh`, `install.ps1`, `pkgs/` layout, new `.github/workflows/`.
- **Behavior**: terminal palette changes once; Windows tiling packages are installed but not auto-started; WSL setup requires an explicit in-distro apply.
- **Risk**: Windows Terminal may rewrite managed `settings.json`; a live-source migration must apply cleanly at every step.
