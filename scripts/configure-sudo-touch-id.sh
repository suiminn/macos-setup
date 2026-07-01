#!/bin/zsh
set -euo pipefail

template="/etc/pam.d/sudo_local.template"
target="/etc/pam.d/sudo_local"

sudo -v

if [[ ! -f "$template" ]]; then
  print "Skip: $template was not found."
  exit 0
fi

if sudo test -f "$target"; then
  if sudo grep -q "^auth.*pam_tid\\.so" "$target"; then
    print "Touch ID for sudo is already enabled."
  else
    print "Skip: $target already exists. Edit it manually if you want to enable Touch ID for sudo."
  fi
  exit 0
fi

sed -e 's/^#auth/auth/' "$template" | sudo tee "$target" >/dev/null
print "Created $target from $template."
