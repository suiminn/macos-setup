#!/bin/zsh
set -euo pipefail

REPO_URL="https://github.com/suiminn/macos-setup.git"
INSTALL_DIR="${MACOS_SETUP_DIR:-$HOME/.local/share/macos-setup}"

resolve_repo_dir() {
  if [[ -n "${0:-}" && -f "$0" ]]; then
    local script_dir="${0:A:h}"
    if [[ -f "$script_dir/Brewfile" && -d "$script_dir/scripts" ]]; then
      print -r -- "$script_dir"
      return
    fi
  fi

  if ! command -v git >/dev/null 2>&1; then
    print -u2 "git is required to clone $REPO_URL"
    exit 1
  fi

  if [[ -d "$INSTALL_DIR/.git" ]]; then
    git -C "$INSTALL_DIR" pull --ff-only >&2
  elif [[ -e "$INSTALL_DIR" ]]; then
    print -u2 "$INSTALL_DIR already exists and is not a git repository"
    exit 1
  else
    mkdir -p "${INSTALL_DIR:h}"
    git clone "$REPO_URL" "$INSTALL_DIR" >&2
  fi

  print -r -- "$INSTALL_DIR"
}

run_step() {
  local name="$1"
  shift

  print
  print "==> $name"
  "$@"
}

REPO_DIR="$(resolve_repo_dir)"

run_step "Configure sudo Touch ID" "$REPO_DIR/scripts/configure-sudo-touch-id.sh"
run_step "Apply macOS defaults" "$REPO_DIR/scripts/macos-defaults.sh"
run_step "Install Homebrew dependencies" "$REPO_DIR/scripts/install-homebrew.sh" "$REPO_DIR/Brewfile"
run_step "Link dotfiles" "$REPO_DIR/scripts/link-dotfiles.sh"

if [[ "${INSTALL_PALERA1N:-0}" == "1" ]]; then
  run_step "Install palera1n" "$REPO_DIR/scripts/install-palera1n.sh"
else
  print
  print "==> Skip palera1n"
  print "Set INSTALL_PALERA1N=1 to install palera1n."
fi
