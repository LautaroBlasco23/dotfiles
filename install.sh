#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

echo "== Dotfiles installer =="

mkdir -p "$CONFIG_DIR"

backup() {
  local target="$1"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    local backup="${target}.backup.$(date +%s)"
    echo "📦 Backing up $target -> $backup"
    mv "$target" "$backup"
  fi
}

link() {
  local src="$1"
  local dest="$2"

  backup "$dest"

  if [ -L "$dest" ]; then
    echo "✔ $dest already linked"
    return
  fi

  ln -s "$src" "$dest"
  echo "🔗 $dest -> $src"
}

detect_os() {
  case "$(uname -s)" in
    Linux) OS="linux" ;;
    Darwin) OS="mac" ;;
    *) OS="unknown" ;;
  esac
}

install_packages_linux() {
  if command -v apt >/dev/null; then
    sudo apt update
    sudo apt install -y neovim ripgrep fd-find git curl
  elif command -v pacman >/dev/null; then
    sudo pacman -S --noconfirm neovim ripgrep fd git curl
  fi
}

install_packages_mac() {
  if command -v brew >/dev/null; then
    brew install neovim ripgrep fd git
  fi
}

install_packages() {
  detect_os

  echo "== Installing dependencies ($OS) =="

  case "$OS" in
    linux) install_packages_linux ;;
    mac) install_packages_mac ;;
    *) echo "⚠ Unknown OS. Skipping package install." ;;
  esac
}

setup_links() {
  echo "== Linking configs =="

  link "$REPO_DIR/claude" "$HOME/.claude"
  link "$REPO_DIR/nvim" "$CONFIG_DIR/nvim"
}

main() {
  install_packages
  setup_links

  echo ""
  echo "✅ Dotfiles installed successfully"
}

main
