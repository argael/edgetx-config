#!/usr/bin/env bash
set -euo pipefail

REMOTE_DEFAULT_PATH="/Volumes/NO NAME"
REMOTE_MOUNTED_PATH="${1:-$REMOTE_DEFAULT_PATH}"

PROJECT_PATH=$(pwd)
ARCHIVES_PATH="${PROJECT_PATH}/backups/archives"

# Archive passée en paramètre (optionnel)
# - Si vide : on prendra la plus récente dans ARCHIVES_PATH
ARCHIVE_ARG="${2:-}"

if [ ! -d "$REMOTE_MOUNTED_PATH" ]; then
  echo "ERROR: Remote control isn't mounted on: '$REMOTE_MOUNTED_PATH'"
  echo "Check the Remote Control is connected using SD mode."
  exit 1
fi

if [ -n "$ARCHIVE_ARG" ]; then

  if [[ "$ARCHIVE_ARG" = /* ]]; then
    ARCHIVE_PATH="$ARCHIVE_ARG"
  else
    ARCHIVE_PATH="${ARCHIVES_PATH}/${ARCHIVE_ARG}"
  fi
else
  ARCHIVE_PATH=$(ls -1t "${ARCHIVES_PATH}"/backup-*.zip 2>/dev/null | head -n 1 || true)
fi

# Vérifications sur l’archive
if [ -z "${ARCHIVE_PATH:-}" ]; then
  echo "ERROR: No archive found in '${ARCHIVES_PATH}'."
  echo "Make sure there is at least one 'backup-*.zip' file."
  exit 1
fi

if [ ! -f "$ARCHIVE_PATH" ]; then
  echo "ERROR: Archive file not found: '$ARCHIVE_PATH'"
  exit 1
fi

echo "Archive utilisée     : $ARCHIVE_PATH"
echo
echo "ATTENTION: files on '$REMOTE_MOUNTED_PATH' may be overwritten."
echo "Restoring..."
echo

# Décompression dans la télécommande
# -o : overwrite existing files without prompting
unzip -o "$ARCHIVE_PATH" -d "$REMOTE_MOUNTED_PATH" >/dev/null

echo
echo "Restore completed successfully."
