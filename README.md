# rex-herdr-keybinding

herdr's `ctrl+b` keymap for Rex, plus a mapping table.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/kvoon3/rex-herdr-keybinding/main/rex-herdr-keybinding | sh
rex config check && rex config reload
```

Or copy [herdr-keybindings.lua](./herdr-keybindings.lua) into your Rex config directory and load it from `init.lua`:

```lua
dofile("/absolute/path/to/herdr-keybindings.lua").setup({ prefix = "ctrl+b" })
```

## Usage

```text
Usage: rex-herdr-keybinding [COMMAND]

Commands:
  install     Install the keymap and enable it (default)
  uninstall   Disable it and remove the installed files
  enable      Load the installed keymap from the config
  disable     Stop loading it, keeping the installed files
  help        Show this message

Environment:
  REX_CONFIG      Config file, default $HOME/.config/rex/init.lua
  REX_PLUGIN_DIR  Install directory, default $HOME/.config/rex/plugins/rex-herdr-keybinding

Change the prefix in the generated line: setup({ prefix = "ctrl+a" }).
```

## Keymap

Default prefix: `ctrl+b`. Change it by editing the `setup` call in `init.lua`:

```lua
dofile("/absolute/path/to/herdr-keybindings.lua").setup({ prefix = "ctrl+a" })
```

Reinstalling keeps the prefix already in the file.

- ✅ same
- 🔶 adapted 
- ➕ Rex only
- ❌ not ported

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
| Rex | `prefix` | send the prefix through | `pane.send_key` | ➕ |
| Global | `o` | notification jump | none | ❌ |
| Workspace | `shift+g` | new worktree | none | ❌ |
| Pane | `e` | edit scrollback | none | ❌ |
| Pane | navigate mode `up` / `down` | move across workspaces | none | ❌ |
| Global | `ctrl+alt+*` | prefix-free chords | none | ❌ |
| Custom | `space` | herdr palette plugin | none | ❌ |
| Custom | `]` | lazygit | none | ❌ |
| Custom | `}` | hunk diff | none | ❌ |
| Custom | `u` | usage plugin | none | ❌ |

`pane.move` moves a pane in a direction where herdr swaps it with its neighbour. The two agree in simple layouts and can differ in nested ones.

## Verify

```sh
rex config check      # expect 48 bindings and 1 mode
rex config reload
rex keymap
```
