#!/usr/bin/env bash

set -e

REPO="https://github.com/YOUR_USERNAME/claude-workflow.git"
TARGET="$HOME/.claude"
BIN="$HOME/.local/bin"
CMD="$BIN/setup-claude-workflow"

mkdir -p "$BIN"

cat <<'EOF' > "$CMD"
#!/usr/bin/env bash

REPO="https://github.com/YOUR_USERNAME/claude-workflow.git"
TARGET="$HOME/.claude"

if [ -d "$TARGET/.git" ]; then
  echo "Updating Claude workflow..."
  git -C "$TARGET" pull --rebase origin main
else
  echo "Installing Claude workflow..."
  git clone "$REPO" "$TARGET"
fi

echo "Claude workflow ready at $TARGET"
EOF

chmod +x "$CMD"

echo "Command installed: setup-claude-workflow"
echo "Run:"
echo
echo "setup-claude-workflow"
