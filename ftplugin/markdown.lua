local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

keymap('x', '<c-i>', ':lua require"sqid".web()<CR>', opts)
vim.cmd[[:set wrap linebreak nolist]]
vim.cmd[[:let g:vim_markdown_frontmatter = 1]]
