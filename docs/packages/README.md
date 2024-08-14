# Packages

## Homebrew Packages

> [!NOTE]
> Brewfiles are organized into different dependency files `Taps`, `Formulae`, `Casks`, `Mac App Store (MAS)`, and `VSCode Extensions`.

Install Packages

1. Taps (Sources)

```bash
brew bundle install --no-lock \
  --file ./packages/taps.Brewfile
```

2. Brews (Formulae)

```bash
brew bundle install --no-lock \
  --file ./packages/formulae.Brewfile
```

3. Casks (GUI macOS applications)

```bash
brew bundle install --no-lock \
  --file ./packages/casks.Brewfile
```

4. MAS (Mac App Store)

```bash
brew bundle install --no-lock \
  --file ./packages/mas.Brewfile
```

5. VSCode (Extensions)

```bash
brew bundle install --no-lock \
  --file ./packages/vscode.Brewfile
```

5. Whalebrew (Containerized Apps)

```bash
brew bundle install --no-lock \
  --file ./packages/whalebrew.Brewfile
```

<details>
  <summary>Dump Existing Packages to File using Makefile</summary>

```bash
# Brew Formulae
brew bundle dump --no-lock --describe --force --file ./packages/formulae.Brewfile --brews

# Brew Casks
brew bundle dump --no-lock --describe --force --file ./packages/casks.Brewfile --casks

# Brew Taps
brew bundle dump --no-lock --describe --force --file ./packages/taps.Brewfile --taps

# Brew MAS
brew bundle dump --no-lock --describe --force --file ./packages/mas.Brewfile --mas

# Brew VSCode
brew bundle dump --no-lock --describe --force --file ./packages/vscode.Brewfile --vscode

# Brew Whalebrew
brew bundle dump --no-lock --describe --force --file ./packages/whalebrew.Brewfile --whalebrew

# Specific Brew Dependency Dumps
make brewfile-taps
make brewfile-formulae
make brewfile-casks
make brewfile-mas
make brewfile-vscode
make brewfile-whalebrew

# Makefile
# All Brew Dependency
make brewfile
```

</details>

### ASDF Plugins

Installation of Plugins

```bash
egrep -v '^(;|#|//)' ./packages/asdf-plugins |
  xargs -I {} asdf plugin add {}
```

<details>
  <summary>Dump Existing Plugins to File</summary>

```bash
asdf plugin list > ./packages/asdf-plugins

# Makefile
make asdf
```

</details>

### Pyenv Versions (Python Version Manager)

Build and Install Python Versions from Source

```bash
egrep -v '^(;|#|//)' ./packages/pyenv-versions |
  xargs -I {} pyenv install {}
```

<details>
  <summary>Dump Existing Versions to File</summary>

```bash
pyenv versions --bare --skip-aliases --skip-envs > ./packages/pyenv-versions

# Makefile
make pyenv
```

</details>

## pipx Apps (Python Applications in Isolated Environments)

Installation of Python Apps

```bash
awk '{print $1}' ./packages/pipx-apps |
  egrep -v '^(;|#|//)' |
    xargs -I {} pipx install {}
```

<details>
  <summary>Dump Existing Apps to File</summary>

```bash
pipx list --short > ./packages/pipx-apps

# Makefile
make pipx
```

</details>

## Krew Plugins

Install Krew Plugins

```bash
awk '{print $1}' ./packages/krew-plugins |
  egrep -v '^(;|#|//)' |
    xargs -I {} krew install {}
```

<details>
  <summary>Dump Existing Plugins to File</summary>

```bash
krew list > ./packages/krew-plugins

# Makefile
make krew
```

</details>

## Helm Repos

Add the Helm Repositories

```bash
awk 'NR > 1 {split($0, ri, " "); print ri[1] " " ri[2]}' ./packages/helm-repos |
  egrep -v '^(;|#|//)' |
    xargs -n 2 helm repo add
```

<details>
  <summary>Dump Existing Repositories to File</summary>

```bash
helm repo list > ./packages/helm-repos

# Makefile
make helm
```

</details>

## Rust / Cargo Packages

Install Cargo Packages

```bash
awk '{print $1}' ./packages/rust-cargo-global-packages |
  egrep -v '^(;|#|//)' |
    xargs -I {} cargo install {}
```

<details>
  <summary>Dump Existing Plugins to File</summary>

```bash
cat ~/.cargo/.crates2.json | jq -r '.installs | keys[] | split(" ")[0]' > ./packages/rust-cargo-global-packages

# Makefile
make rust-cargo
```

</details>

## GitHub CLI Extensions

Install GitHub CLI Extensions

```bash
awk '{print $1}' ./packages/github-cli-extensions |
  egrep -v '^(;|#|//)' |
    xargs -I {} gh extension install {}
```

<details>
  <summary>Dump Existing Extensions to File</summary>

```bash
gh extension list | awk -F'\t' '{print $2}' > $(PACKAGES)/github-cli-extensions

# Makefile
make github-cli-extension
```

</details>

## Perl Packages

Install CPANM using CPAN

```bash
cpan App::cpanminus
```

Use the CPANM to Install Module/Tool from the `cpanfile`

```bash
cpanm --installdeps ./packages/
```

## Ollama Models

Pull Models

```bash
egrep -v '^(;|#|//)' ./packages/ollama-models |
  xargs -I {} ollama pull {}
```

<details>
  <summary>Dump Existing Models to File</summary>

```bash
ollama list |
  awk 'NR > 1 { print $1 }' > ./packages/ollama-models

# Makefile
make ollama
```

</details>

## Hugging Face Models

Download Models

```bash
while IFS= read -r model_name; do
  repo_id="$(echo ${model_name%% *} | tr -d '[:blank:]')"
  filename="$( echo ${model_name#* } | tr -d '[:blank:]')"
  huggingface-cli download "$repo_id" "$filename"
done < <(awk 'NR > 1' ./packages/hugging-face-models | egrep -v '^(;|#|//)')
```
