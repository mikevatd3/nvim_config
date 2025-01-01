-- Python specific keymaps
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

local last_args = nil


local function provide_args()
    local args = vim.fn.input("!python % " )
    last_args = args

    local cmd = string.format("!python %s %s", vim.fn.expand("%:p"), args)
    vim.cmd(cmd)
end


local function replay()
    local args = last_args

    local cmd = string.format("!python %s %s", vim.fn.expand("%:p"), args)
    vim.cmd(cmd)
end

keymap('n', '<leader>m', ':w<CR>:! python %<CR>', opts)

vim.keymap.set('n', '<leader><leader>M', provide_args, opts)
vim.keymap.set('n', '<leader>M', replay, opts)

keymap('n', '<leader>t', ':!pytest<CR>', opts)
keymap('n', '<leader>ds', 'o"""<CR><CR>"""<Esc>ki<Tab>', opts)
keymap('n', '<leader>Ds', 'O"""<CR><CR>"""<Esc>ki<Tab>', opts)
keymap('n', '<leader>k', ':w<CR>:!black --line-length 80 --target-version py310 %<CR>', opts)
keymap('v', '<leader>c', ":'<,'>s/^/# <CR>", opts)
keymap('v', '<leader>uc', ":'<,'>ss/^# /<CR>", opts)
