local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }


keymap('x', '<c-i>', ':lua require"sqid".web()<CR>', opts)
keymap('x', '<a-i>', ':lua require"sqid".web_to_file()<CR>', opts)
vim.cmd[[:setlocal wrap linebreak nolist]]
vim.cmd[[:COQnow -s]]
vim.cmd[[:let g:vim_markdown_frontmatter = 1]]
vim.cmd[[:setlocal spell spelllang=en]]
