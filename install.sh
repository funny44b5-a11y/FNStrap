#!/usr/bin/env bash
set -euo pipefail

URL="https://github.com/funny44b5-a11y/FNStrap/releases/download/1.0.0/FNStrap.1.0.0"
TMP_BIN="/tmp/fnstrap.$$"
DEST_BIN="/usr/local/bin/fnstrap"

echo "FNStrap indiriliyor..."
curl -fsSL "$URL" -o "$TMP_BIN"
chmod +x "$TMP_BIN"
sudo mv "$TMP_BIN" "$DEST_BIN"
echo "Kurulum tamamlandi! Baslatmak icin: fnstrap"
