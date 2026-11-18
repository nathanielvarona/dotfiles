# Spec Delta

## Purpose

Treats WSL2 as a first-class environment with a clean boundary between the Windows host and the Linux distro, so each side is configured explicitly and nothing is provisioned implicitly.

## ADDED Requirements

### Requirement: Host and distro configuration do not cross the boundary

The Windows apply SHALL NOT execute commands inside a WSL distro. It MUST configure only Windows-side artifacts and may print, but not run, the command required inside the distro.

#### Scenario: Windows bootstrap on a machine with WSL

- **GIVEN** a Windows bootstrap runs on a machine with at least one WSL distro
- **WHEN** the bootstrap completes
- **THEN** no command was executed inside the distro and the user is shown the exact in-distro apply command

#### Scenario: No distro installed

- **GIVEN** a Windows machine without WSL enabled
- **WHEN** the Windows bootstrap runs
- **THEN** it completes without error and does not attempt to install a distribution

### Requirement: Windows owns host-side WSL configuration

WSL host configuration, including networking mode, SHALL be managed from the Windows side as a Windows-only target. macOS, native Linux, and the distro itself MUST NOT manage or modify it.

#### Scenario: Applying on Windows

- **GIVEN** an apply runs on Windows
- **WHEN** the WSL host configuration is inspected
- **THEN** the managed networking mode is present and matches the documented value

#### Scenario: Applying inside the distro

- **GIVEN** an apply runs inside WSL
- **WHEN** the target tree is inspected
- **THEN** no Windows `.wslconfig` equivalent is written

### Requirement: The distro applies the repository itself

The documented WSL setup SHALL have the user clone and apply the same repository inside the distro, producing the `wsl` platform value. Documentation MUST state that two applies (host and distro) are expected and describe what each owns.

#### Scenario: Following the WSL guide

- **GIVEN** a user follows the WSL platform guide from a fresh distro
- **WHEN** they reach the end
- **THEN** the distro has the Linux-side configuration applied with `wsl`-specific overrides and the guide names the host/distro split

#### Scenario: Re-applying after a repository update

- **GIVEN** a distro already configured from the repository
- **WHEN** the user pulls and applies again
- **THEN** the update applies cleanly without repeating host-side steps

### Requirement: WSL overrides are scoped to WSL

Clipboard bridging, image rendering, browser opening, and editor remote integration SHALL be enabled only where the platform value is `wsl`. A native Linux apply MUST NOT receive these overrides.

#### Scenario: Clipboard in native Linux

- **GIVEN** a native Linux apply
- **WHEN** terminal and Neovim clipboard configuration is rendered
- **THEN** no Windows clipboard bridge appears and the native provider is used

#### Scenario: Browser opening in WSL

- **GIVEN** a WSL apply
- **WHEN** a command opens a URL
- **THEN** it uses the documented host-browser path rather than failing silently
