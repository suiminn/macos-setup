#!/bin/zsh
set -euo pipefail

brewfile="${1:-}"

if [[ -z "$brewfile" || ! -f "$brewfile" ]]; then
  print -u2 "Usage: $0 /path/to/Brewfile"
  exit 1
fi

find_brew_bin() {
  local candidate

  if command -v brew >/dev/null 2>&1; then
    command -v brew
    return
  fi

  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "$candidate" ]]; then
      print -r -- "$candidate"
      return
    fi
  done
}

brew_bin="$(find_brew_bin || true)"
if [[ -z "$brew_bin" ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew_bin="$(find_brew_bin || true)"
fi

if [[ -z "$brew_bin" ]]; then
  print -u2 "Homebrew was installed, but brew was not found in PATH."
  exit 1
fi

eval "$("$brew_bin" shellenv)"

zprofile="$HOME/.zprofile"
shellenv_line="eval \"\$($brew_bin shellenv)\""

touch "$zprofile"
if ! grep -Fqx "$shellenv_line" "$zprofile"; then
  printf '\n%s\n' "$shellenv_line" >> "$zprofile"
fi

brew bundle --file "$brewfile"
