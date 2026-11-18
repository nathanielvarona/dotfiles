# Cross-Platform Refactor Spec

**Status:** Draft
**Date:** 2026-11-18
**Repo:** <https://github.com/nathanielvarona/dotfiles>
**Scope owner:** nathanielvarona
**Request (verbatim):** "This is my personal Dotfiles collection and is open-source. Make sure it clean and simple since this is already avaialbe on the Public specifically in this repository https://github.com/nathanielvarona/dotfiles. I want this dotfile collection compatible accross all platforms macOS, Native Linux, and Windows (CMD / PowerShell / WSL). Mainly my Primary Machine right now, from a MacOS users for more than a decade, and currently Linux machines for most of my development via WSL2."

---

## 1. Summary

Rearchitect the chezmoi source tree so that every file has exactly one owner (shared, macOS, Linux, WSL, or Windows), every platform receives a correct and complete configuration, and the repository reads cleanly as a public project. The refactor keeps chezmoi's native source conventions rather than inventing a parallel directory hierarchy, but replaces the current ad-hoc platform routing (prose blocks in `.chezmoiignore.tmpl`, scattered `kernel.osrelease` checks, hardcoded personal paths) with one explicit, testable platform model.

Success is measured in fewer files and lines, zero personal machine paths, and a CI job that renders the source for all four platforms on every push.

## 2. Goals

1. **One owner per file.** Each managed file is either shared, or explicitly owned by exactly one platform layer. No file is silently applicable to the wrong OS.
2. **Fewer files and lines.** Delete retired configuration, commented-out alternatives, and duplicate wrappers; consolidate files that exist only to differ by a few lines.
3. **Four first-class platforms.** macOS, native Linux, WSL2, and Windows (PowerShell + Clink-managed CMD) all bootstrap, apply, and validate cleanly.
4. **WSL2 modeled explicitly.** A single computed platform variable is the only sanctioned way to branch on WSL.
5. **Public-repo hygiene.** No hardcoded usernames or absolute home paths anywhere in the source, enforced by CI.
6. **Reproducibility.** `pkgs/` manifests are organized by platform and drive restores; installers stop maintaining a second, divergent package list.
7. **Verifiable.** A CI matrix renders the source for each platform; a local `just doctor` performs the same checks before push.

## 3. Non-goals

- Changing the visual theme, prompt design, or keybindings beyond what consolidation requires.
- Dropping terminal emulators or multiplexers (all are explicitly retained).
- Introducing a new configuration system (Nix, Home Manager, Ansible, etc.).
- Secrets management changes: no keys are committed today and none will be.
- Windows-native equivalents for every Unix-only tool.
- Rewriting large third-party configs (kitty, yasb, yazi) for style alone.

## 4. Interview Decisions

| Topic | Decision | Implication |
|---|---|---|
| Platform priority | All four first-class | Every layer gets docs, bootstrap, and CI rendering |
| Definition of done | Fewer files and lines | Deletion and consolidation outweigh feature parities |
| Structural change | Full rearchitecture | Logical redesign is allowed, paths may move |
| Layout model | Stay chezmoi-native | Keep `dot_*` encoding at root; platform map lives in templates, not new directory roots |
| macOS status | Occasional use | Keep working and documented, not the primary optimization target |
| Terminals | Keep all (Alacritty, Kitty, Ghostty, WezTerm, Scooter) | Primary: Windows Terminal on Windows, Kitty on macOS; avoid duplicating color definitions |
| Multiplexer | One shared tmux config | `psmux` renders the same template as `tmux`, with guarded platform-specific directives |
| VS Code settings | Template per OS | Replace the single shared `settings.json` containing Linux-only paths |
| WSL modeling | First-class fourth platform | Dedicated platform value, helper template, and docs |
| Entry point | Thin installers + `just` | Installers only install chezmoi/just, then hand off to `just bootstrap` |
| Windows Terminal | Manage `settings.json` via template | Remove the one-shot font patch; own the file with pinned GUIDs |
| Terminal theming | One shared theme source | Token template consumed by each emulator |
| `pkgs/` layout | Split by platform | `pkgs/unix/` and `pkgs/windows/` with ownership documented |
| Verification | CI template render check | Matrix across OS incl. WSL; plus markdown/TOML/editorconfig lint |
| Personal paths | Hard rule + CI check | Fail on `/home/<user>`, `/Users/<user>`, `C:/Users/<user>` |
| Migration | No broken window | Each phase must still `chezmoi apply` cleanly on Windows and WSL |
| CMD support | Clink-managed | `AppData/Local/clink` remains a supported surface |
| Docs | README + `docs/` per platform | `docs/windows.md`, `docs/wsl.md`, `docs/macos.md`, `docs/linux.md` |

### Resolving "full rearchitecture" vs "stay chezmoi-native"

The rearchitecture is **logical, not path-for-path**: chezmoi's `dot_` naming and flat root stay, because moving everything into `platform/<os>/` would break chezmoi's target mapping and add indirection without reducing files. What changes is that the platform routing becomes data (one template table), helpers become reusable templates, and ownership of every file is explicit and testable. Windows-only artifacts (`AppData/`, `Documents/`, `applications.json`, `komorebi.json`) stay at the root for target-path reasons, but every one of them is registered in the single platform map.

## 5. Platform Model

Four platform values, in precedence order:

| Value | Detection | Notes |
|---|---|---|
| `windows` | `.chezmoi.os == "windows"` | PowerShell 7 primary, Clink for CMD |
| `wsl` | `.chezmoi.os == "linux"` **and** `kernel.osrelease` contains `microsoft`/`WSL` | First-class: own docs, clipboard, networking, VS Code integration |
| `linux` | `.chezmoi.os == "linux"` and not WSL | Debian/Ubuntu reference, Linuxbrew |
| `macos` | `.chezmoi.os == "darwin"` | Homebrew, Keychain, Apple OpenSSH |

### New helper templates (`.chezmoitemplates/helpers/`)

- `platform.tmpl` → returns `windows|wsl|linux|macos`. Single implementation of the WSL detection; consumes `.chezmoi.os` and `.chezmoi.kernel.osrelease` and **must guard** `kernel` access with `if eq .chezmoi.os "linux"` (the key is absent on Windows/macOS).
- `is_wsl.tmpl` → `true|false`, thin wrapper over `platform.tmpl`.
- `is_native_unix_like.tmpl` → keep existing contract (true for macOS and non-WSL Linux) and reimplement on top of `platform.tmpl`.

All new and touched templates branch via `includeTemplate "helpers/platform.tmpl" .` (or a local `$platform` variable set once) instead of repeating `.chezmoi.os` comparisons. Existing inline WSL checks to migrate: `dot_config/lazyvim/lua/config/options.lua.tmpl:84`, `dot_config/lazyvim/lua/plugins/mason.lua.tmpl:2`, plus clipboard/`win32yank` handling.

## 6. Current State (Evidence)

| Finding | Evidence |
|---|---|
| Retired Komorebi stack still fully wired | `applications.json` 3,263 lines, `dot_config/whkdrc` ~60, `komorebi.json` 43, `komorebi.bar.json` 38 = **3,465 lines**; still installed via `pkgs/windows-winget:32` (`LGUG2Z.komorebi`) and `:33` (`LGUG2Z.whkd`) |
| Platform routing is prose in one file | `.chezmoiignore.tmpl` mixes redundant global ignores, three platform blocks (one empty), and a 20-entry Windows brace glob |
| WSL detection is ad-hoc | `options.lua.tmpl` and `mason.lua.tmpl` each inline `kernel.osrelease \| contains "WSL2"`; no shared helper |
| VS Code settings are shared but Linux-specific | `dot_config/Code/User/settings.json:269` sets `/home/nath/.cargo/bin/kdl-lsp`; `:266-267` keep commented Windows paths |
| Personal paths leak into a public repo | 5 occurrences of `/home/nath`, `C:/Users/nath`, `/Users/nath` |
| Two package truths per platform | `install.ps1` hardcodes 21 winget IDs vs 89 in `pkgs/windows-winget` (zero ID overlap, Komorebi only in the export); `install.sh` hardcodes 8 formulae also present in `pkgs/formulae.Brewfile` |
| Windows Terminal is patched once | `run_once_12_...ps1.tmpl` merges a 90-line JSON blob to set one font, then never runs again |
| Duplicate wrapper trees | `AppData/Roaming/alacritty/{alacritty,fonts}.toml.tmpl` byte-identical to `dot_config/alacritty/*`; same for `scooter/config.toml.tmpl` |
| Dead LazyVim sample | `dot_config/lazyvim/lua/plugins/example.lua` (193 lines) short-circuits with `if true then return {} end` |
| Comment graveyards | `dot_config/zsh/dot_zshrc.tmpl` has 279 comment lines of 600; `options.lua.tmpl` and Code settings/keybindings carry commented alternatives |
| Multiplexer configs diverged | `tmux.conf.tmpl` 135 lines vs `psmux.conf` 101, same intent |
| Four emulators, no shared theme | `kitty.conf` 3,170 lines, `wezterm.lua` 198, `ghostty/config` 20, Alacritty via two-line wrappers, plus Windows Terminal JSON |
| `pkgs/` is a flat bag | 20 manifests mixing Unix and Windows managers, plus 4 unrelated `*.Brewfile` types |
| Inert ignore entries | `.editorconfig`, `.tmuxp.yaml`, `.github`, `.gitmodules` are implicitly ignored by chezmoi (leading dot); `.vscode/`, `.taplo.toml`, `.markdownlint-cli2.yaml`, `.psmux.ps1` are therefore **not** managed |

Baseline metrics for the acceptance criteria: **183 files / ~19.4k lines** total, **123 config/code files / 17,324 lines**.

## 7. Target Architecture

### 7.1 Single platform map

Replace the prose blocks in `.chezmoiignore.tmpl` with a data-driven template:

```gotemplate
{{- $p := includeTemplate "helpers/platform.tmpl" . | trim -}}
{{- $windowsOnly := list "AppData" "Documents" ".wslconfig" ".config/yasb" ".glzr" ".config/psmux" -}}
{{- $unixOnly := list ".MacOSX" ".zshenv" ".scripts" -}}
{{- $macOnly := list ".MacOSX" -}}
...
{{- if ne $p "windows" }}{{ range $windowsOnly }}{{ . }}\n{{ end }}{{ end -}}
{{- if eq $p "windows" }}{{ range $unixOnly }}{{ . }}\n{{ end }}{{ end -}}
```

Rules:
- Every platform-specific entry is listed once, in one of four lists, and rendered by platform.
- Delete entries that are implicitly ignored (leading dot) and the two empty platform blocks.
- Keep the file as the *only* place that decides which paths apply where; configs branch on behavior, never on applicability.

### 7.2 Platform ownership table

| Area | macOS | Linux | WSL | Windows |
|---|---|---|---|---|
| Shell | zsh | zsh | zsh | PowerShell 7 + Clink |
| Prompt | oh-my-posh | oh-my-posh | oh-my-posh | oh-my-posh |
| Terminal | Kitty (primary), Alacritty, Ghostty, WezTerm | Alacritty (+ others) | Windows Terminal (host) | Windows Terminal (primary), Scooter |
| Multiplexer | tmux | tmux | tmux | psmux (renders shared tmux template) |
| Tiler / bar | AeroSpace | — | — | GlazeWM + YASB |
| Editor | LazyVim, VS Code (templated) | LazyVim, VS Code | LazyVim, VS Code (WSL mode) | LazyVim, VS Code (Windows paths) |
| Package source | `pkgs/unix/formulae.Brewfile` | `pkgs/unix/*` | `pkgs/unix/*` | `pkgs/windows/*` |

The Windows-only trees at the root (`AppData/`, `Documents/`) stay where they are for target-path reasons and are registered in the map; the retired Komorebi files are deleted outright.

### 7.3 WSL as a fourth platform

Split by concern, per the interview:

- **Windows side owns the boundary:** `.wslconfig` (mirrored networking), `docs/wsl/HOST_SERVICES_ACCESS.md`, Windows Firewall guidance, and the VS Code `useWSL` toggles.
- **Distro side owns the Linux config:** a separate chezmoi clone inside WSL applies the same repo, rendering with `platform == wsl`.
- **No cross-boundary execution:** Windows bootstrap never runs commands inside the distro (no `wsl.exe` provisioning, no sudo over the boundary). It applies Windows-side config and prints the exact one-liner to run inside WSL.
- **Shared:** zsh, LazyVim, tmux, git, tooling. WSL-specific overrides: clipboard (`win32yank`), image rendering (Snacks/tmux passthrough), browser open, and `code` integration.
- `docs/wsl.md` documents the two-instance model explicitly (one source of truth, two applies).

### 7.4 Windows Terminal becomes declarative

- Manage `AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json` as a chezmoi template.
- Pin explicit profile GUIDs (do not let Terminal generate them) and include only the profiles/settings actually used: PowerShell 7, Windows PowerShell, CMD, WSL Ubuntu.
- Delete `run_once_12_set_windows_terminal_settings.ps1.tmpl` and its embedded `Merge-Json` function.
- Font/theme values come from the shared theme tokens (7.5), including the Nerd Font symbol fallback.
- Risk: Terminal rewrites `settings.json` on UI changes. Mitigation: `chezmoi diff` will surface drift, and profile edits are documented as "edit the template, not the UI".

### 7.5 Terminals: keep all, share the theme

Canonical palette: **Catppuccin Mocha**, exposed as `.chezmoitemplates/theme/colors.tmpl`. The token set is semantic, not vendor-shaped, so a future palette swap touches one file:

| Group | Tokens |
|---|---|
| Surfaces | `base`, `mantle`, `crust`, `surface0`, `surface1`, `surface2`, `overlay0` |
| Text | `text`, `subtext0`, `subtext1`, `lavender` |
| Accents | `blue`, `sapphire`, `sky`, `teal`, `green`, `yellow`, `peach`, `maroon`, `red`, `mauve`, `pink` |
| Chrome | `cursor`, `selection_background`, `selection_foreground`, `border` |
| Type | `font_family` (`MesloLGS Nerd Font`), `font_size_windows` (11), `font_size_unix` (13) |

Each emulator renders the same tokens in its native syntax:

- **Alacritty:** keep `.chezmoitemplates/alacritty/*`; replace the `github_dark_high_contrast` theme import with generated `[colors]` from tokens; keep one wrapper tree (see 7.5.1).
- **Kitty:** replace `include themes/GitHub_Dark.conf` with the generated color/typography block; the `themes/` external stays available as an opt-in.
- **Ghostty, WezTerm:** render the same tokens (WezTerm currently hardcodes `Google (dark) (terminal.sexy)`).
- **Windows Terminal:** tokens drive the `schemes` entry and `profiles.defaults.font` in the managed `settings.json` (7.4).

CLI tools follow the same palette and already do in part (`bat`, `lsd`, `lazygit`, `scooter`, tmux via `catppuccin/tmux`); their theme imports are pointed at Mocha artifacts to remove mixed palettes.

**YASB is the documented exception.** `dot_config/yasb/styles.css` uses Windows 11 accent tokens (`--yasb-accent: #4cc2ff`, `#303030` borders) because it is OS chrome, not a terminal; converting it to Mocha would look wrong against Windows 11 surfaces. Keep it separate and note the exception in `docs/windows.md`.

**Intentional visual change:** Alacritty, Kitty, Ghostty, and WezTerm currently use GitHub Dark High Contrast / Google dark; unifying on Mocha changes their appearance once. This is the consolidation cost of the single theme source and is reversible by editing one token file (documented in the commit message and `docs/`).

### 7.5.1 Duplicate Alacritty/Scooter wrappers

`AppData/Roaming/alacritty/*` and `dot_config/alacritty/*` are byte-identical two-line delegates; same for Scooter. chezmoi maps one source file to exactly one target, so both wrapper sets are structurally required. The decision is to keep them at the minimum size (two `{{ template }}` lines each, no embedded settings), keep the single implementation in `.chezmoitemplates/`, and document the constraint once in the README tree map instead of re-explaining it inline. Renaming or relocating the Windows AppData tree would not remove the wrappers and is out of scope.

Acceptance: changing a token changes every emulator on the next `chezmoi apply`, no emulator loses a feature, and no emulator carries its own literal color block.

### 7.6 One tmux template

Collapse `dot_config/tmux/tmux.conf.tmpl` and `dot_config/psmux/psmux.conf` into `.chezmoitemplates/tmux/tmux.conf.tmpl`, rendered to both targets:

- Shared: prefix, keybindings, pane/window behavior, status line, copy mode.
- Guarded by `platform` value: `set-clipboard`, passthrough/allow-passthrough, `allow-predictions` (psmux-only), terminal-features (tmux-only).
- Acceptance: both files are generated from one source; no psmux-unsupported directive reaches tmux and vice versa.

### 7.7 VS Code per-OS templating

- `dot_config/Code/User/settings.json` → `settings.json.tmpl` with `{{ if eq $p "windows" }}` / `{{ else if eq $p "wsl" }}` / `{{ else }}` blocks around tool paths (`kdl`, ripgrep, lazygit, terminal profiles).
- Remove all commented path variants after templating; CI's personal-path guard enforces the rest.
- `useWSL`/`wslDistribution` values come from the platform block rather than being set unconditionally.
- `keybindings.json` becomes a template only if platform behavior actually differs; otherwise keep it static and delete the commented `ctrl+space` block.

### 7.8 CMD stays supported via Clink

- `AppData/Local/clink/{clink_start.cmd,oh-my-posh.lua}` remain managed Windows files and join the platform map.
- `docs/windows.md` documents CMD as a supported but secondary shell: prompt, history, and PATH work; Aliases live in PowerShell.
- CI renders the Clink files on the Windows runner.

### 7.9 Packages and bootstrap

- Reorganize: `pkgs/unix/` (formulae/cask/mas/tap Brewfiles, asdf, pyenv, pipx, cargo, gh extensions, krew, helm, cpanfile, whalebrew, ollama, hugging-face, vscode) and `pkgs/windows/` (winget, choco, windows-vscode). README documents the Dump → Commit → Restore workflow.
- **No archived directory.** Every manifest that survives is active and has a `just restore-*` recipe. Manifests that only duplicate another manager are deleted: `pkgs/windows-scoop` contains a single `nerd-fonts|NerdFontsSymbolsOnly` entry already owned by `pkgs/windows-choco` (`nerd-fonts-NerdFontsSymbolsOnly`), so Scoop is dropped as a manager. `mas` (12 apps) and `whalebrew` (2 images) stay, because macOS remains supported and the entries are functional.
- **Retired-tiler packages removed:** `LGUG2Z.komorebi` (`windows-winget:32`) and `LGUG2Z.whkd` (`:33`).
- **Windows desktop stack is installed by bootstrap:** `glzr-io.glazewm` and `AmN.yasb` are already in the winget export, so `just bootstrap-windows` installs them like any other package. Registering them for autostart stays a documented manual step in `docs/windows.md` — Windows does not offer a reliable scripted startup entry for packaged apps, and a public repo should not silently enable a tiling WM on someone else's machine.
- Installers become thin: `install.sh` and `install.ps1` only ensure `git`, `curl`, `chezmoi`, and `just`, then run `just bootstrap`.
- `just bootstrap` dispatches by platform: `bootstrap-macos`, `bootstrap-linux`, `bootstrap-wsl`, `bootstrap-windows`; each restores the matching manifest set, then `chezmoi init --apply`.
- **WSL bootstrap runs inside the distro only.** `bootstrap-wsl` is invoked by the user in WSL; the Windows run prints that command instead of executing it (7.3).
- `run_once_00`/`run_once_01` remain idempotent system steps (zsh shell, locale) but are documented from `bootstrap-linux`/`bootstrap-wsl` as well, so a re-apply on an existing machine is understandable.

### 7.10 Justfile

- Split into `just/` modules (`bootstrap.just`, `packages.just`, `doctor.just`) included from the root `Justfile`, or keep one file if the split pushes total lines up.
- Replace the 15 repeated `@if [ -f ... ]` guards with one helper recipe; drive `dump-all`/`restore-all` from a single list instead of two hand-maintained dependency lists.
- Add `just doctor`: render every `.tmpl` for all four platforms, check the personal-path guard, and report which managed files differ.

### 7.11 Public-repo hygiene

- Hard rule: no `/home/<user>`, `/Users/<user>`, or `C:/Users/<user>` in active config values.
- Derive home paths from `.chezmoi.homeDir`/`$HOME`/`$env:USERPROFILE` in templates.
- CI grep guard fails the build on reappearance; the rule is documented in `docs/CONTRIBUTING` or the README.
- Keep the existing safe-by-default SSH config; no keys are committed.

### 7.12 CI and docs

- GitHub Actions matrix: `ubuntu-latest` (linux), `macos-latest` (macos), `windows-latest` (windows), plus a WSL job on the Windows runner (`wsl -- Ubuntu -e sh -c ...`) for the `wsl` render.
- Per job: install chezmoi + just, `chezmoi --source . managed`, apply into a throwaway `--destination`, then lint (`markdownlint-cli2`, `taplo`, `editorconfig-checker`) and the path guard.
- Docs: `README.md` becomes the landing page with a compatibility matrix, four quick-start blocks, and a source-tree map; `docs/macos.md`, `docs/linux.md`, `docs/wsl.md`, `docs/windows.md` hold platform detail; existing `docs/neovim/` and `docs/wsl/HOST_SERVICES_ACCESS.md` are folded in or linked.

### 7.13 Deletions (target state)

`applications.json`, `komorebi.json`, `komorebi.bar.json`, `dot_config/whkdrc`, LazyVim `example.lua`, the commented `komorebi_workspaces` widget, the one-shot Windows Terminal patch, duplicate Alacritty/Scooter wrappers (one side only), empty ignore sections, redundant ignore entries, and commented-out config blocks in `zshrc`, `options.lua`, VS Code settings, and keybindings.

## 8. Migration Plan (no broken window)

Each phase ends with `chezmoi --source . diff` + `apply` on Windows and WSL and a commit that still applies cleanly.

0. **Land existing work.** Commit or stash the 8 in-flight modified files (`Code/User/*`, `options.lua.tmpl`, `snacks.lua.tmpl`, PowerShell profile, YASB, GlazeWM) so the refactor starts from a clean tree.
1. **Foundations.** Add `helpers/platform.tmpl` + `is_wsl.tmpl`; migrate the two inline WSL checks; rewrite `.chezmoiignore.tmpl` as the data-driven map with an identical rendered result (verify with `chezmoi ignored` before/after).
2. **Delete dead weight.** Komorebi stack + package entry + ignore entries + `example.lua` + commented alternatives. Pure deletion, no behavior change.
3. **Consolidate.** Shared theme tokens, shared tmux template, Alacritty/Scooter duplicate removal, VS Code templating on `platform`, personal-path cleanup.
4. **Windows Terminal.** Land the managed `settings.json` template and remove `run_once_12` in the same commit so the font never regresses.
5. **Packages + bootstrap.** Move `pkgs/` into `unix/` and `windows/`, thin the installers, add `just bootstrap-*` and `just doctor`.
6. **CI + docs.** Add the matrix workflow, path guard, per-platform docs, README rewrite.
7. **Verification.** Run the full matrix, apply on all four environments, confirm `just doctor` is clean, tag or note the milestone in the README.

Ordering rationale: foundations first so later template edits have one branching primitive; deletions before consolidations to avoid refactoring files that are about to disappear; packages and CI last because they validate everything else.

## 9. Acceptance Criteria

- `chezmoi --source . managed` and `ignored` produce identical output before and after Phase 1 (no accidental applicability change).
- All four platforms apply with exit 0 in CI, from a clean `--destination`.
- Zero matches for `/home/<user>`, `/Users/<user>`, `C:/Users/<user>` in active config values; CI guard enforces it.
- No references to Komorebi anywhere except the changelog/history docs.
- One source file per terminal theme and per tmux config; changing a token or keybinding propagates to all targets in a single apply.
- `pkgs/` has exactly two platform subdirectories; every manifest is reachable from a `just restore-*` recipe and no package is owned by two managers.
- `pkgs/windows/winget` contains no `komorebi` or `whkd` entries, and `just bootstrap-windows` installs GlazeWM and YASB.
- Installers contain no package lists beyond their bootstrap trio; `just bootstrap` restores the rest.
- Total config/code line count decreases by at least 3,800 lines (Komorebi 3,465 + dead LazyVim 193 + comment/dead-block cleanup), with no feature removal beyond the retired tiler.
- README contains a compatibility matrix and links to all four platform docs.

## 10. Risks and Mitigations

| Risk | Mitigation |
|---|---|
| Windows Terminal overwrites managed `settings.json` | Pin GUIDs, document "edit the template", rely on `chezmoi diff` to surface drift; keep a backup documented in `docs/windows.md` |
| psmux rejects tmux directives (or vice versa) | Guard every non-shared directive by `platform`; smoke-test both binaries in CI where available |
| `kernel.osrelease` missing on non-Linux hosts | Helper guards with `if eq .chezmoi.os "linux"` before access; render check covers all four |
| Brace-glob ignores depend on chezmoi behavior | Replace with explicit per-line lists rendered by template; a rendered `ignored` diff catches regressions |
| Moving `pkgs/` breaks README/Justfile paths | Move + update recipes in one commit; `just doctor` checks manifest existence |
| WSL job unavailable on Windows runner | Fall back to a Docker Linux job with a stubbed `kernel.osrelease` for the WSL render, documented in the workflow |
| Deleting Komorebi removes a fallback tiler | Git history preserves it; note in `docs/windows.md` how to retrieve it |

## 11. Resolved Decisions

The five questions left open in the first draft are now decided. Each decision is grounded in repository evidence and the interview answers, and is reflected in the sections above.

### 11.1 Windows bootstrap installs GlazeWM and YASB (autostart stays manual)

`just bootstrap-windows` restores the full winget export, which already contains `glzr-io.glazewm` and `AmN.yasb`. Enabling them at login is documented, not scripted: startup entries for packaged MSIX apps are not reliably scriptable, and a public dotfiles repo should not turn on a tiling WM without the user's intent. `docs/windows.md` gets a three-step "enable tiling" section (install → autostart → reload config).

### 11.2 No archived manifests; delete duplicates instead

There is no `pkgs/*/archived/` tier, because a folder of things nobody restores is the opposite of "fewer files and lines". Manifests stay only if they are active and reachable from a recipe. Concretely, `pkgs/windows-scoop` is deleted: its only entry duplicates `nerd-fonts-NerdFontsSymbolsOnly`, already owned by `pkgs/windows-choco`, so Scoop stops being a supported manager. `mas` and `whalebrew` remain active (macOS is still supported, and their entries are real tools).

### 11.3 Kitty is the macOS primary; Alacritty is the cross-platform fallback

This matches a decade of macOS habit and the interview answer ("from my macOS before I use Kitty most"). Terminal ownership: Kitty primary on macOS; Alacritty primary on native Linux and available in WSL; Windows Terminal primary on Windows with Scooter as its shell wrapper; Ghostty and WezTerm kept and rendered from shared tokens but documented as secondary. No emulator is removed, and the platform matrix in the README states the primary explicitly.

### 11.4 Theme tokens target Catppuccin Mocha

Mocha wins on evidence: `bat` (`dot_config/bat/config:7`), `scooter` (`.chezmoitemplates/scooter/config.toml:9`), `lsd` and `lazygit` externals, and the tmux plugin already use Catppuccin Mocha, while the emulators are the outliers on GitHub Dark High Contrast and Google dark. One palette for terminals and CLI tools removes mixed theming. The emulator switch is an intentional one-time visual change, reversible via a single token file. YASB is excluded and keeps Windows 11 accent colors (rationale in 7.5).

### 11.5 WSL setup never crosses the boundary

Windows applies `.wslconfig` and Windows-side config, then prints `chezmoi init --apply nathanielvarona` for the user to run inside the distro. `just bootstrap-wsl` is defined and documented for execution *inside* WSL. There is no `wsl.exe` package provisioning, no sudo prompt initiated from the host, and no assumption about which distro is installed. This keeps the "two applies, one source of truth" model honest and matches the interview's split-by-concern answer.

### 11.6 Decision log

| # | Question | Decision | Rationale |
|---|---|---|---|
| 1 | Install GlazeWM/YASB automatically? | Yes via winget manifest; autostart manual | Reproducible bootstrap, no silent desktop takeover |
| 2 | Archive unused package managers? | No archived tier; delete duplicates, keep active manifests | Fewer files, single ownership per package |
| 3 | macOS terminal? | Kitty primary, Alacritty fallback | Habit + interview answer, no feature loss |
| 4 | Theme basis? | Catppuccin Mocha semantic tokens, YASB excepted | Majority of tools already Mocha; removes mixed palettes |
| 5 | Windows provisions WSL? | Never; print the in-distro command | Clean boundary, no cross-distro assumptions |

## 12. Appendix: Verification Commands

```sh
# applicability snapshot (before/after Phase 1)
chezmoi --source . managed | sort > /tmp/managed.txt
chezmoi --source . ignored | sort > /tmp/ignored.txt

# render check into a throwaway destination
chezmoi --source . init --apply --destination /tmp/chezmoi-render

# personal-path guard
! grep -rnE "(/home/|/Users/|[A-Za-z]:/Users/)[A-Za-z0-9._-]+" \
  --include="*.tmpl" --include="*.json" --include="*.toml" --include="*.lua" \
  --include="*.conf" --include="*.yaml" . | grep -v "chezmoi.homeDir"

# Windows Terminal template render (Windows runner)
chezmoi execute-template < AppData/Local/Packages/.../settings.json.tmpl | jq .
```

