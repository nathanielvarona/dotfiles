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

### Requirement: LazyVim has no disabled or dead plugin specs

Disabled plugin specs SHALL NOT remain as active files under `lua/plugins/`. Specs that are intentionally disabled MUST be removed rather than retained behind `if true then return {} end`.

#### Scenario: Loading the plugin directory

- **GIVEN** Neovim starts with the managed LazyVim configuration
- **WHEN** the `lua/plugins` directory is imported
- **THEN** no disabled or starter-example plugin spec is loaded

### Requirement: LazyVim plugins respect platform support

Plugins that do not support a platform SHALL be guarded so they do not load on that platform. Platform guards SHALL be explicit and SHALL NOT rely on runtime errors.

#### Scenario: Native Windows Neovim

- **GIVEN** Neovim runs on native Windows
- **WHEN** the managed plugin specs are loaded
- **THEN** `image.nvim` is not loaded and no unsupported terminal-size error is raised

#### Scenario: WSL Neovim

- **GIVEN** Neovim runs inside WSL2
- **WHEN** the managed plugin specs are loaded
- **THEN** `image.nvim` remains enabled for the working ImageMagick/FFmpeg setup

### Requirement: LazyVim uses one indentation implementation

The configuration SHALL use a single indentation/highlight implementation. Conflicting indentation plugins SHALL NOT be enabled together.

#### Scenario: Rendering indentation

- **GIVEN** a source buffer is opened in Neovim
- **WHEN** indentation guides are rendered
- **THEN** exactly one indentation plugin is active and no duplicate highlight definitions are applied
