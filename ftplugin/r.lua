local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

keymap('n', '<leader>m', ':w<CR>:bo 15split | terminal Rscript %<CR>', opts)
keymap('n', '<leader>M', ':w<CR>:bo 15split | terminal Rscript %<CR>', opts)
