# macos-setup

Personal macOS bootstrap and dotfiles.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/suiminn/macos-setup/refs/heads/main/setup.sh | zsh
```

The bootstrap clones or updates this repository at `~/.local/share/macos-setup`
when it is run from a pipe. To use another location:

```sh
curl -fsSL https://raw.githubusercontent.com/suiminn/macos-setup/refs/heads/main/setup.sh | MACOS_SETUP_DIR="$HOME/src/macos-setup" zsh
```

palera1n is opt-in:

```sh
curl -fsSL https://raw.githubusercontent.com/suiminn/macos-setup/refs/heads/main/setup.sh | INSTALL_PALERA1N=1 zsh
```

## Layout

```text
Brewfile
setup.sh
dotfiles/
  Library/
    LaunchAgents/
  bin/
  .config/
    git/
    ghostty/
    karabiner/
scripts/
  configure-sudo-touch-id.sh
  install-homebrew.sh
  install-palera1n.sh
  link-dotfiles.sh
  macos-defaults.sh
```

Files under `dotfiles/` are linked to the same relative path under `$HOME`.
For example, `dotfiles/.config/git/ignore` becomes
`~/.config/git/ignore`.

Preview dotfile links without changing `$HOME`:

```sh
scripts/link-dotfiles.sh --dry-run
```
