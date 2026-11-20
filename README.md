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

The full herdr → Rex key mapping, the session mode, and the extra keys live in
[keymaps.md](./keymaps.md).

Default prefix: `ctrl+b`. Change it by editing the `setup` call in `init.lua`:

```lua
dofile("/absolute/path/to/herdr-keybindings.lua").setup({ prefix = "ctrl+a" })
```

Reinstalling keeps the prefix already in the file.

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
rex config check      # expect 65 bindings and 2 modes, plus 2 removals with rex_defaults
rex config reload
rex keymap
```
