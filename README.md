# dotfiles

My Dotfiles Collection

## Features

- A collection of dotfiles for easy setup and configuration of my development environment
- Managed using GNU `stow` to symlink dotfiles to my home directory `~/` or `$HOME`
- Handy scripts for installing packages and development toolings

## Demos

### Zinit Initial Load

<a href="https://asciinema.org/a/666761?autoplay=1&loop=1">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./doc/img/demo/zinit-dark.gif" />
    <img alt="Zinit Initial Load" src="./doc/img/demo/zinit-light.gif" />
  </picture>
</a>

## Quick Setup

```bash
# Clone the Dotfiles
git clone https://github.com/nathanielvarona/dotfiles.git \
  dotfiles && cd dotfiles

# Stow
stow --stow --verbose .

# Unstow
stow --delete --verbose .

# Restow (like Unstow followed by Stow)
stow --restow --verbose .
```

> [!TIP]
> Use the GNU `stow` option `--simulate` for dry run and evalute possible changes before the real one.

## Packages Installation

### Homebrew Packages

> [!NOTE]
> Brewfiles are organized into different dependency files `Taps`, `Formulae`, `Casks`, `Mac App Store (MAS)`, and `VSCode Extensions`.

Install Packages

1. Taps (Sources)

```bash
brew bundle install --no-lock \
  --file ./taps.Brewfile
```

2. Brews (Formulae)

```bash
brew bundle install --no-lock \
  --file ./formulae.Brewfile
```

3. Casks (GUI macOS applications)

```bash
brew bundle install --no-lock \
  --file ./casks.Brewfile
```

4. MAS (Mac App Store)

```bash
brew bundle install --no-lock \
  --file ./mas.Brewfile
```

5. VSCode (Extensions)

```bash
brew bundle install --no-lock \
  --file ./vscode.Brewfile
```

5. Whalebrew (Containerized Apps)

```bash
brew bundle install --no-lock \
  --file ./whalebrew.Brewfile
```

<details>
  <summary>Dump Existing Packages to File</summary>

```bash
make brewfile

# Specific Brew Dependency Dumps
make brewfile-taps
make brewfile-formulae
make brewfile-casks
make brewfile-mas
make brewfile-vscode
make brewfile-whalebrew
```

</details>

### ASDF Plugins

Installation of Plugins

```bash
egrep -v '^(;|#|//)' ./asdf-plugins |
  xargs -I {} asdf plugin add {}
```

<details>
  <summary>Dump Existing Plugins to File</summary>

```bash
asdf plugin list > ./asdf-plugins
```

</details>

### Pyenv Versions (Python Version Manager)

Build and Install Python Versions from Source

```bash
egrep -v '^(;|#|//)' ./pyenv-versions |
  xargs -I {} pyenv install {}
```

<details>
  <summary>Dump Existing Versions to File</summary>

```bash
pyenv versions --bare --skip-aliases --skip-envs > ./pyenv-versions
```

</details>

### pipx Apps (Python Applications in Isolated Environments)

Installation of Python Apps

```bash
awk '{print $1}' ./pipx-apps |
  egrep -v '^(;|#|//)' |
    xargs -I {} pipx install {}
```

<details>
  <summary>Dump Existing Apps to File</summary>

```bash
pipx list --short > ./pipx-apps
```

</details>

### Krew Plugins

Install Krew Plugins

```bash
awk 'NR > 1 {print $1}' ./krew-plugins |
  egrep -v '^(;|#|//)' |
    xargs -I {} krew install {}
```

<details>
  <summary>Dump Existing Plugins to File</summary>

```bash
krew list > ./krew-plugins
```

</details>

### Helm Repos

Add the Helm Repositories

```bash
awk 'NR > 1 {split($0, ri, " "); print ri[1] " " ri[2]}' ./helm-repos |
  egrep -v '^(;|#|//)' |
    xargs -n 2 helm repo add
```

<details>
  <summary>Dump Existing Repositories to File</summary>

```bash
helm repo list > ./helm-repos
```

</details>

### Perl Packages

Install CPANM using CPAN

```bash
cpan App::cpanminus
```

Use the CPANM to Install Module/Tool from the `cpanfile`

```bash
cpanm --installdeps ./
```

### Ollama Models

Dump Model List

```bash
ollama list |
  awk 'NR > 1 { print $1 }' > ./ollama-models
```

Pull Models

```bash
egrep -v '^(;|#|//)' ./ollama-models |
  xargs -I {} ollama pull {}
```

### Hugging Face Models

Download Models

```bash
while IFS= read -r model_name; do
  repo_id="$(echo ${model_name%% *} | tr -d '[:blank:]')"
  filename="$( echo ${model_name#* } | tr -d '[:blank:]')"
  huggingface-cli download "$repo_id" "$filename"
done < <(awk 'NR > 1' ./hugging-face-models | egrep -v '^(;|#|//)')
```

### GNU Pretty Good Privacy (PGP) package and Password manager

Passphrase entry dialog utilizing the Assuan protocol

```bash
defaults write org.gpgtools.common UseKeychain false
```

### Shell Scripts Linting and Formatting

To ensure consistency and cleanliness, use:

- Run `editorconfig-checker` to check for EditorConfig errors
- Run `shfmt --indent 2 --write ./<path>/<to>/<script>.sh` to format shell scripts

## Troubleshooting

Clearout the Powerlevel10k instant prompt Cache

```bash
rm -Rf $HOME/.cache/p10k-*
```

Clearout the Completation Cache from ZSH

```bash
rm -f $HOME/.zcompdump && exec $SHELL -l
```

Nuke Zinit (Total Reset the Zinit Configuration for Rebuild)

```bash
rm -Rf $HOME/.local/share/zinit $HOME/.cache/zinit
```

Reset LazyVim (NeoVim) Cache

```bash
rm -Rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```

## Tooling History

For toolings that I actively use and being deleted or archived.

| Tools                                                                          | Status     | Description                                        | Actively Use, and Future Changes              |
| ------------------------------------------------------------------------------ | ---------- | -------------------------------------------------- | --------------------------------------------- |
| `iTerm2`, `Alacritty`, `Kitty`                                                 | ❌ Deleted | Less Customizable                                  | `Wezterm`                                     |
| `Zellij`                                                                       | ❌ Deleted | Prefer Native Terminal Multiplexer                 | `Tmux`                                        |
| `Oh My Zsh` (ZSH Config Framework), `zplug`, `Antigen`, `Antibody`, `antidote` | ❌ Delete  | Prefer Actively Maintain                           | `Zinit`                                       |
| `RVM`                                                                          | ❌ Deleted | Compiling Issues                                   | `rbenv`                                       |
| `NVM`                                                                          | ❌ Deleted | Compiling Issues                                   | `fnm`                                         |
| `Pyenv`                                                                        | ✅ Active  | Use for Some Cases                                 | `Poetry` and `venv` (Python Standard Library) |
| `VSCode`                                                                       | ✅ Active  | Use while mastering Vim Motion and Desired Plugins | `NeoVim` (with `LazyVim` Framework)           |
