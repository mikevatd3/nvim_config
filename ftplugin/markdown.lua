local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

vim.api.nvim_create_user_command('Notes', function(opts)
    local lines = vim.fn.line('$')
    vim.wo.scrollbind = true
    vim.cmd('rightbelow 60vsplit ' .. opts.args)
    -- Set after the split: the markdown ftplugin re-runs for the new buffer
    -- and would otherwise reset this to 80.
    vim.bo.textwidth = 49
    local missing = lines - vim.fn.line('$')
    if missing > 0 then
        local pad = {}
        for i = 1, missing do pad[i] = '' end
        vim.api.nvim_buf_set_lines(0, -1, -1, false, pad)
    end
    vim.wo.scrollbind = true
    vim.cmd('syncbind')
end, { nargs = 1, complete = 'file' })

-- This will add .md to the file search
vim.opt_local.suffixesadd:append(".md")

-- This will try to find the file first, then create a new markdown file if it doesn't yet exist.
vim.keymap.set('n', 'gf', function()
  local ok = pcall(vim.cmd, 'normal! gf')
  if not ok then
    local file = vim.fn.expand('<cfile>')
    if not file:match('%.md$') then
      file = file .. '.md'
    end
    vim.cmd('e ' .. file)
  end
end)

vim.cmd[[set textwidth=80]]
vim.cmd[[:setlocal linebreak nolist]]
vim.cmd[[:let g:vim_markdown_frontmatter = 1]]
vim.cmd[[:setlocal spell spelllang=en]]
