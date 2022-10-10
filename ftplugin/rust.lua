-- Rust specific keymaps
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

keymap('n', '<leader>m', ':w<CR>:!cargo run<CR>', opts)
