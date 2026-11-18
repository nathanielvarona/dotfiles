# Spec Delta

## Purpose

Delivers editor configuration that is correct on every platform, with settings that do not assume one operating system's tool paths.

## ADDED Requirements

### Requirement: VS Code settings are rendered per platform

VS Code user settings SHALL be generated from a template that selects tool paths, terminal profiles, and integrations for the resolved platform. No rendered settings value may contain a hardcoded user home path.

#### Scenario: Rendering on Windows

- **GIVEN** the VS Code settings template is rendered for Windows
- **WHEN** the file is parsed
- **THEN** it is valid JSON with comments and tool paths resolve under the Windows home directory

#### Scenario: Rendering on WSL

- **GIVEN** the VS Code settings template is rendered for WSL
- **WHEN** the terminal profile and tool path values are inspected
- **THEN** they reference the Linux-side tools and the configured tmux profile

#### Scenario: Rendering on macOS

- **GIVEN** the VS Code settings template is rendered for macOS
- **WHEN** tool path values are inspected
- **THEN** they reference Homebrew or macOS locations rather than Linux paths

### Requirement: WSL editor integration is WSL-only

WSL-specific editor behavior, including remote mode and distribution selection, SHALL be enabled only in the WSL render. Windows, macOS, and native Linux renders MUST NOT enable it.

#### Scenario: Comparing renders

- **GIVEN** the Windows and WSL renders of the settings
- **WHEN** the WSL integration keys are inspected
- **THEN** they are enabled only in the WSL render

### Requirement: LazyVim configuration is shared and free of starter samples

The LazyVim configuration SHALL apply on all four platforms from one source, with platform differences expressed through the platform helper. Disabled starter sample plugins MUST NOT remain in the source.

#### Scenario: Starting Neovim on each platform

- **GIVEN** the repository is applied on Windows, WSL, Linux, and macOS
- **WHEN** Neovim starts with the managed configuration
- **THEN** LazyVim loads on each platform without the disabled example plugin

#### Scenario: WSL-specific clipboard

- **GIVEN** Neovim runs inside WSL
- **WHEN** a yank is performed
- **THEN** the Windows clipboard bridge is used, while native Linux uses its own provider
