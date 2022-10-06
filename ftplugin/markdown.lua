local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }


keymap('x', '<leader>si', ':lua require"sqid".web()<CR>', opts)
keymap('x', '<leader>sf', ':lua require"sqid".web_to_file()<CR>', opts)
keymap('x', '<leader>sw', ':lua require"sqid".pop_window()<CR>', opts)
keymap('x', '<leader>saw', ':lua require"sqid".askwayne()<CR>', opts)
vim.cmd[[:setlocal wrap linebreak nolist]]
vim.cmd[[:let g:vim_markdown_frontmatter = 1]]
vim.cmd[[:setlocal spell spelllang=en]]
