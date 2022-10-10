-- Python specific keymaps
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

keymap('n', '<leader>m', ':w<CR>:!python %<CR>', opts)
keymap('n', '<leader>M', ':w<CR>:tabnew|read !python #<CR>:setl buftype=nofile<CR>', opts)
keymap('n', '<leader>ds', 'o"""<CR><CR>"""<Esc>ki<Tab>', opts)
keymap('n', '<leader>Ds', 'O"""<CR><CR>"""<Esc>ki<Tab>', opts)
keymap('n', '<leader>k', ':w<CR>:!black --line-length 80 %<CR>', opts)
