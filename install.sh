#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false

usage() {
  cat <<'EOF'
Usage: install.sh [--dry-run|-n] [--check|-c] [--lazygit-version <tag>]

Installs the system dependencies the configs in this repo require:
  - dnf packages: ripgrep, fd-find (provides `fd`), fzf, gcc, make, unzip,
    python3, nodejs, npm, git
  - lazygit: latest release binary from GitHub -> ~/.local/bin/lazygit
    (not packaged in Fedora repos)

Options:
  -n, --dry-run     Print what would be installed without changing anything
  -c, --check       Only verify dependencies are present; install nothing
                    (no sudo prompt). Exits 1 if anything is missing.
  -h, --help        Show this help
EOF
}

for arg in "$@"; do
  case "$arg" in
    -n|--dry-run) DRY_RUN=true ;;
    -c|--check) CHECK=true ;;
    --lazygit-version) shift; LAZYGIT_VERSION="$1" ;;
    *) echo "Error: unknown option: $arg" >&2; usage; exit 1 ;;
  esac
done

# Lazygit fetches the latest release tag unless one is pinned explicitly.
install_lazygit() {
  local version="${LAZYGIT_VERSION:-latest}"
  if [ "$version" = latest ]; then
    version="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest |
      sed -n 's/.*"tag_name": *"v\([^"]*\)".*/\1/p')"
    if [ -z "$version" ]; then
      echo "Error: could not resolve latest lazygit version" >&2
      return 1
    fi
  fi

  local url="https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_linux_x86_64.tar.gz"
  echo "  lazygit ${version} -> $HOME/.local/bin/lazygit"

  if [ "$DRY_RUN" = true ]; then
    return 0
  fi

  mkdir -p "$HOME/.local/bin"
  curl -fSL "$url" | tar -xz -C "$HOME/.local/bin" lazygit
}

ensure_local_bin_path() {
  for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
    [ -f "$rc" ] || continue
    grep -q '\$HOME/.local/bin' "$rc" && continue
    grep -q '\.local/bin' "$rc" && continue
    if [ "$DRY_RUN" = true ]; then
      echo "  would add ~/.local/bin to PATH in $rc"
      continue
    fi
    {
      echo ""
      echo "# >>> dotfiles local bin >>>"
      echo 'export PATH="$HOME/.local/bin:$PATH"'
      echo "# <<< dotfiles local bin <<<"
    } >> "$rc"
    echo "  added ~/.local/bin to PATH in $rc"
  done
}

main() {
  echo "== Dotfiles dependency install =="
  [ "$DRY_RUN" = true ] && echo "(dry run — nothing will be changed)"

  # Packages the config directly requires or that Neovim/Mason assume exist.
  # dnf handles build deps (gcc/make for telescope-fzf-native), so we include
  # them here instead of a separate install step.
  local PACKAGES=(ripgrep fd-find fzf git gcc make unzip python3 python3-pip nodejs npm)

  if [ "${CHECK:-}" = true ]; then
    local missing=()
    local p
    local -A PKG_TO_CMD=([ripgrep]=rg [fd-find]=fd [fzf]=fzf [git]=git \
      [gcc]=gcc [make]=make [unzip]=unzip [python3]=python3 [python3-pip]=pip [nodejs]=node [npm]=npm)
    for p in "${PACKAGES[@]}"; do
      if ! command -v "${PKG_TO_CMD[$p]}" >/dev/null 2>&1; then
        missing+=("$p")
      fi
    done
    if ! command -v lazygit >/dev/null 2>&1; then
      missing+=("lazygit (GitHub release)")
    fi
    if [ ${#missing[@]} -gt 0 ]; then
      echo "MISSING: ${missing[*]}"
      exit 1
    fi
    echo "All dependencies present."
    exit 0
  fi

  # dnf: install in one pass. Only ask sudo for the packages actually missing.
  local to_install=()
  local -A PKG_TO_CMD=([ripgrep]=rg [fd-find]=fd [fzf]=fzf [git]=git \
    [gcc]=gcc [make]=make [unzip]=unzip [python3]=python3 [python3-pip]=pip [nodejs]=node [npm]=npm)
  local p
  for p in "${PACKAGES[@]}"; do
    if command -v "${PKG_TO_CMD[$p]}" >/dev/null 2>&1; then
      echo "  ok: $p"
    else
      to_install+=("$p")
    fi
  done
  if [ ${#to_install[@]} -gt 0 ]; then
    if [ "$DRY_RUN" = true ]; then
      echo "  would dnf install: ${to_install[*]}"
    else
      echo "== dnf install: ${to_install[*]} =="
      sudo dnf install -y "${to_install[@]}"
    fi
  fi

  if ! command -v lazygit >/dev/null 2>&1; then
    install_lazygit
    ensure_local_bin_path
  else
    echo "  ok: lazygit ($(command -v lazygit))"
  fi

  echo "== Dependency install complete =="
}

main
