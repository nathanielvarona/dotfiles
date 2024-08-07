# Packages

## Homebrew Packages

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
  <summary>Dump Existing Packages to File using Makefile</summary>

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

## pipx Apps (Python Applications in Isolated Environments)

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

## Krew Plugins

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

## Helm Repos

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

## Perl Packages

Install CPANM using CPAN

```bash
cpan App::cpanminus
```

Use the CPANM to Install Module/Tool from the `cpanfile`

```bash
cpanm --installdeps ./
```

## Ollama Models

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

## Hugging Face Models

Download Models

```bash
while IFS= read -r model_name; do
  repo_id="$(echo ${model_name%% *} | tr -d '[:blank:]')"
  filename="$( echo ${model_name#* } | tr -d '[:blank:]')"
  huggingface-cli download "$repo_id" "$filename"
done < <(awk 'NR > 1' ./hugging-face-models | egrep -v '^(;|#|//)')
```
