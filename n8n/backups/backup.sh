#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
N8N_DATA_DIR="$SCRIPT_DIR/../data"
BACKUP_DIR="$SCRIPT_DIR"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
ARCHIVE="$BACKUP_DIR/n8n-backup-$TIMESTAMP.tar.gz"

mkdir -p "$BACKUP_DIR"

if [ ! -d "$N8N_DATA_DIR" ]; then
  echo "Source directory not found: $N8N_DATA_DIR" >&2
  exit 1
fi

tar -czf "$ARCHIVE" -C "$SCRIPT_DIR/.." "data"

echo "Backup created: $ARCHIVE"

find "$BACKUP_DIR" -maxdepth 1 -type f -name 'n8n-backup-*.tar.gz' | sort | head -n -5 | xargs -r rm

echo "Kept the latest 5 backups."
