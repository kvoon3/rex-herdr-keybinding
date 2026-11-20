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

  -- workspace
  { "w", "session.switch" },
  { "shift+n", "session.new" },
  { "shift+w", "session.rename" },
  { "shift+d", "session.close" },
  { "g", "pane.go_to" },

  -- global
  { "s", "client.settings" },
  { "shift+p", "pane.rename" },
  { "shift+r", "client.config.reload" },
  { "b", "client.sidebar.toggle" },
  { "q", "client.visibility.toggle" },
  { "[", "client.find.open" },
  { "t", "pane.new_floating" },

  -- additional
  { "f", "pane.go_to" },
  { "space", "client.palette.toggle" },
  { "]", "rex_lazygit" },
}

local rex_defaults = {
  "cmd+p",
  "shift+cmd+p",
}

local function focused_block()
  local view = rex.session.view{}
  if type(view) ~= "table" then
    return nil
  end
  for _, window in ipairs(view.windows or {}) do
    if window.window_id == view.active_window_id then
      return window.focused_block_id
    end
  end
  return nil
end

local function current_dir(block_id)
  local id = block_id or focused_block()
  if id == nil then
    return nil
  end

  local result = rex.block.call("com.superlogical.terminal", "pwd", { block_id = id })
  if type(result) ~= "table" or type(result.pwd) ~= "string" then
    return nil
  end

  local path = result.pwd
  if path:sub(1, 7) == "file://" then
    path = path:sub(8)
    local slash = path:find("/", 1, true)
    if slash ~= nil then
      path = path:sub(slash)
    end
    path = path:gsub("%%(%x%x)", function(hex)
      return string.char(tonumber(hex, 16))
    end)
  end
  return path
end

local function open_lazygit(ctx)
  local _, err = rex.session.new_layer{
    bounds = { 0.04, 0.04, 0.92, 0.92 },
    focus = true,
    layout = rex.layout.block{
      flavor = "com.superlogical.terminal.shell",
      label = "lazygit",
      options = {
        command = { "lazygit" },
        cwd = current_dir(ctx and ctx.block_id),
      },
    },
  }
  if err ~= nil then
    error(err, 0)
  end
end

local function unset_keys(unset)
  if unset == nil then
    return
  end

  local target = unset
  if unset == "rex_defaults" then
    target = rex_defaults
  elseif type(unset) ~= "table" then
    error('setup: unset must be "rex_defaults" or a list of keys', 3)
  end

  for _, key in ipairs(target) do
    rex.unbind(key)
  end
end

function M.setup(opts)
  opts = opts or {}
  local prefix = opts.prefix or "ctrl+b"
  local mode = "resize"

  rex.action{
    name = "rex_lazygit",
    title = "Open lazygit",
    category = "Rex",
    keywords = "git lazygit floating",
    run = open_lazygit,
  }

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

  unset_keys(opts.unset)
end

return M