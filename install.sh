#!/usr/bin/env bash
set -euo pipefail

REPO_OWNER="funny44b5-a11y"
REPO_NAME="FNStrap"
TAG="v1.0.0"
ASSET_NAME="FNStrap.1.0.0"

RELEASE_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/download/${TAG}/${ASSET_NAME}"
TMP_BIN="/tmp/fnstrap"
TARGET_BIN="/usr/local/bin/fnstrap"

cleanup() {
  rm -f "$TMP_BIN"
}
trap cleanup EXIT

echo "Downloading FNStrap (${TAG} / ${ASSET_NAME})..."
if ! curl -fsSL "$RELEASE_URL" -o "$TMP_BIN"; then
  echo "Error: Failed to download from '${RELEASE_URL}' (404 or network issue)." >&2
  echo "Please check the published release tag (TAG) and asset name (ASSET_NAME) at:" >&2
  echo "https://github.com/${REPO_OWNER}/${REPO_NAME}/releases" >&2
  exit 1
fi

if [ ! -s "$TMP_BIN" ]; then
  echo "Error: Downloaded file is empty." >&2
  exit 1
fi

chmod +x "$TMP_BIN"

if [ "$(id -u)" -eq 0 ]; then
  mv "$TMP_BIN" "$TARGET_BIN"
elif command -v sudo >/dev/null 2>&1; then
  sudo mv "$TMP_BIN" "$TARGET_BIN"
else
  echo "Error: 'sudo' or root privileges are required to move the binary to '${TARGET_BIN}'." >&2
  exit 1
fi

trap - EXIT
echo "Installation complete! Run it with: fnstrap"
