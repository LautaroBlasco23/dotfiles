#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/bin"
CONFIG_DIR="$HOME/.config"

echo "== Installing dotfiles =="

mkdir -p "$CONFIG_DIR"
mkdir -p "$BIN_DIR"

install_dependencies() {
  echo "== Installing dependencies =="

  if ! command -v jq &>/dev/null; then
    sudo apt-get install -y jq
    echo "Installed: jq"
  else
    echo "Already installed: jq"
  fi
}

backup() {
  local target="$1"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$target.backup.$(date +%s)"
    echo "Backup created for $target"
  fi
}

link() {
  local src="$1"
  local dest="$2"

  backup "$dest"

  if [ ! -L "$dest" ]; then
    ln -s "$src" "$dest"
    echo "Linked $dest -> $src"
  fi
}

install_scripts() {
  bash "$REPO_DIR/scripts/init.sh"
}

ensure_path() {
  if ! echo "$PATH" | grep -q "$HOME/bin"; then
    echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
    echo "Added ~/bin to PATH"
  fi
}

setup_links() {
  echo "== Linking configs =="

  link "$REPO_DIR/claude" "$HOME/.claude"
  link "$REPO_DIR/nvim" "$CONFIG_DIR/nvim"
}

main() {
  install_dependencies
  ensure_path
  install_scripts
  setup_links

  echo ""
  echo "Dotfiles installed."
}

main
