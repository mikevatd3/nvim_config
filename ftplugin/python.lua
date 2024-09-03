-- Python specific keymaps
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

keymap('n', '<leader>m', ':w<CR>:! python %<CR>', opts)
keymap('n', '<leader>t', ':!pytest<CR>', opts)
keymap('n', '<leader>M', ':w<CR>:tabnew|read !python #<CR>:setl buftype=nofile<CR>', opts)
keymap('n', '<leader>ds', 'o"""<CR><CR>"""<Esc>ki<Tab>', opts)
keymap('n', '<leader>Ds', 'O"""<CR><CR>"""<Esc>ki<Tab>', opts)
keymap('n', '<leader>k', ':w<CR>:!black --line-length 80 --target-version py310 %<CR>', opts)
keymap('v', '<leader>c', ":'<,'>s/^/# <CR>", opts)
keymap('v', '<leader>uc', ":'<,'>ss/^# /<CR>", opts)
