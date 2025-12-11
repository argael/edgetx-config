#!/usr/bin/env bash
set -euo pipefail

REMOTE_DEFAULT_PATH="/Volumes/NO NAME"
REMOTE_MOUNTED_PATH="${1:-$REMOTE_DEFAULT_PATH}"

TIMESTAMP="$(date +"%Y%m%d-%H%M%S")"
PROJECT_PATH=$(pwd)
BACKUP_PATH="${PROJECT_PATH}/backups/raw"
ARCHIVES_PATH="${PROJECT_PATH}/backups/archives"

if [ ! -d "$REMOTE_MOUNTED_PATH" ]; then
  echo "ERROR: Remote control isn't mounted on: '$REMOTE_MOUNTED_PATH'"
  echo "Check the Remote Control is connected using SD mode."
  exit 1c
fi

mkdir -p "$BACKUP_PATH"
mkdir -p "$ARCHIVES_PATH"

rsync -av --progress \
    --exclude='.TemporaryItems' \
    --exclude='.Spotlight-V100' \
    --exclude='.fseventsd' \
    --exclude='.Trashes' \
    "${REMOTE_MOUNTED_PATH}/" "${BACKUP_PATH}/"

ARCHIVE_PATH="${ARCHIVES_PATH}/backup-${TIMESTAMP}.zip"

pushd "$BACKUP_PATH"
zip -r -X "$ARCHIVE_PATH" . > /dev/null
popd