#!/bin/zsh
set -euo pipefail

script_dir="${0:A:h}"
repo_dir="${script_dir:h}"
dotfiles_dir="$repo_dir/dotfiles"
dry_run=0

if [[ "${1:-}" == "--dry-run" ]]; then
  dry_run=1
fi

if [[ ! -d "$dotfiles_dir" ]]; then
  print -u2 "dotfiles directory was not found: $dotfiles_dir"
  exit 1
fi

timestamp="$(date +%Y%m%d%H%M%S)"
linked=0

while IFS= read -r source; do
  relative_path="${source#$dotfiles_dir/}"

  if [[ "${relative_path:t}" == ".gitkeep" ]]; then
    continue
  fi
  if [[ "${relative_path:t}" == ".DS_Store" ]]; then
    continue
  fi

  target="$HOME/$relative_path"
  linked=$((linked + 1))

  if [[ "$dry_run" == "1" ]]; then
    print "Would link $target -> $source"
    continue
  fi

  mkdir -p "${target:h}"

  if [[ -L "$target" ]]; then
    current_target="$(readlink "$target")"
    if [[ "$current_target" == "$source" ]]; then
      print "Already linked: $target"
      continue
    fi
    rm "$target"
  elif [[ -e "$target" ]]; then
    backup="$target.backup.$timestamp"
    mv "$target" "$backup"
    print "Backed up $target to $backup"
  fi

  ln -s "$source" "$target"
  print "Linked $target -> $source"
done < <(find "$dotfiles_dir" \( -type f -o -type l \) -print)

if [[ "$linked" == "0" ]]; then
  print "No dotfiles to link yet. Add files under $dotfiles_dir."
fi
