#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/bin"

mkdir -p "$BIN_DIR"

if ! echo "$PATH" | grep -q "$HOME/bin"; then
  echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
  echo "Added ~/bin to PATH"
fi

echo "== Cleaning stale symlinks in ~/bin =="

for link in "$BIN_DIR"/*; do
  [ -L "$link" ] || continue
  target=$(readlink "$link")
  if [[ "$target" == "$SCRIPT_DIR"/* ]] && [ ! -e "$link" ]; then
    rm "$link"
    echo "Removed: $(basename "$link")"
  fi
done

echo "== Linking scripts to ~/bin =="

for script in "$SCRIPT_DIR"/*; do
  name=$(basename "$script")
  [ "$name" = "init.sh" ] && continue   # skip self
  [[ "$name" == install-* ]] && continue  # skip install scripts

  ln -sf "$script" "$BIN_DIR/$name"
  chmod +x "$script"
  echo "Linked: $name"
done
