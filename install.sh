#!/usr/bin/env bash
set -e

echo "Downloading FNStrap..."
curl -fsSL "https://github.com/funny44b5-a11y/FNStrap/releases/download/v1.0.0/FNStrap.1.0.0" -o /tmp/fnstrap
chmod +x /tmp/fnstrap
sudo mv /tmp/fnstrap /usr/local/bin/fnstrap

echo "Installation complete! Run it with: fnstrap"
