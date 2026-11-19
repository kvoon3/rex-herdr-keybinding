# rex-herdr-keybinding

herdr's `ctrl+b` keymap for Rex, plus a mapping table.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/kvoon3/rex-herdr-keybinding/main/install.sh | sh
rex config check && rex config reload
```

The script writes the keymap into `~/.config/rex/init.lua` inside a marked block, backs the file up to `init.lua.bak`, and is safe to re-run. Set `REX_CONFIG` to target a different file.

Manual install: copy `herdr-keybindings.lua` into `init.lua`, or load it with `dofile`. Keep any plugin-managed block where it is.

## Keymap

Status is `same`, `adapted`, or `rex only`. Keys are what you press after the prefix.

| Area | herdr key | herdr action | Rex action | Status |
| --- | --- | --- | --- | --- |
| Pane | `h` `j` `k` `l` | focus | `pane.focus` | same |
| Pane | `tab` / `shift+tab` | next / previous | `pane.focus_next` / `pane.focus_previous` | same |
| Pane | `v` | split vertical | `pane.split` right | same |
| Pane | `-` | split horizontal | `pane.split` down | same |
| Pane | `x` | close | `pane.close` | same |
| Pane | `z` | zoom | `pane.zoom` | same |
| Pane | `shift+h` `shift+j` `shift+k` `shift+l` | swap | `pane.move` | adapted |
| Pane | `shift+p` | rename | `pane.rename` | same |
| Pane | `[` | copy mode | `client.find.open` | adapted |
| Resize | `r` | enter resize mode | `client.mode.enter` | same |
| Resize | `h` `j` `k` `l` | resize | `pane.resize` | same |
| Resize | `enter` | exit | `client.mode.exit` | same |
| Tab | `c` | new | `client.tab.new` | same |
| Tab | `n` / `p` | next / previous | `client.tab.next` / `client.tab.previous` | same |
| Tab | `1` to `9` | jump | `client.tab.goto` | same |
| Tab | `shift+t` | rename | `client.tab.rename` | same |
| Tab | `shift+x` | close | `client.tab.close` | same |
| Workspace | `w` | picker | `session.switch` | same |
| Workspace | `shift+n` | new | `session.new` | same |
| Workspace | `shift+w` | rename | `session.rename` | same |
| Workspace | `shift+d` | close | `session.close` | same |
| Workspace | `g` | goto | `pane.go_to` | same |
| Global | `s` | settings | `client.settings` | same |
| Global | `shift+r` | reload config | `client.config.reload` | same |
| Global | `b` | toggle sidebar | `client.sidebar.toggle` | same |
| Global | `?` | help panel | `client.palette.toggle` | adapted |
| Global | `q` | detach | `client.visibility.toggle` | adapted |
| Custom | `t` | floating terminal | `pane.new_floating` | adapted |
| Rex | `ctrl+b` | send the prefix through | `pane.send_key` | rex only |

`pane.move` moves a pane in a direction where herdr swaps it with its neighbour. The two agree in simple layouts and can differ in nested ones.

Not ported: notification jump (`o`), new worktree (`shift+g`), scrollback editing (`e`), navigate mode, prefix-free `ctrl+alt` chords, and four herdr plugin commands.

## Verify

```sh
rex config check      # expect 48 bindings and 1 mode
rex config reload
rex keymap
```
