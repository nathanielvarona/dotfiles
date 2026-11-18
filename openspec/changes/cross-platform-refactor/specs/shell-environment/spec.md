# Spec Delta

## Purpose

Provides a consistent interactive shell and prompt on every platform, including a supported CMD experience on Windows, without requiring per-machine edits.

## ADDED Requirements

### Requirement: Unix interactive shell is zsh

macOS, native Linux, and WSL SHALL use zsh as the interactive shell, with the same managed aliases and PATH semantics. Applying on those platforms MUST NOT create or modify PowerShell profile targets.

#### Scenario: Apply on WSL

- **GIVEN** an apply runs in a WSL distro
- **WHEN** the resulting home directory is inspected
- **THEN** the zsh configuration is present and no PowerShell profile is installed

#### Scenario: Apply on macOS

- **GIVEN** an apply runs on macOS
- **WHEN** a new zsh session starts
- **THEN** the managed aliases, prompt, and PATH additions are active

### Requirement: PowerShell 7 is the Windows primary shell

Windows SHALL use PowerShell 7 as the primary interactive shell and load the managed profile idempotently. A missing optional module or command MUST NOT abort profile loading or change the exit status of a normal shell start.

#### Scenario: Optional module unavailable

- **GIVEN** a PowerShell 7 session on Windows where an optional module is not installed
- **WHEN** the managed profile loads
- **THEN** the shell starts with exit status 0 and reports no terminating error

#### Scenario: Repeated profile load

- **GIVEN** the managed profile has already been loaded in a session
- **WHEN** it is dot-sourced again
- **THEN** no duplicate command-not-found errors or duplicate PATH entries are produced

### Requirement: CMD remains supported through Clink

CMD SHALL remain a supported secondary shell on Windows through Clink, providing the managed prompt, command history, and tool PATH. Removing or bypassing Clink MUST be documented as dropping CMD support.

#### Scenario: Opening CMD

- **GIVEN** Clink is installed with the managed configuration
- **WHEN** a user opens CMD
- **THEN** the managed prompt appears and managed CLI tools resolve from PATH

#### Scenario: Clink not installed

- **GIVEN** Clink is absent on a Windows machine
- **WHEN** CMD is opened
- **THEN** Windows still starts, and the documentation states that CMD prompt customization is unavailable

### Requirement: Environment values are derived, not hardcoded

Environment variables and tool paths SHALL be derived from the resolved platform and home directory. Hooks for optional tools MUST degrade gracefully when the tool is absent.

#### Scenario: Optional tool absent

- **GIVEN** a shell where an optional tool referenced by the managed profile is not installed
- **WHEN** the profile loads
- **THEN** startup completes without an error banner and other aliases still work

#### Scenario: Home directory differs

- **GIVEN** the repository is applied to an account whose username differs from the author's
- **WHEN** the shell profiles are rendered
- **THEN** all paths resolve under that account's home directory
