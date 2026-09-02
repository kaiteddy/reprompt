#!/bin/bash
# Reprompt — one-line installer for macOS.
#
#   curl -fsSL https://raw.githubusercontent.com/kaiteddy/reprompt/main/install.sh | bash
#
# Downloads the latest release package, unpacks it, and runs its installer,
# which walks you through three steps: your API key, one macOS permission,
# done. Nothing else is needed on the Mac — the package carries its own Python
# and fetches the hotkey engine (Hammerspoon) itself.
set -euo pipefail
[ "$(uname)" = "Darwin" ] || { echo "Reprompt is for macOS."; exit 1; }
API="https://api.github.com/repos/kaiteddy/reprompt/releases/latest"
URL=$(curl -fsSL "$API" | sed -n 's/.*"browser_download_url": *"\([^"]*Reprompt\.zip\)".*/\1/p' | head -1)
[ -n "${URL:-}" ] || { echo "Couldn't find the latest Reprompt release. Try again in a minute."; exit 1; }
TMP=$(mktemp -d)
echo "Downloading Reprompt…"
curl -fL# "$URL" -o "$TMP/Reprompt.zip"
ditto -x -k "$TMP/Reprompt.zip" "$TMP"
bash "$TMP/Reprompt/Install Reprompt.command" </dev/tty
rm -rf "$TMP"
