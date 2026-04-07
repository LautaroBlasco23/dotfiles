#!/usr/bin/env bash

TARGET=$1

if [ -z "$TARGET" ]; then
  echo "Usage: ./webcheck.sh example.com"
  exit 1
fi

echo "Running Web Check for: $TARGET"
echo "----------------------------------"

curl -s "https://web-check.as93.net/api?url=$TARGET" | jq
