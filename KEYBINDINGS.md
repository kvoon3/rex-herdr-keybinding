# herdr to Rex keybinding map

This table records where each herdr default binding lands in Rex. The goal is shared muscle memory, not a one-to-one copy of everything.

`herdr-keybindings.lua` is the implementation. This file is its ledger. Change one with the other.

## Status values

- **Same.** herdr has an action of the same name, and Rex does the same thing on the same key.
- **Adapted.** The key is kept but the action differs, or Rex only offers a close equivalent.
- **Not ported.** Rex has no equivalent action, or binding one would not help.
- **N/A.** A herdr action that is unbound by default, with no matching need here.

## Sources

herdr defaults come from running `herdr --default-config` on this machine. The documented swap-pane and copy-mode bindings come from https://herdr.dev/tui/docs/keyboard/ . Rex action names come from `rex -C "<client>" actions`. Effective keys come from `rex keymap`.

Both sides use the same prefix. herdr is `ctrl+b` then a key. Rex writes that as `ctrl+b>key`. The tables below show only the key after the prefix.

## Panes

| herdr key | herdr action | Rex key | Rex action | Status |
| --- | --- | --- | --- | --- |
| `h` `j` `k` `l` | Focus pane in four directions | `h` `j` `k` `l` | `pane.focus` | Same |
| `tab` / `shift+tab` | Next / previous pane | `tab` / `shift+tab` | `pane.focus_next` / `pane.focus_previous` | Same |
| `v` | Split vertical | `v` | `pane.split` direction=right | Same |
| `minus` | Split horizontal | `-` | `pane.split` direction=down | Same |
| `x` | Close pane | `x` | `pane.close` | Same |
| `z` | Zoom pane | `z` | `pane.zoom` | Same |
| `r` | Enter resize mode | `r` | `client.mode.enter` name=resize | Same |
| `h` `j` `k` `l` inside resize mode | Resize pane | `h` `j` `k` `l` inside resize mode | `pane.resize` | Same |
| `enter` inside resize mode | Leave resize mode | `enter` inside resize mode | `client.mode.exit` | Same |
| `shift+h` `shift+j` `shift+k` `shift+l` | Swap panes | `shift+h` `shift+j` `shift+k` `shift+l` | `pane.move` | Adapted |
| `[` | Copy mode | `[` | `client.find.open` | Adapted |
| `shift+p` | Rename pane | `shift+p` | `pane.rename` | Same |

`pane.move` moves a pane in a direction. herdr swaps it with its neighbor. The two agree in simple layouts and can differ in nested ones. This is inferred from the action names and has not been tested layout by layout.

Rex has no copy mode. `[` lands on Rex's own find, and scrolling and selection stay with Rex's native behavior.

## Tabs

| herdr key | herdr action | Rex key | Rex action | Status |
| --- | --- | --- | --- | --- |
| `c` | New tab | `c` | `client.tab.new` | Same |
| `n` / `p` | Next / previous tab | `n` / `p` | `client.tab.next` / `client.tab.previous` | Same |
| `1` through `9` | Jump to tab N | `1` through `9` | `client.tab.goto` | Same |
| `shift+t` | Rename tab | `shift+t` | `client.tab.rename` | Same |
| `shift+x` | Close tab | `shift+x` | `client.tab.close` | Same |

`client.tab.goto` uses a one-based index. `index=1` goes to the first tab and `index=3` to the third. This was measured on a live client.

## Workspace and session

A herdr workspace maps to a Rex session.

| herdr key | herdr action | Rex key | Rex action | Status |
| --- | --- | --- | --- | --- |
| `w` | Workspace picker | `w` | `session.switch` | Same |
| `shift+n` | New workspace | `shift+n` | `session.new` | Same |
| `shift+w` | Rename workspace | `shift+w` | `session.rename` | Same |
| `shift+d` | Close workspace | `shift+d` | `session.close` | Same |
| `g` | Goto picker | `g` | `pane.go_to` | Same |

## Global

| herdr key | herdr action | Rex key | Rex action | Status |
| --- | --- | --- | --- | --- |
| `s` | Settings | `s` | `client.settings` | Same |
| `shift+r` | Reload config | `shift+r` | `client.config.reload` | Same |
| `b` | Toggle sidebar | `b` | `client.sidebar.toggle` | Same |
| `?` | Keybinding help panel | `?` | `client.palette.toggle` | Adapted |
| `q` | Detach, programs keep running | `q` | `client.visibility.toggle` | Adapted |

Rex has no keybinding help overlay, so the command palette is the closest entry point. Rex also has no detach, so `q` only hides the window.

## Custom bindings

These come from a personal `~/.config/herdr/config.toml`, under `[[keys.command]]`.

| herdr key | herdr action | Rex key | Rex action | Status |
| --- | --- | --- | --- | --- |
| `t` | Floating terminal popup | `t` | `pane.new_floating` | Adapted |
| `space` | herdr command palette plugin | none | none | Not ported |
| `]` | lazygit in a temporary pane | none | none | Not ported |
| `}` | hunk diff popup | none | none | Not ported |
| `u` | usage plugin | none | none | Not ported |

The last four bind herdr plugins. They belong to that herdr config and stay out of this map.

## Not ported, with reasons

| herdr key | herdr action | Reason |
| --- | --- | --- |
| `o` | Jump to notification source | Rex has no equivalent jump back to a notification |
| `shift+g` | New worktree | Rex has no worktree action |
| `e` | Edit scrollback | Rex has no equivalent editor entry point |
| `up` / `down` in navigate mode | Move across workspaces | Rex has no navigate mode |
| `ctrl+alt+*` | Prefix-free direct chords | Only the prefix scheme is built so far |

## Actions unbound by default

These herdr actions ship with no binding, and nothing here needs them. They stay empty. `open_worktree`, `remove_worktree`, `previous_workspace`, `next_workspace`, `previous_agent`, `next_agent`, `focus_agent`, `move_tab_previous`, `move_tab_next`, `switch_workspace`, `clear_pane`, `last_pane`, and `resize_pane_left/down/up/right`. Status is N/A.

## Rex-only additions

| Rex key | Rex action | Note |
| --- | --- | --- |
| `ctrl+b` then `ctrl+b` | `pane.send_key` key=ctrl+b | Sends the prefix through to the pane, the tmux convention |

## Verify

Run these after a change, against a live Rex.

```sh
rex config check      # binding, mode and action counts
rex config reload     # apply the file
rex keymap            # list every effective binding
```

The current baseline is 48 bindings, 1 mode, and 9 actions from the leaf plugin. A different number means a binding was added or removed, so update this table in the same change.

## Maintenance

Before adding a binding, confirm the action name in `rex -C "<client>" actions`. Write it into the keymap, then add a row here. An action name that does not exist fails when Rex loads the file, so the table and the keymap cannot drift silently.

After a herdr upgrade, re-run `herdr --default-config` and compare its defaults against this table.
