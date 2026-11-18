# Spec Delta

## Purpose

Defines the supported Windows desktop surface (tiling manager, status bar, shell wrapper) and guarantees that retired desktop tooling no longer ships.

## ADDED Requirements

### Requirement: GlazeWM and YASB are the supported desktop stack

The Windows bootstrap SHALL install GlazeWM and YASB from the Windows package manifest. Enabling them at login SHALL be a documented manual step, not an automatic side effect of applying dotfiles.

#### Scenario: Fresh Windows bootstrap

- **GIVEN** a Windows machine that has the bootstrap prerequisites
- **WHEN** the Windows bootstrap completes
- **THEN** GlazeWM and YASB are installed, and the documentation explains how to enable them at login

#### Scenario: Applying on a machine without GlazeWM

- **GIVEN** dotfiles are applied on a Windows machine where GlazeWM is not installed
- **WHEN** the apply finishes
- **THEN** no startup entry was created automatically and the machine remains usable

### Requirement: No retired tiling manager remains

No Komorebi configuration, hotkey daemon configuration, or Komorebi package SHALL remain in the repository or in any package manifest. The retired tiler MUST NOT be referenced outside historical documentation.

#### Scenario: Searching the repository

- **GIVEN** the repository at the completed change
- **WHEN** it is searched for the retired tiling manager's name
- **THEN** no configuration file, package entry, or active reference matches

#### Scenario: Restoring Windows packages

- **GIVEN** a fresh Windows restore from the package manifest
- **WHEN** the installed packages are listed
- **THEN** neither the retired tiler nor its hotkey daemon is installed

### Requirement: Windows desktop assets never reach other platforms

GlazeWM, YASB, Scooter, and Clink targets SHALL be applied only on Windows. macOS, Linux, and WSL applies MUST leave those paths untouched.

#### Scenario: Applying in WSL

- **GIVEN** an apply runs inside WSL
- **WHEN** the home directory is inspected
- **THEN** no `.glzr`, YASB, Scooter, or Clink configuration exists

#### Scenario: Applying on macOS

- **GIVEN** an apply runs on macOS
- **WHEN** the home directory is inspected
- **THEN** no Windows desktop configuration exists and AeroSpace remains the only tiling manager
