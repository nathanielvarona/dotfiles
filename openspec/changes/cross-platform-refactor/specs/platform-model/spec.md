# Spec Delta

## Purpose

Assigns every supported machine exactly one platform identity and decides which managed configuration applies there, so the same repository can serve four environments without leaking files across them.

## ADDED Requirements

### Requirement: Single platform identity

A chezmoi render SHALL resolve to exactly one platform value: `windows`, `wsl`, `linux`, or `macos`. Detection MUST live in one reusable helper template, and a Linux kernel reporting Microsoft/WSL MUST resolve to `wsl` rather than `linux`.

#### Scenario: WSL2 host

- **GIVEN** chezmoi runs on Linux whose kernel release contains a Microsoft/WSL marker
- **WHEN** the platform value is resolved
- **THEN** it is `wsl`, not `linux`

#### Scenario: Native Linux host

- **GIVEN** chezmoi runs on Linux without a Microsoft/WSL kernel marker
- **WHEN** the platform value is resolved
- **THEN** it is `linux`

#### Scenario: Non-Linux host

- **GIVEN** chezmoi runs on Windows or macOS
- **WHEN** the platform value is resolved
- **THEN** it is `windows` or `macos` respectively, and no Linux-only kernel field is read

### Requirement: One applicability map

The set of managed paths that apply to each platform MUST be declared once, in a single source-controlled template. Individual configuration files MUST NOT make their own applicability decisions, and adding a platform-specific file MUST require editing only that map.

#### Scenario: Adding a Windows-only file

- **GIVEN** a new Windows-only path is registered in the map
- **WHEN** the source is rendered on macOS, Linux, WSL, and Windows
- **THEN** the path is ignored on the first three and managed on Windows

#### Scenario: Changing which platform owns a file

- **GIVEN** an existing entry moves from the Windows list to the Unix list
- **WHEN** `chezmoi managed` and `chezmoi ignored` are compared
- **THEN** the change is visible in those commands without editing the file itself

### Requirement: No cross-platform leakage

Windows-only assets MUST NOT be applied on macOS, Linux, or WSL, and Unix-only assets MUST NOT be applied on Windows. Repository-only documentation and planning directories MUST NOT be deployed to any home directory.

#### Scenario: Applying inside WSL

- **GIVEN** an apply runs inside a WSL distro
- **WHEN** the target tree is inspected
- **THEN** WinGet-era assets such as `AppData`, `Documents`, YASB, GlazeWM, and psmux are absent

#### Scenario: Applying on Windows

- **GIVEN** an apply runs on Windows
- **WHEN** the target tree is inspected
- **THEN** Unix-only assets such as `.zshenv`, `.MacOSX`, and Unix shell configuration are absent

#### Scenario: Planning files stay in the repository

- **GIVEN** any platform applies the repository
- **WHEN** the home directory is inspected
- **THEN** `openspec/` and refactor planning documents are not present

### Requirement: WSL is distinct from native Linux

Behavior that differs between WSL and native Linux SHALL branch on the `wsl` platform value. Native Linux MUST NOT receive WSL-specific clipboard, browser, networking, or editor integration.

#### Scenario: Clipboard integration

- **GIVEN** a WSL render
- **WHEN** clipboard tooling is configured
- **THEN** the WSL bridge (for example `win32yank`) is used, and a native Linux render does not reference it

#### Scenario: Editor integration

- **GIVEN** the VS Code settings are rendered for each platform
- **WHEN** the WSL render is compared with the native Linux render
- **THEN** only the WSL render enables the WSL-specific editor mode and distribution
