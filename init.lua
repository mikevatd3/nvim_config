-- BASICS
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.wrap = false
vim.opt.scrolloff = 6
vim.opt.sidescrolloff = 4
vim.opt.hidden = true
vim.opt.laststatus = 3
vim.opt.clipboard = 'unnamedplus'

-- KEYMAPS
-- Template:
-- vim.api.nvim_set_keymap({mode}, {keymap}, {mapped to}, {options})
vim.g.mapleader = ' '
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }
keymap('n', '<leader>w', ':w<CR>', opts)
keymap('n', '<leader>wq', ':wq<CR>', opts)
keymap('n', '<leader>q', ':w<CR>:Explore<CR>', opts)
keymap('n', '<leader>b', ':q!<CR>', opts)
keymap('n', '<leader>o', 'o<ESC>', opts)
keymap('n', '<leader>O', 'O<ESC>', opts)
keymap('n', '<c-j>', '<c-w><c-w>', opts)
keymap('n', '<c-h>', '<c-w>h', opts)
keymap('n', '<c-l>', '<c-w>l', opts)
keymap('n', '<C-s>v', ':vsplit .<CR>', opts)
keymap('n', '<C-s>h', ':split .<CR>', opts)
keymap('n', '<leader>m', ':w<CR>:make<CR>', opts)
keymap('n', '<leader>h', ':noh<CR>', opts)
keymap('n', '<leader>gpd', ':lua require("goto-preview").goto_preview_definition()<CR>', opts)
keymap('n', '<leader>gpt', ':lua require("goto-preview").goto_preview_type_definition()<CR>', opts)
keymap('n', '<leader>v', '"*p', opts)
keymap('v', '<leader>p', '\"_dP', opts)
keymap('v', '<leader>w', ':w !wc -w<CR>', opts)
keymap('v', '<leader>c', ':w !xclip -selection clipboard<CR>', opts)
keymap('n', '<leader><leader>s', '<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>', opts)
keymap('v', '<leader>oe', ':s/\\(.*\\)/', opts)
keymap('n', '\\n', ':bnext<CR>', opts)
keymap('n', '\\p', ':bprevious<CR>', opts)
keymap('v', '<leader>qp', '!python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.stdin.read()))<CR>', opts)
keymap('v', '<leader>sn', ':s/\\%V\\([a-z]\\)\\([A-Z]\\)/\\1_\\l\\2/g<CR>gvu', opts)
keymap('n', '<leader>t', ':r !tspmdt "<C-r>0"<CR>', opts)
keymap('v', 'J', ":m '>+1<CR>gv=gv", opts)
keymap('v', 'K', ":m '<-2<CR>gv=gv", opts)
keymap('n', '<leader>j', ":TSJToggle<CR>", opts)

-- This is a silly plugin
keymap('x', 'R', "!flopper<CR>gv", opts)

require("config.lazy")

-- Set up the language server

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require("mason").setup() -- again, an installer tool

-- Appearance

vim.cmd[[let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro']]
vim.cmd[[colorscheme everforest]]
vim.cmd[[set shellcmdflag=-ic]]
vim.opt.background = "dark"

-- Set the color column at 80 characters
vim.opt.colorcolumn = "73,80"

require("plugins.lsps")
require("plugins.cmp")
require("plugins.luasnip")
require("plugins.gotopreview")
require("plugins.lualine")
require("plugins.ts")
require("plugins.treesj")

vim.g.loaded_python3_provider = 0

-- Telescope setup
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>fB', ":Telescope bibtex<CR>", {})
