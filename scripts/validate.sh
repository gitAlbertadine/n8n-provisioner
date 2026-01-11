#!/usr/bin/env bash
set -e

# Usage: ./validate.sh <PORT> <DOMAIN>
PORT="$1"
DOMAIN="$2"

if [ -z "$PORT" ] || [ -z "$DOMAIN" ]; then
  echo "Usage: $0 <PORT> <DOMAIN>"
  exit 1
fi

echo "Checking Docker installation..."
if ! command -v docker >/dev/null 2>&1; then
  echo "Error: Docker is not installed."
  exit 1
fi

echo "Checking Docker Compose installation..."
if ! docker compose version >/dev/null 2>&1; then
  echo "Error: Docker Compose v2+ is required."
  exit 1
fi

echo "Checking port $PORT availability..."
if ss -tulpn | grep -q ":$PORT "; then
  echo "Error: Port $PORT is already in use."
  exit 1
fi

echo "Checking domain resolution for $DOMAIN..."
if ! getent hosts "$DOMAIN" >/dev/null; then
  echo "Warning: $DOMAIN does not resolve in DNS. Proceed with caution."
fi

echo "Validation passed. You can run the installer."

