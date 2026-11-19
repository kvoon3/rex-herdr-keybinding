#!/bin/sh
# Kept for the old one-liner. Prefer ./rex-herdr-keybinding.
set -eu

here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
if [ -f "$here/rex-herdr-keybinding" ]; then
  exec sh "$here/rex-herdr-keybinding" "${1:-install}"
fi

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
curl -fsSL https://raw.githubusercontent.com/kvoon3/rex-herdr-keybinding/main/rex-herdr-keybinding -o "$tmp"
sh "$tmp" "${1:-install}"