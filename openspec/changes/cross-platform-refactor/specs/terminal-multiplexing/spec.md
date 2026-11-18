# Spec Delta

## Purpose

Keeps one multiplexer configuration as the single source of truth for both tmux on Unix-like systems and psmux on Windows.

## ADDED Requirements

### Requirement: One configuration for tmux and psmux

The multiplexer configuration SHALL be defined in one template and rendered to both the tmux target on macOS, Linux, and WSL and the psmux target on Windows. Neither target may be hand-maintained separately.

#### Scenario: Changing a keybinding

- **GIVEN** a shared keybinding is edited in the template
- **WHEN** the repository is applied on Windows and on WSL
- **THEN** both the psmux and tmux configurations reflect the change

#### Scenario: Adding a window option

- **GIVEN** a shared option is added to the template
- **WHEN** both rendered configurations are inspected
- **THEN** the option appears in each unless it is deliberately platform-guarded

### Requirement: Directives are platform-guarded

A directive supported by only one multiplexer MUST be wrapped in a platform guard, so tmux never receives a psmux-only directive and psmux never receives an unsupported tmux directive.

#### Scenario: psmux-only feature

- **GIVEN** a feature documented as psmux-only is enabled
- **WHEN** the tmux configuration is rendered on Linux
- **THEN** the directive is absent from the tmux file

#### Scenario: tmux-only feature

- **GIVEN** a feature available only in tmux is configured
- **WHEN** the psmux configuration is rendered on Windows
- **THEN** the directive is absent from the psmux file

### Requirement: Shared behavior is identical across multiplexers

Prefix key, pane and window navigation, status line, and copy-mode behavior SHALL match on every platform wherever both multiplexers support them.

#### Scenario: Comparing navigation

- **GIVEN** tmux on WSL and psmux on Windows
- **WHEN** the same navigation binding is pressed in each
- **THEN** the resulting pane or window action is the same
