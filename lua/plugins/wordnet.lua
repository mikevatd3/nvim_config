-- ~/.config/nvim/lua/util/wordnet.lua

local M = {}

local RELATIONS = {
  { name = "Overview",  flags = { "-over" } },
  { name = "Synonyms",  flags = { "-synsn", "-synsv", "-synsa", "-synsr" } },
  { name = "Antonyms",  flags = { "-antsn", "-antsv", "-antsa", "-antsr" } },
  { name = "Hypernyms", flags = { "-hypen", "-hypev" } },
  { name = "Hyponyms",  flags = { "-hypon", "-hypov" } },
  { name = "Meronyms",  flags = { "-meron" } },
  { name = "Holonyms",  flags = { "-holon" } },
}

local WRAP_WIDTH = 60

local function wrap(s, width)
  local wrapped = {}
  for i = 1, #s, width do
    table.insert(wrapped, s:sub(i, i + width - 1))
  end
  return wrapped
end

local function render_overview(word)
  local raw = vim.fn.systemlist({ "wn", word, "-over" })

  local defs = {}
  for _, line in ipairs(raw) do
    local def = line:match("^%s*%d+%..*%-%-.*%((.+)%)%s*$")
    if def then
      table.insert(defs, def)
    end
  end

  if #defs == 0 then
    return { "No definitions found for: " .. word }
  end

  local lines = {}
  for i, d in ipairs(defs) do
    local prefix = i .. ". "
    local indent = string.rep(" ", #prefix)
    local first = true
    for _, seg in ipairs(wrap(d, WRAP_WIDTH - #prefix)) do
      table.insert(lines, first and (prefix .. seg) or (indent .. seg))
      first = false
    end
  end
  return lines
end

local function render_raw(word, name, flags)
  local cmd = { "wn", word }
  for _, f in ipairs(flags) do
    table.insert(cmd, f)
  end
  local raw = vim.fn.systemlist(cmd)

  while raw[1] and raw[1]:match("^%s*$") do
    table.remove(raw, 1)
  end
  while raw[#raw] and raw[#raw]:match("^%s*$") do
    table.remove(raw)
  end

  if #raw == 0 then
    return { "No " .. name .. " found for: " .. word }
  end
  return raw
end

local function set_float_content(win, buf, lines)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local width = 20
  for _, l in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(l))
  end
  width = math.min(width + 2, vim.o.columns - 4)
  local height = math.min(#lines, vim.o.lines - 4)

  vim.api.nvim_win_set_config(win, { width = width, height = height })
  vim.api.nvim_win_set_cursor(win, { 1, 0 })
end

local render_relation, render_category_list

render_relation = function(word, win, buf, index)
  local rel = RELATIONS[index]
  local body
  if rel.name == "Overview" then
    body = render_overview(word)
  else
    body = render_raw(word, rel.name, rel.flags)
  end

  local lines = { word .. "  [" .. rel.name .. "]  (r: switch relation)", string.rep("─", WRAP_WIDTH) }
  vim.list_extend(lines, body)

  set_float_content(win, buf, lines)

  local opts = { buffer = buf, nowait = true }
  vim.keymap.set("n", "q", "<cmd>bd!<cr>", opts)
  vim.keymap.set("n", "<Esc>", "<cmd>bd!<cr>", opts)
  vim.keymap.set("n", "r", function()
    render_category_list(word, win, buf)
  end, opts)
end

render_category_list = function(word, win, buf)
  local lines = { word, string.rep("─", 30) }
  local header_count = #lines
  for i, rel in ipairs(RELATIONS) do
    table.insert(lines, string.format("%d. %s", i, rel.name))
  end

  set_float_content(win, buf, lines)

  local opts = { buffer = buf, nowait = true }
  vim.keymap.set("n", "q", "<cmd>bd!<cr>", opts)
  vim.keymap.set("n", "<Esc>", "<cmd>bd!<cr>", opts)

  vim.keymap.set("n", "<CR>", function()
    local row = vim.api.nvim_win_get_cursor(win)[1]
    local index = row - header_count
    if RELATIONS[index] then
      render_relation(word, win, buf, index)
    end
  end, opts)

  for i = 1, #RELATIONS do
    vim.keymap.set("n", tostring(i), function()
      render_relation(word, win, buf, i)
    end, opts)
  end
end

function M.lookup(word)
  word = word or vim.fn.expand("<cword>")

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "cursor",
    row = 1, col = 0,
    width = WRAP_WIDTH,
    height = 1,
    style = "minimal",
    border = "rounded",
  })

  render_relation(word, win, buf, 1)
end

function M.lookup_visual()
  vim.cmd('normal! "vy')
  local word = vim.fn.getreg("v"):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
  M.lookup(word)
end

return M
