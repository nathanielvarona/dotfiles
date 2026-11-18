# Design: Cross-Platform Refactor

## Context

See `proposal.md` for why. The relevant constraints:

- This repository is the live chezmoi source on the author's Windows machine; edits apply immediately and must remain applicable at every commit.
- chezmoi maps one source entry to exactly one target, and source entries beginning with `.` are not managed. Two-line wrapper files are therefore sometimes unavoidable.
- Windows-only assets (`AppData/`, `Documents/`) sit at the source root for target-path reasons.
- Nested templates already exist under `.chezmoitemplates/` and are used by Alacritty, Scooter, and platform helpers.
- The current applicability logic is prose in `.chezmoiignore.tmpl`; WSL detection is duplicated in two Lua templates.

## Goals / Non-Goals

**Goals**

- One platform primitive and one applicability map.
- Deletion-first consolidation: fewer files and lines.
- Every platform renderable and verifiable without a full machine.
- Public-repo hygiene enforced mechanically.

**Non-Goals (design-level)**

- No packaging system migration (no Nix/Home Manager).
- No per-emulator feature parity work beyond theming and preservation.
- No restructuring of `dot_config/` into a new top-level hierarchy.
- No secrets manager integration.

## Decisions

### 1. Keep chezmoi-native source naming; rearchitect the routing

The source tree keeps `dot_*` names and flat roots. Platform logic moves into templates rather than new directories.

- **Alternative: `platform/<os>/` trees.** Rejected: chezmoi has no per-OS target mapping, so this would require a mapping layer that duplicates the ignore map and breaks `chezmoi apply` reasoning.
- **Alternative: OS-suffixed filenames.** Rejected: produces more files, not fewer, and still needs the same branching.

### 2. One platform helper, one guard

`helpers/platform.tmpl` returns `windows|wsl|linux|macos`. WSL detection reads `kernel.osrelease` only when `chezmoi.os` is `linux`, because the field is absent elsewhere. `is_wsl.tmpl` and `is_native_unix_like.tmpl` delegate to it.

- **Alternative: keep inline `contains "WSL2"` checks.** Rejected: two copies already exist, and a third platform-specific fix would miss them.

### 3. Applicability as data in `.chezmoiignore.tmpl`

The ignore template defines four path lists and renders them per platform.

- **Alternative: brace globs per platform.** Rejected: opaque, easy to mistype, and cannot express nested exceptions. Explicit per-line lists produce a reviewable diff.
- **Alternative: `.chezmoiignore` files per OS.** Not supported by chezmoi.

### 4. Catppuccin Mocha as the single palette

`theme/colors.tmpl` exposes semantic tokens; each emulator renders them. Mocha is already the palette of `bat`, `lsd`, `lazygit`, Scooter, and the tmux plugin.

- **Alternative: GitHub Dark High Contrast** (current emulator theme). Rejected: it is the minority palette; unifying on it would force more files to change.
- **Alternative: base16 indirection.** Rejected as unnecessary abstraction for one author; tokens are already semantic.

YASB is excluded because it styles Windows 11 chrome; forcing Mocha there produces visual mismatch.

### 5. One multiplexer template with platform guards

Shared bindings live unguarded; mux-specific directives are guarded by the platform value.

- **Alternative: maintain tmux and psmux separately.** Rejected: they have already diverged and share 80% of intent.

### 6. Windows Terminal settings are owned, not patched

The managed template writes the whole `settings.json` with fixed GUIDs. `run_once_12` is deleted.

- **Alternative: merge a fragment on every apply.** Rejected: requires a JSON merge implementation in the apply path and still fights the UI's writes.
- **Alternative: leave unmanaged.** Rejected: the font and theme would keep drifting from the shared tokens.

### 7. Thin installers, `just` as the entry point

Installers install git/curl/chezmoi/just and call `just bootstrap`. Platform recipes own package restoration and apply.

- **Alternative: installers parse `pkgs/`.** Rejected: duplicates parsing logic per shell and keeps two entry points with different behavior.

### 8. Platform-scoped manifests, no archive tier

`pkgs/unix/` and `pkgs/windows/`; duplicate packages are deleted rather than archived. Scoop is removed because its only entry duplicates a Chocolatey font.

- **Alternative: `pkgs/archived/`.** Rejected: unreachable manifests become stale without being deleted.

### 9. No cross-boundary WSL provisioning

Windows applies host config and prints the in-distro command. The distro applies the repository itself with `wsl` as the platform.

- **Alternative: `wsl.exe` provisioning from Windows.** Rejected: requires guessing the distro, escalates privileges across a boundary, and makes two applies implicit.

### 10. CI matrix plus a WSL render

Jobs: Linux, macOS, Windows, and WSL on the Windows runner. Each applies into a throwaway destination and runs lint, the privacy guard, and JSON/TOML parsing. If the runner cannot start a distro, the WSL job falls back to a Linux container with a stubbed kernel release so the `wsl` render is still exercised.

- **Alternative: single Linux job.** Rejected: it cannot catch Windows path or template failures, which are the majority of past breakage.

### 11. Documentation structure

README is the landing page (matrix, four quick starts, tree map). Platform guides live in `docs/` and absorb the existing WSL host-services document.

## Risks / Trade-offs

| Risk | Mitigation |
|---|---|
| Windows Terminal rewrites the managed file | Pin GUIDs, document "edit the template", surface drift with `chezmoi diff`; keep a restore snippet in the Windows guide |
| Terminal palette change surprises the author | One-time, documented in the proposal; revert is a single token file |
| psmux rejects a tmux directive | Guard by platform; validate both renders in CI; smoke-test where binaries exist |
| `kernel.osrelease` access fails off Linux | Helper guards by OS; render matrix covers all four |
| Ignore-map rewrite silently changes applicability | Snapshot `managed`/`ignored` before phase 1 and diff after; identical output is the gate |
| Moving `pkgs/` breaks recipes and docs | Move and update paths in one commit; `just doctor` checks manifest existence |
| WSL job unavailable in CI | Container fallback with a stubbed kernel release; documented in the workflow |
| Deleting the retired tiler removes a fallback | Git history retains it; the Windows guide explains how to retrieve it |

## Migration Plan

Phased, deletion-first, each phase ending in a clean `chezmoi apply` on Windows and WSL.

0. Commit in-flight work; snapshot applicability.
1. Platform helpers + data-driven ignore map; keep rendered output identical.
2. Delete the retired tiler stack, dead LazyVim sample, and commented alternatives.
3. Theme tokens, shared multiplexer template, wrapper cleanup, VS Code templating, path cleanup.
4. Managed Windows Terminal settings; remove the one-shot patch in the same commit.
5. Package split, thin installers, bootstrap recipes, `just doctor`.
6. CI matrix, privacy guard, documentation rewrite.
7. Full matrix verification.

Rollback: each phase is one commit; reverting a phase restores the previous applicable state because no phase depends on uncommitted target state.

## Open Questions

- Should `just doctor` report package-manifest drift as a warning or a failure? Deferrable; it does not change the specs or task order.
- Which config validators are available for Ghostty and WezTerm in CI? If none, JSON/TOML parse checks apply to the subset that supports them.
