# dotfiles

My Dotfiles Collection

## Features

* A collection of dotfiles for easy setup and configuration of my development environment
* Managed using GNU `stow` to symlink dotfiles to my home directory `~/` or `$HOME`
* Handy scripts for installing packages and development toolings

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
  ~/.dotfiles && cd ~/.dotfiles

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

Install Packages

```bash
brew bundle install \
  --file ./Brewfile
```

> [!NOTE]
> Brewfile includes `Formulae`, `Casks`, `Mac App Store (MAS)`, and `VSCode Extensions`. 

<details>
  <summary>Dump Existing Packages to File</summary>

  ```bash
  brew bundle dump --no-lock --describe \
    --force --file ./Brewfile
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
egrep -v '^(;|#|//)' ./pipx-apps | 
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
  awk 'NR>1 { print $1 }' > ./ollama-models
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
  repo_id="${model_name%% *}"
  filename="${model_name#* }"
  huggingface-cli download "$repo_id" "$filename"
done < <(egrep -v '^(;|#|//)' ./hugging-face-models)
```

### GNU Pretty Good Privacy (PGP) package and Password manager

Passphrase entry dialog utilizing the Assuan protocol

```bash
defaults write org.gpgtools.common UseKeychain false
```

### Shell Scripts Linting and Formatting

To ensure consistency and cleanliness, use:

* Run `editorconfig-checker` to check for EditorConfig errors
* Run `shfmt --indent 2 --write ./<path>/<to>/<script>.sh` to format shell scripts

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

```
rm -Rf $HOME/.local/share/zinit $HOME/.cache/zinit
```
