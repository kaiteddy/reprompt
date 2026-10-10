#!/bin/bash
# Compass public distribution bootstrap. This file is a review candidate.
# A release owner must approve one exact package after its evidence gate.
# Fill all three literals together in a reviewed change; there is no environment
# or command-line override, latest-release fallback, or permission to republish.
# The held state below intentionally refuses the legacy public 1.5.1 package.
set -euo pipefail

readonly RELEASE_TAG=''
readonly ARCHIVE_SHA256=''
readonly SOURCE_COMMIT=''

stop() { printf '%s\n' "$1" >&2; exit 1; }
if [[ ! "$RELEASE_TAG" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] \
    || [[ ! "$ARCHIVE_SHA256" =~ ^[0-9a-f]{64}$ ]] \
    || [[ ! "$SOURCE_COMMIT" =~ ^[0-9a-f]{40}$ ]]; then
  printf '%s\n' 'Reprompt installation is on hold: no evidence-approved public package is pinned.' \
    'No package was downloaded or installed. Release-owner approval is required.' >&2
  exit 78
fi
[[ "$(uname -s)" = Darwin ]] || stop 'Reprompt is for macOS.'

readonly URL="https://github.com/kaiteddy/reprompt/releases/download/$RELEASE_TAG/Reprompt.zip"
STAGE=$(mktemp -d "${TMPDIR:-/tmp}/reprompt-install.XXXXXX")
readonly STAGE
trap 'rm -rf "$STAGE"' EXIT
trap 'exit 130' HUP INT TERM
readonly ARCHIVE="$STAGE/Reprompt.zip"
printf 'Downloading approved Reprompt %s…\n' "$RELEASE_TAG"
if ! curl --proto '=https' --proto-redir '=https' --tlsv1.2 \
    --connect-timeout 15 --max-time 300 --retry 0 -fsSL "$URL" -o "$ARCHIVE"; then
  stop 'Package download failed; nothing was installed.'
fi
[[ -s "$ARCHIVE" ]] || stop 'Package download was empty; nothing was installed.'
ACTUAL_SHA=$(shasum -a 256 "$ARCHIVE")
[[ "${ACTUAL_SHA%% *}" = "$ARCHIVE_SHA256" ]] \
  || stop 'Package digest did not match the approved release; nothing was extracted or installed.'

if ! ditto -x -k "$ARCHIVE" "$STAGE/unpacked"; then
  stop 'Package extraction failed; nothing was installed.'
fi
readonly PACKAGE="$STAGE/unpacked/Reprompt"
readonly PAYLOAD="$PACKAGE/payload"
readonly INSTALLER="$PACKAGE/Install Reprompt.command"
readonly PROVENANCE="$PAYLOAD/package.provenance.json"
[[ -d "$PACKAGE" && ! -L "$PACKAGE" && -d "$PAYLOAD" && ! -L "$PAYLOAD" \
    && -f "$PAYLOAD/VERSION" && ! -L "$PAYLOAD/VERSION" \
    && -f "$PROVENANCE" && ! -L "$PROVENANCE" \
    && -f "$INSTALLER" && ! -L "$INSTALLER" ]] \
  || stop 'Package evidence or installer is missing; nothing was installed.'
[[ "$(<"$PAYLOAD/VERSION")" = "$RELEASE_TAG" ]] \
  || stop 'Package version did not match the approved release; nothing was installed.'
PACKAGE_SCHEMA=$(plutil -extract schema_version raw -o - "$PROVENANCE" 2>/dev/null) \
  || stop 'Package provenance could not be read; nothing was installed.'
PACKAGE_COMMIT=$(plutil -extract git_commit raw -o - "$PROVENANCE" 2>/dev/null) \
  || stop 'Package source provenance could not be read; nothing was installed.'
[[ "$PACKAGE_SCHEMA" = 1 && "$PACKAGE_COMMIT" = "$SOURCE_COMMIT" ]] \
  || stop 'Package source provenance did not match the approved release; nothing was installed.'
CLOSURE=$(plutil -extract runtime_closure raw -o - "$PROVENANCE" 2>/dev/null) \
  || stop 'Sealed runtime evidence is missing; nothing was installed.'
[[ "$CLOSURE" = true ]] || stop 'Only a sealed Compass runtime may be installed.'

# The digest pins every archive byte. The manifest/version checks prevent a
# reviewed pin from silently naming a different product source or version.
# They do not constitute live compatibility, install, or product-quality proof.
# The packaged installer verifies the app and preserves the previous bundle.
if ! bash "$INSTALLER"; then
  stop 'The approved installer reported failure. Inspect its output before retrying.'
fi
