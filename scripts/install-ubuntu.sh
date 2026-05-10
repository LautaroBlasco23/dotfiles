#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS_DIR="$REPO_DIR/scripts"
BIN_DIR="$HOME/bin"
CONFIG_DIR="$HOME/.config"
FONT_DIR="$HOME/.local/share/fonts"

echo "== Ubuntu/Debian dotfiles installer =="

mkdir -p "$CONFIG_DIR"
mkdir -p "$BIN_DIR"

# ── Helpers ────────────────────────────────────────────────────────────────

installed() { command -v "$1" &>/dev/null; }

apt_install() {
  local pkgs=("$@")
  local missing=()
  for pkg in "${pkgs[@]}"; do
    if ! dpkg -s "$pkg" &>/dev/null; then
      missing+=("$pkg")
    fi
  done
  if [ ${#missing[@]} -gt 0 ]; then
    sudo apt-get update -qq
    sudo apt-get install -y "${missing[@]}"
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

# ── System dependencies ────────────────────────────────────────────────────

install_deps() {
  echo "== Installing system dependencies =="

  # Core
  apt_install neovim git make gcc g++ curl wget unzip ca-certificates

  # Search tools (nvim telescope)
  apt_install ripgrep
  if ! installed fdfind && ! installed fd; then
    apt_install fd-find
  fi
  if installed fdfind && ! installed fd; then
    sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
  fi

  # Clipboard
  apt_install xclip

  # Terminal UI
  if ! installed lazygit; then
    echo "Installing lazygit..."
    local lg_ver
    lg_ver=$(curl -fsSL "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -o '"tag_name": ".*"' | cut -d'"' -f4 | sed 's/^v//')
    local lg_tar="/tmp/lazygit.tar.gz"
    curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${lg_ver}/lazygit_${lg_ver}_Linux_x86_64.tar.gz" -o "$lg_tar"
    tar -xzf "$lg_tar" -C /tmp lazygit
    sudo mv /tmp/lazygit /usr/local/bin/lazygit
    rm -f "$lg_tar"
  fi

  # Data / network
  apt_install jq

  # Docker
  if ! installed docker; then
    apt_install docker.io
    sudo usermod -aG docker "$USER" 2>/dev/null || true
    echo "Note: Log out and back in for Docker group to take effect."
  fi

  # Node.js (LTS via NodeSource) — needed for ts_ls, prettier, eslint_d
  if ! installed node; then
    echo "Installing Node.js LTS..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
      | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" \
      | sudo tee /etc/apt/sources.list.d/nodesource.list
    sudo apt-get update -qq
    sudo apt-get install -y nodejs
  fi

  # Python + pipx
  if ! installed pipx; then
    apt_install python3 python3-venv python3-pip pipx
    pipx ensurepath 2>/dev/null || true
  fi

  # Go
  if ! installed go; then
    apt_install golang-go
  fi

  echo "System dependencies OK."
}

# ── Nerd Font ──────────────────────────────────────────────────────────────

install_font() {
  echo "== Installing JetBrainsMono Nerd Font =="

  local font_dir="$FONT_DIR/JetBrainsMonoNerdFont"
  if [ -d "$font_dir" ] && ls "$font_dir"/*.ttf &>/dev/null; then
    echo "Font already installed at $font_dir"
    return
  fi

  mkdir -p "$font_dir"

  local tar_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
  local tar_file="/tmp/jetbrains-nerd-font.tar.xz"

  echo "Downloading JetBrainsMono Nerd Font..."
  curl -fsSL "$tar_url" -o "$tar_file"

  echo "Extracting fonts..."
  tar -xf "$tar_file" -C "$font_dir" --strip-components=1
  rm -f "$tar_file"

  fc-cache -f "$font_dir" 2>/dev/null || true

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
  if ! echo "$PATH" | grep -q "$BIN_DIR"; then
    echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$HOME/.bashrc"
    echo "Added ~/bin to PATH in .bashrc"
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
  install_deps
  install_font
  install_python_tools
  ensure_path
  install_scripts
  setup_links

  echo ""
  echo "============================================="
  echo "  Dotfiles installed on Ubuntu/Debian."
  echo ""
  echo "  Next steps:"
  echo "  1. source ~/.bashrc  (or restart terminal)"
  echo "  2. nvim               (auto-installs plugins & LSPs)"
  echo "============================================="
}

main
