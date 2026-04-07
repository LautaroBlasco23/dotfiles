#!/usr/bin/env bash

TARGET=$1
API_URL="http://localhost:3000/api"
CONTAINER_NAME="web-check-temp"
IMAGE="lissy93/web-check:latest"

cleanup() {
  docker stop "$CONTAINER_NAME" 2>/dev/null
  docker rm "$CONTAINER_NAME" 2>/dev/null
}

trap cleanup EXIT

if [ -z "$TARGET" ]; then
  echo "Usage: ./webcheck.sh example.com"
  exit 1
fi

URL="https://${TARGET}"
FULL_URL="https://${TARGET}"

echo "Running Web Check for: $TARGET"
echo "----------------------------------"

echo "Pulling image..."
docker pull "$IMAGE" >/dev/null 2>&1

echo "Starting container..."
docker run -d --name "$CONTAINER_NAME" -p 3000:3000 "$IMAGE" >/dev/null 2>&1

echo "Waiting for API to be ready..."
for i in {1..30}; do
  if curl -s "${API_URL}/headers?url=${URL}" >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

echo ""
echo "Fetching results..."
echo ""

for endpoint in headers ssl threats dns dnssec hsts cookies dns-server http-security features ports; do
  echo "[$endpoint]"
  RESPONSE=$(curl -s "${API_URL}/${endpoint}?url=${URL}" 2>/dev/null)
  if [ -n "$RESPONSE" ]; then
    echo "$RESPONSE" | jq '.' 2>/dev/null || echo "$RESPONSE"
  else
    echo "  (no response)"
  fi
  echo ""
done
