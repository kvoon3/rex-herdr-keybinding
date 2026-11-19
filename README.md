# rex-herdr-keybinding

herdr's `ctrl+b` keymap for Rex, plus a mapping table.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/kvoon3/rex-herdr-keybinding/main/rex-herdr-keybinding | sh -s -- install
rex config check && rex config reload
```

| Command | Effect |
| --- | --- |
| `install` | Copy the keymap to the plugin directory and enable it |
| `enable` | Add the `dofile` line to the config |
| `disable` | Remove the `dofile` line, keeping the files |
| `uninstall` | Remove the line and the plugin directory |

The CLI writes `herdr-keybindings.lua` to `~/.config/rex/plugins/rex-herdr-keybinding` and a marked block with a `dofile` line to `~/.config/rex/init.lua`, the way the `leaf` plugin loads. Every run backs the config up to `init.lua.bak` and leaves an identical file. `REX_CONFIG` and `REX_PLUGIN_DIR` change the two targets. From a checkout, run `./rex-herdr-keybinding install`.

Manual install: put `herdr-keybindings.lua` anywhere and add `dofile("/absolute/path/to/herdr-keybindings.lua")` to `init.lua`.

## Keymap

✅ same · 🔶 adapted · ➕ Rex only · ❌ not ported. Keys are what you press after the prefix.

| Area | herdr key | herdr action | Rex action | Status |
| --- | --- | --- | --- | --- |
| Pane | `h` `j` `k` `l` | focus | `pane.focus` | ✅ |
| Pane | `tab` / `shift+tab` | next / previous | `pane.focus_next` / `pane.focus_previous` | ✅ |
| Pane | `v` | split vertical | `pane.split` right | ✅ |
| Pane | `-` | split horizontal | `pane.split` down | ✅ |
| Pane | `x` | close | `pane.close` | ✅ |
| Pane | `z` | zoom | `pane.zoom` | ✅ |
| Pane | `shift+h` `shift+j` `shift+k` `shift+l` | swap | `pane.move` | 🔶 |
| Pane | `shift+p` | rename | `pane.rename` | ✅ |
| Pane | `[` | copy mode | `client.find.open` | 🔶 |
| Resize | `r` | enter resize mode | `client.mode.enter` | ✅ |
| Resize | `h` `j` `k` `l` | resize | `pane.resize` | ✅ |
| Resize | `enter` | exit | `client.mode.exit` | ✅ |
| Tab | `c` | new | `client.tab.new` | ✅ |
| Tab | `n` / `p` | next / previous | `client.tab.next` / `client.tab.previous` | ✅ |
| Tab | `1` to `9` | jump | `client.tab.goto` | ✅ |
| Tab | `shift+t` | rename | `client.tab.rename` | ✅ |
| Tab | `shift+x` | close | `client.tab.close` | ✅ |
| Workspace | `w` | picker | `session.switch` | ✅ |
| Workspace | `shift+n` | new | `session.new` | ✅ |
| Workspace | `shift+w` | rename | `session.rename` | ✅ |
| Workspace | `shift+d` | close | `session.close` | ✅ |
| Workspace | `g` | goto | `pane.go_to` | ✅ |
| Global | `s` | settings | `client.settings` | ✅ |
| Global | `shift+r` | reload config | `client.config.reload` | ✅ |
| Global | `b` | toggle sidebar | `client.sidebar.toggle` | ✅ |
| Global | `?` | help panel | `client.palette.toggle` | 🔶 |
| Global | `q` | detach | `client.visibility.toggle` | 🔶 |
| Custom | `t` | floating terminal | `pane.new_floating` | 🔶 |
| Rex | `ctrl+b` | send the prefix through | `pane.send_key` | ➕ |

`pane.move` moves a pane in a direction where herdr swaps it with its neighbour. The two agree in simple layouts and can differ in nested ones.

❌ Not ported: notification jump (`o`), new worktree (`shift+g`), scrollback editing (`e`), navigate mode, prefix-free `ctrl+alt` chords, and four herdr plugin commands.

## Verify

```sh
rex config check      # expect 48 bindings and 1 mode
rex config reload
rex keymap
```
