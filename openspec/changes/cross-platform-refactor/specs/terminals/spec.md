# Spec Delta

## Purpose

Keeps every configured terminal emulator usable while giving them one palette, one typography source, and a documented primary per platform.

## ADDED Requirements

### Requirement: Every terminal emulator is preserved

Alacritty, Kitty, Ghostty, WezTerm, Windows Terminal, and Scooter SHALL remain configured on their supported platforms. Consolidation MUST NOT remove an emulator or drop a feature it currently provides.

#### Scenario: Applying on macOS

- **GIVEN** an apply runs on macOS
- **WHEN** the terminal configuration is inspected
- **THEN** Kitty, Alacritty, Ghostty, and WezTerm configurations are all present

#### Scenario: Applying on Windows

- **GIVEN** an apply runs on Windows
- **WHEN** the terminal configuration is inspected
- **THEN** Windows Terminal settings and the Scooter wrapper are present alongside Alacritty

### Requirement: Single terminal theme source

Emulator color and typography values SHALL render from one shared token template. Changing a token MUST change every emulator on the next apply, and no emulator configuration may contain an independent literal palette.

#### Scenario: Changing a palette token

- **GIVEN** the shared background token is changed from its current value
- **WHEN** the repository is applied on each platform
- **THEN** every emulator's rendered configuration contains the new value

#### Scenario: No local palette

- **GIVEN** an emulator configuration is searched for literal color definitions
- **WHEN** the search completes
- **THEN** no emulator carries its own hex palette outside the shared token template

### Requirement: Primary emulator per platform is documented

Kitty SHALL be the documented macOS primary, Alacritty the native Linux and WSL primary, and Windows Terminal the Windows primary. Every other preserved emulator MUST be described as secondary rather than unsupported.

#### Scenario: Reading platform documentation

- **GIVEN** a reader opens the platform guide for their OS
- **WHEN** they look for the terminal section
- **THEN** the primary emulator is named and the secondary ones are listed as supported

### Requirement: Windows Terminal is declaratively managed

Windows Terminal's `settings.json` SHALL be managed by chezmoi as a template with stable, explicitly pinned profile identifiers. The one-shot settings patch script MUST be removed, and the rendered file MUST be valid JSON.

#### Scenario: Rendering Windows Terminal settings

- **GIVEN** the template is rendered for Windows
- **WHEN** the output is parsed as JSON
- **THEN** parsing succeeds, every profile identifier is unique, and the PowerShell, CMD, and WSL profiles are present

#### Scenario: Repeated apply

- **GIVEN** the managed settings file is already applied
- **WHEN** the repository is applied again
- **THEN** the file is unchanged and no profile identifiers are regenerated

### Requirement: Palette is Catppuccin Mocha with one documented exception

Terminal emulators and CLI tools SHALL use the Catppuccin Mocha palette. YASB MAY keep Windows 11 accent colors because it renders operating-system chrome rather than terminal content, and this exception MUST be documented.

#### Scenario: Comparing terminals and CLI tools

- **GIVEN** any two managed terminals or CLI tools that render colors
- **WHEN** their rendered palettes are compared
- **THEN** they derive from the same Mocha tokens

#### Scenario: Reviewing the YASB exception

- **GIVEN** a reader inspects the Windows documentation
- **WHEN** they reach the status bar section
- **THEN** the reason YASB does not use the terminal palette is stated
