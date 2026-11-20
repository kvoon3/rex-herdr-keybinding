# rex-herdr-keybinding

Use [Herdr](https://herdr.dev) `prefix+?` keymap in [Rex](https://www.superlogical.com/rex/docs/installation)

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

```sh
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
  REX_HERDR_KEYBINDING_REF  Git ref to download the keymap from, default main

Change the prefix in the generated line: setup({ prefix = "ctrl+a" }).
```

## Keymap

Default prefix: `ctrl+b`. Change it by editing the `setup` call in `init.lua`:

```lua
dofile("/absolute/path/to/herdr-keybindings.lua").setup({ prefix = "ctrl+a" })
```

Reinstalling keeps the prefix already in the file.

| Status | Meaning |
| --- | --- |
| ✅ | supported|
| 🔶 | adapted|
| ❌ | not supported|

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
| Workspace | `w` | picker | opens session mode (see below) | 🔶 |
| Workspace | `shift+n` | new | `session.new` | ✅ |
| Workspace | `shift+w` | rename | `session.rename` | ✅ |
| Workspace | `shift+d` | close | `session.close` | ✅ |
| Workspace | `g` | goto | `pane.go_to` | ✅ |
| Global | `s` | settings | `client.settings` | ✅ |
| Global | `shift+r` | reload config | `client.config.reload` | ✅ |
| Global | `b` | toggle sidebar | `client.sidebar.toggle` | ✅ |
| Global | `?` | help panel | none, Rex shows the next keys after a prefix | ❌ |
| Global | `q` | detach | `client.visibility.toggle` | 🔶 |
| Global | `o` | notification jump | none | ❌ |
| Workspace | `shift+g` | new worktree | none | ❌ |
| Pane | `e` | edit scrollback | none | ❌ |
| Pane | navigate mode `up` / `down` | move across workspaces | none | ❌ |
| Global | `ctrl+alt+*` | prefix-free chords | none | ❌ |

### Session mode

`prefix w` enters an exclusive session mode. Press `enter` or `esc` to leave it.

| Key | Action |
| --- | --- |
| `up` | `session.previous` |
| `down` | `session.next` |
| `c` | `session.new` |
| `shift+n` | `session.new` |
| `shift+d` | `session.close` |
| `shift+w` | `session.rename` |

Adapted keys, in detail:

- `shift+h` `shift+j` `shift+k` `shift+l` move a pane in that direction. herdr swaps it with its neighbour. Both agree in simple layouts and can differ in nested ones.
- `[` opens Rex find. Rex has no copy mode, and its native scroll and selection cover the same ground.
- `q` hides the window. Rex has no detach, so running programs stay attached to the app.

## Additional

Keys that are not in herdr's default set.

| Key | Action |
| --- | --- |
| `f` | `pane.go_to` |
| `space` | `client.palette.toggle` |
| `t` | `pane.new_floating` |
| `]` | `rex_lazygit` |

The app shortcuts keep working unless you unset them. See [Unset default keys](#unset-default-keys).

## Unset default keys

```lua
dofile("/absolute/path/to/herdr-keybindings.lua").setup({
  unset = "rex_defaults"
})

-- or 

dofile("/absolute/path/to/herdr-keybindings.lua").setup({
  unset = { "cmd+r" }
})
```

## Verify

```sh
rex config check      # expect 59 bindings and 2 modes, plus 2 removals with rex_defaults
rex config reload
rex keymap
```
