# Keymap

herdr → Rex key mapping. Default prefix: `ctrl+b`. Change it by editing the
`setup` call in `init.lua`:

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
| `h` `j` `k` `l` | `pane.focus` (move focus; stays in the mode) |
| `up` / `down` | `session.previous` / `session.next` |
| `left` / `right` | `client.tab.previous` / `client.tab.next` |
| `c` / `shift+n` | `session.new` |
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

The app shortcuts keep working unless you unset them. See
[Unset default keys](./README.md#unset-default-keys).
