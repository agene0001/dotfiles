#!/usr/bin/env bash
# Deploy dotfiles via GNU stow. Run from anywhere; operates on the repo root.
set -euo pipefail

cd "$(dirname "$0")"

if ! command -v stow >/dev/null 2>&1; then
  echo "GNU stow is required."
  echo "  macOS:        brew install stow"
  echo "  Debian/Kali:  sudo apt install stow"
  exit 1
fi

# Packages deployed on every unix machine.
common=(nvim zsh tmux ssh keyb)

case "$(uname -s)" in
  Darwin) packages=("${common[@]}") ;;
  Linux)  packages=("${common[@]}" i3 bin) ;;
  *)
    echo "Unsupported OS '$(uname -s)' for stow. On Windows use install.ps1."
    exit 1
    ;;
esac

echo "Stowing into $HOME: ${packages[*]}"
stow --target="$HOME" --restow "${packages[@]}"
echo "Done. To remove a package's symlinks: stow -D <package>"
