#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS_DIR="$REPO_DIR/scripts"
BIN_DIR="$HOME/bin"
CONFIG_DIR="$HOME/.config"

echo "== macOS dotfiles installer =="

mkdir -p "$CONFIG_DIR"
mkdir -p "$BIN_DIR"

# ── Helpers ────────────────────────────────────────────────────────────────

installed() { command -v "$1" &>/dev/null; }

brew_install() {
  local pkgs=("$@")
  for pkg in "${pkgs[@]}"; do
    if ! brew list --formula "$pkg" &>/dev/null && ! brew list --cask "$pkg" &>/dev/null; then
      brew install "$pkg"
    fi
  done
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

# ── Homebrew ───────────────────────────────────────────────────────────────

ensure_homebrew() {
  if installed brew; then
    return
  fi

  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to PATH for the current session
  if [ -x "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

# ── Xcode Command Line Tools ───────────────────────────────────────────────

install_xcode_clt() {
  if xcode-select -p &>/dev/null; then
    return
  fi
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install 2>/dev/null || true
  echo "If a dialog appears, click 'Install' and wait for it to complete, then re-run this script."
  exit 0
}

# ── System dependencies ────────────────────────────────────────────────────

install_deps() {
  echo "== Installing system dependencies =="

  brew_install neovim git curl wget

  # Search tools (nvim telescope)
  brew_install ripgrep fd

  # Terminal UI
  brew_install lazygit

  # Data / network
  brew_install jq

  # Docker Desktop (CLI + GUI)
  if ! installed docker; then
    echo "Installing Docker Desktop..."
    brew install --cask docker
    echo "Note: Launch Docker Desktop from Applications to complete setup."
  fi

  # Node.js
  if ! installed node; then
    brew_install node
  fi

  # Python + pipx
  if ! installed pipx; then
    brew_install python pipx
    pipx ensurepath 2>/dev/null || true
  fi

  # Go
  if ! installed go; then
    brew_install go
  fi

  echo "System dependencies OK."
}

# ── Nerd Font ──────────────────────────────────────────────────────────────

install_font() {
  echo "== Installing JetBrainsMono Nerd Font =="

  if brew list --cask font-jetbrains-mono-nerd-font &>/dev/null; then
    echo "Font already installed."
    return
  fi

  brew_install font-jetbrains-mono-nerd-font

  echo "Font installed. Restart your terminal emulator for icons to appear."
}

# ── Python tools ───────────────────────────────────────────────────────────

install_python_tools() {
  echo "== Installing Python tools =="

  for tool in black isort; do
    if ! installed "$tool"; then
      pipx install "$tool"
      echo "Installed: $tool"
    else
      echo "Already installed: $tool"
    fi
  done
}

# ── PATH ───────────────────────────────────────────────────────────────────

ensure_path() {
  local shell_rc
  if [ -f "$HOME/.zshrc" ]; then
    shell_rc="$HOME/.zshrc"
  elif [ -f "$HOME/.bashrc" ]; then
    shell_rc="$HOME/.bashrc"
  else
    shell_rc="$HOME/.zshrc"
  fi

  if ! grep -q "$BIN_DIR" "$shell_rc" 2>/dev/null; then
    echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$shell_rc"
    echo "Added ~/bin to PATH in $(basename "$shell_rc")"
  fi
}

# ── Scripts ────────────────────────────────────────────────────────────────

install_scripts() {
  bash "$REPO_DIR/scripts/init.sh"
}

# ── Config symlinks ────────────────────────────────────────────────────────

setup_links() {
  echo "== Linking configs =="

  if [ -L "$HOME/.claude" ] && [ "$(readlink "$HOME/.claude")" = "$REPO_DIR/claude" ]; then
    echo "Removing old ~/.claude symlink (migrating to per-file links)"
    rm "$HOME/.claude"
  fi

  mkdir -p "$HOME/.claude"
  mkdir -p "$HOME/.opencode"

  link "$REPO_DIR/skills" "$HOME/.claude/skills"
  link "$REPO_DIR/skills" "$HOME/.opencode/skills"

  link "$REPO_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
  link "$REPO_DIR/claude/scripts" "$HOME/.claude/scripts"
  link "$REPO_DIR/claude/settings.json" "$HOME/.claude/settings.json"
  link "$REPO_DIR/claude/settings.local.json" "$HOME/.claude/settings.local.json"

  link "$REPO_DIR/nvim" "$CONFIG_DIR/nvim"
  link "$REPO_DIR/opencode" "$CONFIG_DIR/opencode"
}

# ── Main ───────────────────────────────────────────────────────────────────

main() {
  ensure_homebrew
  install_xcode_clt
  install_deps
  install_font
  install_python_tools
  ensure_path
  install_scripts
  setup_links

  echo ""
  echo "============================================="
  echo "  Dotfiles installed on macOS."
  echo ""
  echo "  Next steps:"
  echo "  1. source ~/.zshrc   (or restart terminal)"
  echo "  2. nvim               (auto-installs plugins & LSPs)"
  echo "============================================="
}

main
