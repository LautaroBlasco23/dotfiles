#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false

usage() {
  cat <<'EOF'
Usage: sync.sh [--dry-run|-n]

Copies tracked dotfiles from this repo into the user's config directories
as real files (no symlinks). Sync is one-way: repo -> home. Local edits to
the copied configs are overwritten on the next run.

Sources:
  opencode/  -> ~/.config/opencode
  claude/    -> ~/.claude          (settings.local.json is excluded)
  nvim/      -> ~/.config/nvim
  skills/    -> ~/.claude/skills, ~/.opencode/skills

Options:
  -n, --dry-run   Print what would be copied without changing anything
  -h, --help      Show this help
EOF
}

for arg in "$@"; do
  case "$arg" in
    -n|--dry-run) DRY_RUN=true ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Error: unknown option: $arg" >&2; usage; exit 1 ;;
  esac
done

# Tracked files never synced (machine-local config)
EXCLUDE=("claude/settings.local.json")

is_excluded() {
  local tracked="$1"
  for excl in "${EXCLUDE[@]}"; do
    [ "$tracked" = "$excl" ] && return 0
  done
  return 1
}

# Walk the destination path replacing any symlink component with a real
# directory/file, creating parent directories as needed. Side-effect only.
ensure_sync_path() {
  local base="$1" rel="$2"
  local cur="$base"
  local comp
  local parts
  local i=0 last

  local IFS='/'
  read -ra parts <<< "$rel"
  unset IFS

  last=$(( ${#parts[@]} - 1 ))
  for comp in "${parts[@]}"; do
    cur="$cur/$comp"
    if [ -L "$cur" ]; then
      echo "    replacing symlink: $cur -> $(readlink "$cur")"
      if [ "$DRY_RUN" = false ]; then
        rm "$cur"
      fi
    fi
    if [ "$i" -lt "$last" ] && [ "$DRY_RUN" = false ]; then
      mkdir -p "$cur"
    fi
    i=$((i + 1))
  done
}

sync_pair() {
  local src="$1" dest="$2"

  local files
  files="$(git -C "$REPO_DIR" ls-files "$src")"

  if [ -z "$files" ]; then
    echo "== $src/ -> $dest/ (nothing tracked, skipped) =="
    return 0
  fi

  if [ -L "$dest" ]; then
    echo "== $src/ -> $dest/ (replacing symlink: $(readlink "$dest")) =="
    if [ "$DRY_RUN" = false ]; then
      rm "$dest"
    fi
  else
    echo "== $src/ -> $dest/ =="
  fi

  while IFS= read -r tracked; do
    local rel="${tracked#"$src"/}"

    if is_excluded "$tracked"; then
      echo "  skip: $rel (excluded)"
      continue
    fi

    ensure_sync_path "$dest" "$rel"

    if [ "$DRY_RUN" = true ]; then
      echo "  copy: $rel"
      continue
    fi

    mkdir -p "$(dirname "$dest/$rel")"
    cp "$REPO_DIR/$tracked" "$dest/$rel"
    echo "  copied: $rel"
  done <<< "$files"
}

main() {
  echo "== Dotfiles sync =="
  [ "$DRY_RUN" = true ] && echo "(dry run — nothing will be changed)"

  sync_pair "opencode" "$HOME/.config/opencode"
  sync_pair "claude" "$HOME/.claude"
  sync_pair "nvim" "$HOME/.config/nvim"
  sync_pair "skills" "$HOME/.claude/skills"
  sync_pair "skills" "$HOME/.opencode/skills"

  echo "== Sync complete =="
  if [ "$DRY_RUN" = true ]; then
    echo "Re-run without --dry-run to apply."
  fi
}

main
