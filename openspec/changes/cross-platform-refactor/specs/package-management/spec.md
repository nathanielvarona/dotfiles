# Spec Delta

## Purpose

Keeps installed tooling reproducible on every platform through platform-scoped manifests, single package ownership, and bootstrap entry points that do not duplicate those manifests.

## ADDED Requirements

### Requirement: Package manifests are split by platform

Package manifests SHALL live under a Unix tree and a Windows tree, and each manifest MUST be reachable from a restore recipe for its platform. A manifest with no restore path MUST NOT remain in the repository.

#### Scenario: Listing manifests

- **GIVEN** the completed change
- **WHEN** the package directory is listed
- **THEN** only the Unix and Windows platform directories contain manifests

#### Scenario: Restoring a platform

- **GIVEN** a machine of a supported platform
- **WHEN** that platform's restore recipe runs
- **THEN** every manifest for that platform is applied

### Requirement: Each package has one owner

A package SHALL be declared by exactly one manager. When two manifests list the same tool, the duplicate MUST be removed and ownership assigned to one manager.

#### Scenario: Duplicate font package

- **GIVEN** the Windows manifests are inspected for Nerd Font packages
- **WHEN** the package lists are compared
- **THEN** the symbol font is declared by one manager only and the duplicate manager manifest is gone

#### Scenario: Adding a new tool

- **GIVEN** a contributor adds a tool already provided by another manager
- **WHEN** the change is reviewed
- **THEN** the duplicate is rejected or the existing owner is updated instead

### Requirement: Installers are thin bootstraps

The platform installers SHALL install only the tools required to run chezmoi and the task runner, then delegate to the platform bootstrap recipe. Installers MUST NOT maintain their own package lists beyond that bootstrap set.

#### Scenario: Reading the Unix installer

- **GIVEN** the Unix installer is inspected
- **WHEN** its package installs are counted
- **THEN** only the bootstrap tools appear and the bootstrap recipe is invoked afterward

#### Scenario: Adding a tool to a manifest

- **GIVEN** a tool is added to a platform manifest
- **WHEN** a new machine of that platform is bootstrapped
- **THEN** the tool is installed without editing the installer

### Requirement: Bootstrap exists for every platform

A bootstrap entry point SHALL exist for macOS, native Linux, WSL, and Windows. Each MUST restore that platform's packages, apply the chezmoi configuration, and report the steps it skipped or could not perform.

#### Scenario: Running a platform bootstrap

- **GIVEN** a supported platform
- **WHEN** its bootstrap recipe runs to completion
- **THEN** packages are restored, configuration is applied, and skipped steps are reported

#### Scenario: WSL bootstrap location

- **GIVEN** the Windows bootstrap prints the WSL instructions
- **WHEN** the user runs them inside the distro
- **THEN** the WSL bootstrap performs the Linux-side restore and apply

### Requirement: Manifests follow dump, commit, restore

Package manifests SHALL be generated from the active machine, committed with the configuration change, and restorable on a fresh machine. Restore MUST NOT require manual editing between those steps.

#### Scenario: Capturing a new tool

- **GIVEN** a tool is installed interactively on a supported machine
- **WHEN** the dump recipe runs and the result is committed
- **THEN** a fresh machine can restore that tool from the committed manifest
