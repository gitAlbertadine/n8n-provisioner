#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR/.."

APP_ID="$1"
MODE="$2"

if [ -z "$APP_ID" ]; then
  echo "Usage: $0 <APP_ID> [--purge]"
  exit 1
fi

BASE_DIR="/opt/n8n"
APP_DIR="$BASE_DIR/$APP_ID"

if [ ! -d "$APP_DIR" ]; then
  echo "Error: App directory not found: $APP_DIR"
  exit 1
fi

cd "$APP_DIR"

echo "Stopping n8n instance: $APP_ID"
docker compose down

if [ "$MODE" = "--purge" ]; then
  echo "Purging volumes and data for: $APP_ID"

  docker compose down -v

  cd /
  rm -rf "$APP_DIR"

  echo "App '$APP_ID' fully removed (containers + volumes + files)."
else
  echo "Safe uninstall complete."
  echo "Containers removed, data preserved at: $APP_DIR"
  echo "To fully delete data, re-run with --purge"
fi

