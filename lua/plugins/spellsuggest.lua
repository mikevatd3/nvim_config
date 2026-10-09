local M = {}

function M.suggest()
  local bad = vim.fn.spellbadword()[1]
  if bad == "" then
    vim.notify("No misspelled word found", vim.log.levels.INFO)
    return
  end

  local suggestions = vim.fn.spellsuggest(bad, 5)
  if #suggestions == 0 then
    vim.notify("No suggestions for: " .. bad, vim.log.levels.INFO)
    return
  end

  local main_buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1] - 1, cursor[2]

  local lines = {}
  local width = 20
  for i, s in ipairs(suggestions) do
    lines[i] = string.format("%d. %s", i, s)
    width = math.max(width, #lines[i] + 2)
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "cursor",
    row = 1, col = 0,
    width = width,
    height = #lines,
    style = "minimal",
    border = "rounded",
  })

  local function replace_with(choice)
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_buf_set_text(main_buf, row, col, row, col + #bad, { choice })
  end

  local opts = { buffer = buf, nowait = true }
  vim.keymap.set("n", "q", function() vim.api.nvim_win_close(win, true) end, opts)
  vim.keymap.set("n", "<Esc>", function() vim.api.nvim_win_close(win, true) end, opts)
  vim.keymap.set("n", "<CR>", function()
    local idx = vim.api.nvim_win_get_cursor(win)[1]
    replace_with(suggestions[idx])
  end, opts)
  for i, s in ipairs(suggestions) do
    vim.keymap.set("n", tostring(i), function() replace_with(s) end, opts)
  end
end

return M
