# Tasks

## 1. Baseline and safety

- [ ] 1.1 Commit or stash the eight in-flight modified files and verify `git status --porcelain` is empty
- [ ] 1.2 Snapshot applicability with `chezmoi --source . managed | sort` and `chezmoi --source . ignored | sort` into saved files, and verify the managed count matches the current 358 entries
- [ ] 1.3 Add `openspec` and the refactor planning document to the global ignore section of `.chezmoiignore.tmpl`, then verify `chezmoi --source . managed` no longer lists either

## 2. Platform model

- [ ] 2.1 Add `helpers/platform.tmpl` and `helpers/is_wsl.tmpl`, guard `kernel.osrelease` access behind the Linux OS check, and verify the helper renders `windows` on the current machine
- [ ] 2.2 Reimplement `helpers/is_native_unix_like.tmpl` on top of the platform helper and verify existing external-config templates still render
- [ ] 2.3 Replace the inline WSL checks in `options.lua.tmpl` and `mason.lua.tmpl`, then verify no `kernel.osrelease` or `contains "WSL2"` remains outside the helper
- [ ] 2.4 Rewrite `.chezmoiignore.tmpl` as four path lists rendered per platform, then verify `managed` and `ignored` are identical to the 1.2 snapshots
- [ ] 2.5 Document the four platform values and the one-map rule in `docs/` and verify the new page renders without broken links

## 3. Legacy removal

- [ ] 3.1 Delete `applications.json`, `komorebi.json`, `komorebi.bar.json`, and `dot_config/whkdrc`, then verify `git ls-files` has no matching path
- [ ] 3.2 Remove the retired tiler and hotkey-daemon entries from the Windows manifest and verify `grep -ri komorebi pkgs/` returns nothing
- [ ] 3.3 Delete `dot_config/lazyvim/lua/plugins/example.lua` and verify Neovim starts under LazyVim without it
- [ ] 3.4 Remove commented-out alternatives from `zshrc`, `options.lua`, VS Code settings, and keybindings, then verify no commented block contains a `/home/` or `C:/Users/` path and record the line-count reduction

## 4. Terminals and multiplexer

- [ ] 4.1 Create `theme/colors.tmpl` with the Mocha tokens and font values, then verify it renders and every consumer includes it
- [ ] 4.2 Render Alacritty colors and fonts from tokens, replacing the external theme import, and verify `taplo check` accepts the output
- [ ] 4.3 Render Kitty, Ghostty, and WezTerm from tokens, then verify no literal palette remains in their configs and each file parses with its available validator
- [ ] 4.4 Build the managed Windows Terminal `settings.json` template with pinned GUIDs and token-driven scheme, and verify `jq` parses it and identifiers are unique
- [ ] 4.5 Delete `run_once_12_set_windows_terminal_settings.ps1.tmpl` and verify the Windows Terminal font still comes from the managed template
- [ ] 4.6 Render one multiplexer template into tmux and psmux with platform-guarded directives, then verify each rendered file loads with its binary or, where unavailable, passes a syntax review recorded in the commit
- [ ] 4.7 Document the platform primaries and the YASB palette exception in the Windows and macOS guides, and verify the statements match the applied configuration

## 5. Editors and shells

- [x] 5.1 Convert VS Code user settings to a per-platform template, remove commented path variants, and verify each platform render parses as JSONC
- [ ] 5.2 Scope WSL editor keys to the WSL render and verify Windows, macOS, and native Linux renders do not contain them
- [ ] 5.3 Deduplicate the PowerShell module bootstrap into one helper, then verify a profile load with an optional module absent exits 0
- [ ] 5.4 Register the Clink targets in the platform map and verify `chezmoi ignored` includes them on WSL and excludes them on Windows
- [ ] 5.5 Confirm LazyVim platform branches use the helper and verify Neovim starts on Windows and WSL

## 6. Windows desktop and WSL

- [ ] 6.1 Confirm GlazeWM and YASB remain in the Windows manifest and that the bootstrap installs them; verify with `just --dry-run bootstrap-windows`
- [ ] 6.2 Add the "enable tiling at login" manual steps to the Windows guide and verify each command runs as written
- [ ] 6.3 Verify the Windows bootstrap prints, but does not execute, the in-distro command, and that no `wsl.exe` provisioning exists
- [ ] 6.4 Keep `.wslconfig` Windows-only and add the host/distro ownership table to the WSL guide, verifying it matches the applied targets

## 7. Packages and bootstrap

- [ ] 7.1 Move manifests into `pkgs/unix/` and `pkgs/windows/`, update every path reference, and verify `just --list` and the doctor check resolve them
- [ ] 7.2 Delete `pkgs/windows-scoop`, confirm the Nerd Font Symbols package is owned by Chocolatey, and verify no Scoop restore recipe remains
- [ ] 7.3 Reduce `install.sh` and `install.ps1` to the bootstrap set plus a `just bootstrap` call, and verify each script contains no other package IDs
- [ ] 7.4 Add `bootstrap-macos`, `bootstrap-linux`, `bootstrap-wsl`, and `bootstrap-windows` recipes, and verify each dry-run lists the expected restore and apply steps
- [ ] 7.5 Collapse the repeated dump/restore guards and drive the aggregate recipes from one manager list, verifying the recipe count and line count both drop
- [ ] 7.6 Add `just doctor` covering template rendering, manifest existence, and the privacy check, and verify it exits non-zero on a deliberately broken input

## 8. CI and documentation

- [ ] 8.1 Add the GitHub Actions matrix for Linux, macOS, Windows, and WSL with throwaway-destination applies, and verify the workflow passes `actionlint`
- [ ] 8.2 Add the personal-path guard to CI and verify it fails on a planted path and passes once removed
- [ ] 8.3 Wire linting for Markdown, TOML, and editorconfig into the matrix and verify each linter runs on its platform
- [ ] 8.4 Rewrite the README with the compatibility matrix, four quick starts, and a source-tree map, and verify all links resolve
- [ ] 8.5 Write `docs/macos.md`, `docs/linux.md`, `docs/wsl.md`, and `docs/windows.md`, folding in the existing WSL host-services content, and verify every documented command matches the scripts
- [ ] 8.6 Update the repository tree map to explain why Alacritty/Scooter wrappers exist on both sides and verify the explanation matches the final file layout

## 9. Integration verification

- [ ] 9.1 Run the full CI matrix on a branch and verify all four jobs pass
- [ ] 9.2 Apply on Windows and WSL and verify `chezmoi diff` is clean after apply
- [ ] 9.3 Confirm the config/code line count dropped by at least 3,800 lines from the 17,324-line baseline and no emulator or unsupported tool was removed
- [ ] 9.4 Verify `just doctor` passes on a clean checkout and fails on the planted-path case

## 10. LazyVim and Windows desktop improvements

- [ ] 10.1 Remove disabled and dead plugin specs (`example.lua`, `forced-immersion.lua`, `camouflage.lua`, `neo-tree.lua`) and verify Neovim starts cleanly
- [x] 10.2 Guard `image.nvim` so it does not load on native Windows while remaining enabled on WSL2
- [ ] 10.3 Consolidate the indentation stack into one implementation and verify indentation guides render once
- [ ] 10.4 Remove stale commented-out configuration from `lspconfig.lua`, `options.lua.tmpl`, and `colorscheme.lua`
- [ ] 10.5 Remove or document the native-Linux Mason disable in `mason.lua.tmpl`
- [ ] 10.6 Remove startup notification noise from `vscode.lua.tmpl`
- [ ] 10.7 Remove empty `autocmds.lua` until custom autocmds are needed
- [x] 10.8 Capture and verify the PowerToys DSC v3 snapshot, including the non-Windows ignore rule

## Workflow follow-up

- Archive this change with OpenSpec after review, which promotes the delta specs into `openspec/specs/`.
- Verify the archived specs and update the README compatibility matrix if the merge changed any platform claim.
