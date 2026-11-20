#!/bin/sh
# Checks what `install` writes into init.lua, including the case that used to
# drop unset: a config line still naming another machine's plugin path.
set -eu
cd "$(dirname -- "$0")/.."

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

install_into() {
  REX_CONFIG="$1/init.lua" \
  REX_PLUGIN_DIR="$1/plugins/rex-herdr-keybinding" \
    sh ./rex-herdr-keybinding install >/dev/null
}

fail() { printf 'FAIL: %s\n' "$1"; cat "$work/init.lua"; exit 1; }

# 1. fresh config keeps unrelated lines and gets the full setup call
printf -- '-- keep me\n' > "$work/init.lua"
install_into "$work"
grep -q 'unset = "rex_defaults"' "$work/init.lua" || fail "fresh install has no unset"
grep -qx -- '-- keep me' "$work/init.lua" || fail "unrelated lines dropped"
grep -q 'prefix = "ctrl+b"' "$work/init.lua" || fail "default prefix missing"

# 2. a line from another machine keeps its prefix, loses its path, gains unset
printf 'dofile("/Users/someone/.config/rex/plugins/rex-herdr-keybinding/herdr-keybindings.lua").setup({ prefix = "ctrl+a" })\n' > "$work/init.lua"
install_into "$work"
grep -q 'prefix = "ctrl+a"' "$work/init.lua" || fail "prefix not kept"
grep -q 'unset = "rex_defaults"' "$work/init.lua" || fail "unset dropped for a foreign path"
if grep -q '/Users/someone' "$work/init.lua"; then fail "foreign path kept"; fi
grep -q "dofile(\"$work/plugins/rex-herdr-keybinding/herdr-keybindings.lua\")" "$work/init.lua" \
  || fail "local path not written"

# 3. installing twice changes nothing
before=$(cat "$work/init.lua")
install_into "$work"
[ "$before" = "$(cat "$work/init.lua")" ] || fail "second install rewrote the file"

printf 'ok\n'
