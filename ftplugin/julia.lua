local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

keymap('n', '<leader>m', ':w<CR>:! julia %<CR>', opts)
