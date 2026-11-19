#!/bin/sh
set -eu

repo="https://raw.githubusercontent.com/kvoon3/rex-herdr-keybinding/main"
config="${REX_CONFIG:-${XDG_CONFIG_HOME:-$HOME/.config}/rex/init.lua}"
start="-- >>> rex-herdr-keybinding >>>"
end="-- <<< rex-herdr-keybinding <<<"

src=""
if [ -f "${0:-}" ]; then
  dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
  if [ -f "$dir/herdr-keybindings.lua" ]; then
    src="$dir/herdr-keybindings.lua"
  fi
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

if [ -n "$src" ]; then
  keymap="$src"
else
  keymap="$tmp/herdr-keybindings.lua"
  curl -fsSL "$repo/herdr-keybindings.lua" -o "$keymap"
fi

mkdir -p "$(dirname -- "$config")"
[ -f "$config" ] || : > "$config"
cp "$config" "$config.bak"

awk -v s="$start" -v e="$end" '
  $0 == s { skip = 1; next }
  $0 == e { skip = 0; next }
  skip != 1 { print }
' "$config" > "$tmp/init.lua"

{
  printf '\n%s\n' "$start"
  cat "$keymap"
  printf '%s\n' "$end"
} >> "$tmp/init.lua"

mv "$tmp/init.lua" "$config"

printf 'Installed herdr keybindings into %s\n' "$config"
printf 'Backup written to %s.bak\n' "$config"
printf 'Next: rex config check && rex config reload\n'
