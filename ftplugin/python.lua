vim.cmd('COQnow -s')
vim.cmd[[:setl makeprg=python3\ %]]

-- Pyhton specific keymaps
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

keymap('n', '<leader>ds', 'o"""<CR><CR>"""<Esc>ki<Tab>', opts)
keymap('n', '<leader>Ds', 'O"""<CR><CR>"""<Esc>ki<Tab>', opts)
keymap('n', '<leader>k', ':!black %', opts)
