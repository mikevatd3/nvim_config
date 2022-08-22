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
keymap('n', '<c-j>', '<c-w><c-w>', opts)
keymap('n', '<c-h>', '<c-w>h', opts)
keymap('n', '<c-k>', '<c-w>k', opts)
keymap('n', '<c-l>', '<c-w>l', opts)
keymap('n', '<C-s>v', ':vsplit .<CR>', opts)
keymap('n', '<C-s>h', ':split .<CR>', opts)
keymap('n', '<leader>m', ':w<CR>:make<CR>', opts)
keymap('n', '<leader>h', ':noh<CR>', opts)
keymap('n', '<c-f>', ':Telescope find_files<CR>', opts)

goto_preview = require('goto-preview')

keymap('n', '<leader>gpd', ':lua require("goto-preview").goto_preview_definition()<CR>', opts)
keymap('n', '<leader>gpt', ':lua require("goto-preview").goto_preview_type_definition()<CR>', opts)

-- PACKER

local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn

-- ensure that packer is installed

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    execute 'packadd packer.nvim'
end

vim.cmd('packadd packer.nvim')

local packer = require('packer')
local util = require('packer.util')

packer.init({
    package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
})

-- startup and add configure plugins
packer.startup(function()
    local use = use
    -- add plugins here like
    -- use 'neovim/nvim-lspconfig'
    use 'nvim-lua/plenary.nvim'
    use 'wbthomason/packer.nvim'
    use 'lukas-reineke/indent-blankline.nvim'
    use 'nvim-treesitter/nvim-treesitter'
    use 'neovim/nvim-lspconfig'
    use 'anott03/nvim-lspinstall'
    use 'tpope/vim-fugitive'
    use 'tjdevries/colorbuddy.nvim'
    use 'bkegley/gloombuddy'
    use 'mfussenegger/nvim-dap'
    use 'nvim-telescope/telescope-dap.nvim'
    use 'mfussenegger/nvim-dap-python'
    use 'ms-jpq/coq.artifacts'
    use 'ms-jpq/coq.thirdparty'
    use 'ms-jpq/coq_nvim'
    use 'Mofiqul/dracula.nvim'
    use 'rmagatti/goto-preview'
    use 'sainnhe/everforest'
    use 'mivicker/sqid'
    use {
      'nvim-telescope/telescope.nvim', tag = '0.1.0',
    -- or                            , branch = '0.1.x',
      requires = { {'nvim-lua/plenary.nvim'} }
    }
 
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    end
)

require('lualine').setup {
--    options = { theme = 'everforest' }
}

require('dap-python').setup('/usr/bin/python3')


local lspconfig = require 'lspconfig'
local coq = require 'coq'

lspconfig.pyright.setup(coq.lsp_ensure_capabilities())
lspconfig.tsserver.setup(coq.lsp_ensure_capabilities())

vim.cmd[[let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro']]
vim.cmd[[
    if has('termguicolors')
      set termguicolors
    endif
    set background=dark
    let g:everforest_background = 'soft'
    let g:everforest_better_performance = 1
    colorscheme everforest
]]

require("nvim-treesitter.configs").setup({
  ensure_installed = { "markdown", "markdown_inline", ... },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "markdown" },
  },
})

require('goto-preview').setup {
  width = 120; -- Width of the floating window
  height = 15; -- Height of the floating window
  border = {"↖", "─" ,"┐", "│", "┘", "─", "└", "│"}; -- Border characters of the floating window
  default_mappings = false; -- Bind default mappings
  debug = false; -- Print debug information
  opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
  resizing_mappings = false; -- Binds arrow keys to resizing the floating window.
  post_open_hook = nil; -- A function taking two arguments, a buffer and a window to be ran as a hook.
  -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
  focus_on_open = true; -- Focus the floating window when opening it.
  dismiss_on_move = false; -- Dismiss the floating window when moving the cursor.
  force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
  bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
}
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup({
on_attach = custom_attach,
settings = {
    Lua = {
    runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        path = runtime_path,
    },
    diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
    },
    workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
    },
    -- Do not send telemetry data containing a randomized but unique identifier
    telemetry = {
        enable = false,
    },
    },
},
})

require"sqid".setup({})
