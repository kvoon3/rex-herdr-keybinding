-- herdr's prefix keymap for Rex. Call setup({ prefix = "ctrl+b" }) to bind it.

local M = {}

local sections = {
  {
    name = "panes",
    keys = {
      { "z", "pane.zoom" },
      { "x", "pane.close" },
      { "shift+h", "pane.move", { direction = "left" } },
      { "shift+j", "pane.move", { direction = "down" } },
      { "shift+k", "pane.move", { direction = "up" } },
      { "shift+l", "pane.move", { direction = "right" } },
      { "tab", "pane.focus_next" },
      { "shift+tab", "pane.focus_previous" },
    },
  },
  {
    name = "focus",
    keys = {
      { "h", "pane.focus", { direction = "left" } },
      { "j", "pane.focus", { direction = "down" } },
      { "k", "pane.focus", { direction = "up" } },
      { "l", "pane.focus", { direction = "right" } },
    },
  },
  {
    name = "splits",
    keys = {
      { "v", "pane.split", { direction = "right" } },
      { "-", "pane.split", { direction = "down" } },
    },
  },
  {
    name = "tabs",
    keys = {
      { "c", "client.tab.new" },
      { "n", "client.tab.next" },
      { "p", "client.tab.previous" },
      { "shift+t", "client.tab.rename" },
      { "shift+x", "client.tab.close" },
    },
  },
  {
    name = "workspace",
    keys = {
      { "w", "session.switch" },
      { "shift+n", "session.new" },
      { "shift+w", "session.rename" },
      { "shift+d", "session.close" },
      { "g", "pane.go_to" },
    },
  },
  {
    name = "global",
    keys = {
      { "s", "client.settings" },
      { "shift+p", "pane.rename" },
      { "shift+r", "client.config.reload" },
      { "b", "client.sidebar.toggle" },
      { "q", "client.visibility.toggle" },
      { "[", "client.find.open" },
      { "t", "pane.new_floating" },
      { "shift+/", "herdr_keybindings" },
    },
  },
  {
    name = "additional",
    keys = {
      { "space", "pane.go_to" },
      { "shift+space", "client.palette.toggle" },
    },
  },
}

local resize = {
  { "h", "pane.resize", { direction = "left" } },
  { "j", "pane.resize", { direction = "down" } },
  { "k", "pane.resize", { direction = "up" } },
  { "l", "pane.resize", { direction = "right" } },
}

local rex_defaults = {
  "cmd+p",
  "shift+cmd+p",
}

local function detail(args)
  if args == nil then
    return ""
  end
  local parts = {}
  for _, value in pairs(args) do
    parts[#parts + 1] = tostring(value)
  end
  table.sort(parts)
  if #parts == 0 then
    return ""
  end
  return " " .. table.concat(parts, " ")
end

local function render(prefix)
  local rows = {}
  local width = 0

  local function add(key, text)
    rows[#rows + 1] = { key, text }
    if #key > width then
      width = #key
    end
  end

  local function header(name)
    rows[#rows + 1] = name
  end

  for _, section in ipairs(sections) do
    header(section.name)
    for _, b in ipairs(section.keys) do
      add(prefix .. ">" .. b[1], b[2] .. detail(b[3]))
    end
  end

  header("tabs 1 to 9")
  add(prefix .. ">1..9", "client.tab.goto")

  header("resize mode")
  add(prefix .. ">r", "client.mode.enter resize")
  for _, b in ipairs(resize) do
    add(b[1], b[2] .. detail(b[3]))
  end
  add("enter", "client.mode.exit")

  header("prefix")
  add(prefix .. ">" .. prefix, "pane.send_key " .. prefix)

  local lines = { "herdr keybindings", "prefix: " .. prefix }
  for _, row in ipairs(rows) do
    if type(row) == "string" then
      lines[#lines + 1] = ""
      lines[#lines + 1] = row
    else
      lines[#lines + 1] = string.format("  %-" .. width .. "s  %s", row[1], row[2])
    end
  end
  return table.concat(lines, "\n")
end

local function show(prefix)
  local path = (os.getenv("TMPDIR") or "/tmp") .. "/rex-herdr-keybindings.txt"
  local file, err = io.open(path, "w")
  if file == nil then
    error(err, 0)
  end
  file:write(render(prefix), "\n")
  file:close()

  local _, call_err = rex.session.new_layer{
    bounds = { 0.08, 0.06, 0.84, 0.88 },
    focus = true,
    layout = rex.layout.block{
      flavor = "com.superlogical.terminal.shell",
      label = "keybindings",
      options = {
        command = { "less", "-R", path },
        shell = "none",
      },
    },
  }
  if call_err ~= nil then
    error(call_err, 0)
  end
end

local function unset_keys(unset)
  if unset == nil then
    return
  end

  local keys = unset
  if unset == "rex_defaults" then
    keys = rex_defaults
  elseif type(unset) ~= "table" then
    error('setup: unset must be "rex_defaults" or a list of keys', 3)
  end

  for _, key in ipairs(keys) do
    rex.unbind(key)
  end
end

function M.setup(opts)
  opts = opts or {}
  local prefix = opts.prefix or "ctrl+b"
  local mode = "resize"

  rex.action{
    name = "herdr_keybindings",
    title = "Show herdr keybindings",
    category = "Keybindings",
    keywords = "help keys shortcuts prefix",
    run = function()
      show(prefix)
    end,
  }

  for _, section in ipairs(sections) do
    for _, b in ipairs(section.keys) do
      rex.bind(prefix .. ">" .. b[1], b[2], b[3])
    end
  end

  for i = 1, 9 do
    rex.bind(prefix .. ">" .. tostring(i), "client.tab.goto", { index = i })
  end

  rex.bind(prefix .. ">" .. prefix, "pane.send_key", { key = prefix })

  rex.mode(mode, { exclusive = true })
  rex.bind(prefix .. ">r", "client.mode.enter", { name = mode })
  for _, b in ipairs(resize) do
    rex.bind(mode .. "/" .. b[1], b[2], b[3])
  end
  rex.bind(mode .. "/enter", "client.mode.exit")

  unset_keys(opts.unset)
end

return M