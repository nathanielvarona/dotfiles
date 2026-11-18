# Spec Delta

## Purpose

Makes the claims of cross-platform support checkable in CI and readable for a public audience, including a guard against publishing personal machine details.

## ADDED Requirements

### Requirement: CI renders every supported platform

Continuous integration SHALL render the chezmoi source for Windows, macOS, native Linux, and WSL on every push. Each job MUST fail if the platform's rendering or target application fails.

#### Scenario: Breaking one platform's template

- **GIVEN** a template change that only fails on Windows
- **WHEN** CI runs
- **THEN** the Windows job fails and the pull request is blocked

#### Scenario: WSL rendering

- **GIVEN** a change affecting WSL behavior
- **WHEN** CI runs
- **THEN** a WSL job renders the source with the `wsl` platform value and reports success or failure

### Requirement: Personal machine details are rejected

CI SHALL fail when an active configuration value contains a hardcoded user home path or username pattern. Examples in comments MAY be allowed, but active values MUST derive paths from chezmoi variables or environment.

#### Scenario: Committing a personal path

- **GIVEN** a configuration change adds `/home/<user>` or `C:/Users/<user>` as an active value
- **WHEN** CI runs
- **THEN** the privacy guard fails and names the offending file and line

#### Scenario: Clean configuration

- **GIVEN** the same path is expressed through the home-directory variable
- **WHEN** CI runs
- **THEN** the guard passes

### Requirement: Local verification matches CI

A local task SHALL perform the same rendering, privacy, and lint checks as CI and report a single pass or fail result. It MUST be runnable on the author's primary machine without network access to CI.

#### Scenario: Running local verification

- **GIVEN** a developer runs the verification task locally
- **WHEN** the checks complete
- **THEN** the output lists each check with a pass or fail and returns a non-zero status on failure

#### Scenario: Local passes, CI fails

- **GIVEN** the local checks pass
- **WHEN** the same commit is pushed
- **THEN** CI applies no additional checks beyond environment-specific rendering differences

### Requirement: Documentation has one landing page and per-platform guides

The README SHALL present the compatibility matrix and quick starts for all four platforms, and each platform SHALL have a dedicated guide covering bootstrap, primaries, and platform-specific caveats. Commands in the guides MUST run as written.

#### Scenario: New reader chooses a platform

- **GIVEN** a reader opens the README
- **WHEN** they locate their platform
- **THEN** they find the first command to run and a link to that platform's guide

#### Scenario: Following a guide command

- **GIVEN** a command documented in a platform guide
- **WHEN** it is executed on that platform
- **THEN** it behaves as described, or the guide states the prerequisite that is missing
