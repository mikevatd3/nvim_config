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
vim.g.python3_host_prog = '~/.config/nvim/env/bin/python3.10'
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
keymap('n', '<c-f>', ':Telescope find_files<CR>', opts)
keymap('n', '<c-c>', ':Telescope live_grep<CR>', opts)
keymap('n', '<leader>gpd', ':lua require("goto-preview").goto_preview_definition()<CR>', opts)
keymap('n', '<leader>gpt', ':lua require("goto-preview").goto_preview_type_definition()<CR>', opts)
keymap('n', '<leader>v', '"*p', opts)
keymap('v', '<leader>p', '\"_dP', opts)
keymap('v', '<leader>c', ':w !xclip -selection clipboard<CR>', opts)
keymap('n', '<leader><leader>s', '<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>', opts)
keymap('v', '<leader>oe', ':s/\\(.*\\)/', opts)
keymap('n', '\\n', ':bnext<CR>', opts)
keymap('n', '\\p', ':bprevious<CR>', opts)

require("config.lazy")


-- Set up the language server

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require("mason").setup() -- again, an installer tool

local lspconfig = require 'lspconfig'
lspconfig.pyright.setup{} -- For python


local function jl_on_attach(client, bufnr)
  -- Example keybindings for LSP functions
  local buf_set_keymap = vim.api.nvim_buf_set_keymap
  local opts = { noremap=true, silent=true }

  buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap(bufnr, 'n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap(bufnr, 'n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
end


-- Julia apparently requires a ton of extra work to set up properly
lspconfig.julials.setup{
    cmd = {"julia", "--project=@nvim_lsp", "-e", [[
        using LanguageServer; using Pkg; import SymbolServer;
        env_path = dirname(Pkg.Types.Context().env.project_file);
        server = LanguageServer.LanguageServerInstance(stdin, stdout, env_path);
        server.runlinter = true;
        run(server);
    ]]},
    on_attach = jl_on_attach,
    flags = {
        debounce_text_changes = 150,
    }
}


vim.lsp.set_log_level("debug") -- This is for julia for some reason

lspconfig.lua_ls.setup({ -- For lua
    on_attach = custom_attach,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                path = runtime_path,
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

-- Completion set up
local cmp = require "cmp"

cmp.setup {
  mapping = {
    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<tab>"] = cmp.config.disable,
    ["<c-q>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },
  sources = {
    { name = "nvim_lua" },
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "luasnip" },
    { name = "buffer", keyword_length = 5 },
  },

  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,

      function(entry1, entry2)
        local _, entry1_under = entry1.completion_item.label:find "^_+"
        local _, entry2_under = entry2.completion_item.label:find "^_+"
        entry1_under = entry1_under or 0
        entry2_under = entry2_under or 0
        if entry1_under > entry2_under then
          return false
        elseif entry1_under < entry2_under then
          return true
        end
      end,

      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },

  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  experimental = {
    native_menu = false,
    ghost_text = true,
  },
}

cmp.setup.filetype({ "sql" }, {
    sources = {
        { name = "vim-dadbod-completion" },
        { name = "buffer" },
    }
})

-- Snippets set up

local ls = require("luasnip")
local types = require("luasnip.util.types")

ls.config.set_config {
    history = true,
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = true,
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = { { "<-", "Error" } },
            },
        },
    },
}

vim.keymap.set({ "i", "s" }, "<C-k>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, { silent = true })


--[[
vim.keymap.set({ "i", "s" }, "<c-K>", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { silent = true })
]]


vim.keymap.set({ "i", "s" }, "<C-l>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end)

-- Go to preview setup
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

-- Appearance

require('lualine').setup({})

vim.cmd[[let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro']]
vim.opt.background = "dark"
vim.cmd[[
    if has('termguicolors')
      set termguicolors
    endif
    colorscheme oxocarbon
]]


-- Hand-made crap

require"sqid".setup({})
require("trystero")

