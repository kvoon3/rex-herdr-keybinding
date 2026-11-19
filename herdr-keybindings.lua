-- herdr's prefix keymap for Rex. Call setup({ prefix = "ctrl+b" }) to bind it.

local M = {}

local keys = {
  -- panes
  { "z", "pane.zoom" },
  { "x", "pane.close" },
  { "shift+h", "pane.move", { direction = "left" } },
  { "shift+j", "pane.move", { direction = "down" } },
  { "shift+k", "pane.move", { direction = "up" } },
  { "shift+l", "pane.move", { direction = "right" } },
  { "tab", "pane.focus_next" },
  { "shift+tab", "pane.focus_previous" },

  -- focus
  { "h", "pane.focus", { direction = "left" } },
  { "j", "pane.focus", { direction = "down" } },
  { "k", "pane.focus", { direction = "up" } },
  { "l", "pane.focus", { direction = "right" } },

  -- splits
  { "v", "pane.split", { direction = "right" } },
  { "-", "pane.split", { direction = "down" } },

  -- tabs
  { "c", "client.tab.new" },
  { "n", "client.tab.next" },
  { "p", "client.tab.previous" },
  { "shift+t", "client.tab.rename" },
  { "shift+x", "client.tab.close" },

  -- session/workspace
  { "w", "session.switch" },
  { "shift+n", "session.new" },
  { "shift+w", "session.rename" },
  { "shift+d", "session.close" },
  { "g", "pane.go_to" },

  -- misc
  { "s", "client.settings" },
  { "shift+p", "pane.rename" },
  { "shift+r", "client.config.reload" },
  { "b", "client.sidebar.toggle" },
  { "q", "client.visibility.toggle" },
  { "shift+/", "client.palette.toggle" },
  { "t", "pane.new_floating" },
  { "[", "client.find.open" },

  -- rex only, replacing the app's cmd+p and shift+cmd+p
  { "space", "pane.go_to" },
  { "shift+space", "client.palette.toggle" },
}

local defaults = {
  "cmd+p",
  "shift+cmd+p",
}

function M.setup(opts)
  opts = opts or {}
  local prefix = opts.prefix or "ctrl+b"
  local mode = "resize"

  for _, b in ipairs(keys) do
    rex.bind(prefix .. ">" .. b[1], b[2], b[3])
  end

  for i = 1, 9 do
    rex.bind(prefix .. ">" .. tostring(i), "client.tab.goto", { index = i })
  end

  rex.bind(prefix .. ">" .. prefix, "pane.send_key", { key = prefix })

  rex.mode(mode, { exclusive = true })
  rex.bind(prefix .. ">r", "client.mode.enter", { name = mode })
  rex.bind(mode .. "/h", "pane.resize", { direction = "left" })
  rex.bind(mode .. "/j", "pane.resize", { direction = "down" })
  rex.bind(mode .. "/k", "pane.resize", { direction = "up" })
  rex.bind(mode .. "/l", "pane.resize", { direction = "right" })
  rex.bind(mode .. "/enter", "client.mode.exit")

  if opts.unset_defaults then
    for _, key in ipairs(defaults) do
      rex.unbind(key)
    end
  end

  for _, key in ipairs(opts.unbind or {}) do
    rex.unbind(key)
  end
end

return M