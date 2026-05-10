#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$REPO_DIR/scripts"

echo "== Dotfiles installer =="
echo ""

case "$(uname -s)" in
  Linux)
    echo "Detected: Linux"
    exec bash "$SCRIPTS_DIR/install-ubuntu.sh"
    ;;
  Darwin)
    echo "Detected: macOS"
    exec bash "$SCRIPTS_DIR/install-macos.sh"
    ;;
  CYGWIN*|MINGW*|MSYS*)
    echo "Detected: Windows (via $MSYSTEM)"
    if command -v powershell.exe &>/dev/null; then
      powershell.exe -ExecutionPolicy Bypass -File "$SCRIPTS_DIR/install-windows.ps1"
    else
      echo "Error: Could not find powershell.exe"
      echo "Run this script from PowerShell: "
      echo "  .\\scripts\\install-windows.ps1"
      exit 1
    fi
    ;;
  *)
    echo "Error: Unsupported OS ($(uname -s))"
    echo "You can run the appropriate install script manually:"
    echo "  Ubuntu/Debian: bash scripts/install-ubuntu.sh"
    echo "  macOS:         bash scripts/install-macos.sh"
    echo "  Windows:       powershell scripts/install-windows.ps1"
    exit 1
    ;;
esac
