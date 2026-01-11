#!/usr/bin/env bash
set -e

# Directory of the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR/.."

# Usage: ./install.sh <APP_ID> <DOMAIN> <PORT>
APP_ID="$1"
DOMAIN="$2"
PORT="$3"

if [ -z "$APP_ID" ] || [ -z "$DOMAIN" ] || [ -z "$PORT" ]; then
  echo "Usage: $0 <APP_ID> <DOMAIN> <PORT>"
  exit 1
fi

BASE_DIR="/opt/n8n"
APP_DIR="$BASE_DIR/$APP_ID"

mkdir -p "$APP_DIR"

# Generate secrets
DB_PASSWORD=$(openssl rand -base64 24)
ADMIN_PASSWORD=$(openssl rand -base64 24)
ENCRYPTION_KEY=$(openssl rand -hex 32)

# Render .env
sed \
  -e "s|{{APP_ID}}|$APP_ID|g" \
  -e "s|{{DB_USER}}|n8n|g" \
  -e "s|{{DB_PASSWORD}}|$DB_PASSWORD|g" \
  -e "s|{{DB_NAME}}|n8n|g" \
  -e "s|{{N8N_HOST}}|$DOMAIN|g" \
  -e "s|{{N8N_BASIC_AUTH_USER}}|admin|g" \
  -e "s|{{N8N_BASIC_AUTH_PASSWORD}}|$ADMIN_PASSWORD|g" \
  -e "s|{{N8N_ENCRYPTION_KEY}}|$ENCRYPTION_KEY|g" \
  "$REPO_ROOT/scaffold/env.tpl" > "$APP_DIR/.env"

# Render docker-compose
sed "s|{{PORT}}|$PORT|g" "$REPO_ROOT/scaffold/docker-compose.yml.tpl" \
  > "$APP_DIR/docker-compose.yml"

# Deploy
cd "$APP_DIR"
docker compose up -d

# Generate manifest
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
sed \
  -e "s|{{APP_ID}}|$APP_ID|g" \
  -e "s|{{N8N_HOST}}|$DOMAIN|g" \
  -e "s|{{PORT}}|$PORT|g" \
  -e "s|{{TIMESTAMP}}|$TIMESTAMP|g" \
  "$REPO_ROOT/scaffold/manifest.tpl.json" > "$APP_DIR/manifest.json"

echo "n8n instance '$APP_ID' deployed at https://$DOMAIN on port $PORT"

