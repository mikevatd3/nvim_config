vim.keymap.set('v', '<leader>sc', function()
  vim.cmd('normal! "xy')
  local sql = vim.fn.getreg('x')
  local dsn = vim.b.db
  
  if not dsn then
    vim.notify('No database connection (b:db)', vim.log.levels.ERROR)
    return
  end
  
  local result = vim.fn.system({'postgrease', 'columns', '--dsn', dsn}, sql)
  
  if vim.v.shell_error ~= 0 then
    vim.notify('postgrease failed: ' .. result, vim.log.levels.ERROR)
    return
  end
  
  local lines = vim.split(result, '\n', { trimempty = true })
  local start_line = vim.api.nvim_buf_line_count(0)
  vim.api.nvim_buf_set_lines(0, -1, -1, false, lines)
  local end_line = vim.api.nvim_buf_line_count(0)
  
  vim.cmd(string.format('normal! %dGV%dG', start_line + 1, end_line))
end)
