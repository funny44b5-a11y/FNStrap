#!/usr/bin/env bash
set -euo pipefail

REPO_OWNER="funny44b5-a11y"
REPO_NAME="FNStrap"
API_URL="https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/releases/latest"
TMP_BIN="/tmp/fnstrap"
TARGET_BIN="/usr/local/bin/fnstrap"

cleanup() {
  rm -f "$TMP_BIN"
}
trap cleanup EXIT

echo "Fetching latest release info for ${REPO_NAME}..."
RELEASE_JSON=$(curl -fsSL "$API_URL")

DOWNLOAD_URL=$(printf '%s\n' "$RELEASE_JSON" | grep -oE '"browser_download_url": *"[^"]+"' | head -n 1 | cut -d'"' -f4)

if [ -z "$DOWNLOAD_URL" ]; then
  echo "Error: No uploaded binary asset found in the latest release." >&2
  echo "Please upload the compiled binary to the release at:" >&2
  echo "https://github.com/${REPO_OWNER}/${REPO_NAME}/releases" >&2
  exit 1
fi

echo "Downloading FNStrap from ${DOWNLOAD_URL}..."
if ! curl -fsSL "$DOWNLOAD_URL" -o "$TMP_BIN"; then
  echo "Error: Failed to download binary from '${DOWNLOAD_URL}'." >&2
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
