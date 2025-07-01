local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

keymap('n', '<leader>ds', 'r !python -c "import secrets; print(secrets.token_urlsafe())"<CR>', opts)
