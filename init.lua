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
keymap('v', '<leader>sn', ':s/\\%V\\([a-z]\\)\\([A-Z]\\)/\\1_\\l\\2/g<CR>gvu', opts)
keymap('n', '<leader>t', ':r !tspmdt "<C-r>0"<CR>', opts)
keymap('v', '<C-j>', ":m '>+1<CR>gv=gv", opts)
keymap('v', '<C-k>', ":m '<-2<CR>gv=gv", opts)
keymap('n', '<leader>j', ":TSJToggle<CR>", opts)
keymap('v', '<leader>r', ':s/\\r//<CR>', opts)
keymap('v', '<leader>l', [[:s/\(.*\)/"\1",/<CR>:noh<CR>]], opts)
keymap('v', '<leader>d', [[:s/\(.*\)/"\1": "\L\1",/<CR>:noh<CR>]], opts)
keymap('n', '<leader>gh', ":diffget //2<CR>", opts)
keymap('n', '<leader>gl', ":diffget //3<CR>", opts)

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
require("plugins.telescope")
require("plugins.vimtex")

vim.g.loaded_python3_provider = 0

-- Telescope setup
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
-- In filetypes with no citation syntax of their own (e.g. code docstrings),
-- default <CR> to a short "Author (Year)" citation instead of a
-- bare/formatted key. <C-c> gives the full "Author (Year), Title."
-- citation everywhere (see plugins/telescope.lua).
local bibtex_readable_fts = { python = true, julia = true }
local bibtex_telescope_cfg = require('plugins.telescope')

vim.keymap.set('n', '<leader>fB', function()
  if bibtex_readable_fts[vim.bo.filetype] then
    local group = vim.api.nvim_create_augroup('BibtexReadableDefault', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'TelescopePrompt',
      group = group,
      once = true,
      callback = function(args)
        vim.keymap.set(
          'i', '<CR>',
          bibtex_telescope_cfg.insert_readable_citation(false),
          { buffer = args.buf }
        )
      end,
    })
  end
  vim.cmd('Telescope bibtex')
end, {})


-- Slime for Julia / R Pseudio
vim.g.slime_dont_ask_default = true
local window_id = tonumber(vim.env.SLIME_WINDOW_ID)
local listen_on = vim.env.SLIME_SOCKET

if window_id then
  vim.g.slime_target = "kitty"
  vim.g.slime_default_config = { window_id = window_id, listen_on = listen_on }
end


-- Wordnet
local wn = require("plugins.wordnet")
vim.keymap.set("n", "<leader>d", wn.lookup, { desc = "WordNet lookup" })
vim.keymap.set("v", "<leader>d", wn.lookup_visual, { desc = "WordNet lookup (visual)" })

-- Spelling suggestions in a floating window instead of the built-in z= prompt
local spellsuggest = require("plugins.spellsuggest")
vim.keymap.set("n", "z=", spellsuggest.suggest, { desc = "Spelling suggestions" })
