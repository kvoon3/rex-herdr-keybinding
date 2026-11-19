#!/bin/sh
set -eu

repo="https://raw.githubusercontent.com/kvoon3/rex-herdr-keybinding/main"
config="${REX_CONFIG:-${XDG_CONFIG_HOME:-$HOME/.config}/rex/init.lua}"
dir="${REX_PLUGIN_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/rex/plugins/rex-herdr-keybinding}"
start="-- >>> rex-herdr-keybinding >>>"
end="-- <<< rex-herdr-keybinding <<<"

src=""
if [ -f "${0:-}" ]; then
  here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
  if [ -f "$here/herdr-keybindings.lua" ]; then
    src="$here/herdr-keybindings.lua"
  fi
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

mkdir -p "$dir"
if [ -n "$src" ]; then
  cp "$src" "$dir/herdr-keybindings.lua"
else
  curl -fsSL "$repo/herdr-keybindings.lua" -o "$dir/herdr-keybindings.lua"
fi

mkdir -p "$(dirname -- "$config")"
[ -f "$config" ] || : > "$config"
cp "$config" "$config.bak"

awk -v s="$start" -v e="$end" '
  $0 == s { skip = 1; next }
  $0 == e { skip = 0; next }
  skip != 1 { print }
' "$config" > "$tmp/stripped.lua"

awk '
  { line[NR] = $0 }
  END {
    last = NR
    while (last > 0 && line[last] ~ /^[[:space:]]*$/) last--
    for (i = 1; i <= last; i++) print line[i]
  }
' "$tmp/stripped.lua" > "$tmp/init.lua"

{
  printf '\n%s\n' "$start"
  printf '%s\n' "-- Managed by the rex-herdr-keybinding installer. Delete this block and $dir to remove."
  printf 'dofile("%s/herdr-keybindings.lua")\n' "$dir"
  printf '%s\n' "$end"
} >> "$tmp/init.lua"

mv "$tmp/init.lua" "$config"

printf 'Keymap written to %s/herdr-keybindings.lua\n' "$dir"
printf 'Loaded from %s\n' "$config"
printf 'Backup written to %s.bak\n' "$config"
printf 'Next: rex config check && rex config reload\n'