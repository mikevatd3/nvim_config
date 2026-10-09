-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = function()
      vim.g.no_plugin_maps = true
    end,
  },
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },

  -- Mason for managing external tools like LSP servers
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },

  -- Language server configurations
  { "neovim/nvim-lspconfig" },

  -- Logging for some plugins
  {"NTBBloodbath/logging.nvim"},

  -- Completion plugins
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-nvim-lua" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },

  -- Snippets
  { "L3MON4D3/LuaSnip" },

  -- Dadbod for database work
  { "tpope/vim-dadbod" },
  { "kristijanhusak/vim-dadbod-completion" },
  { "kristijanhusak/vim-dadbod-ui" },

  -- Telescope for file searching
  { "nvim-lua/plenary.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }
  },

  -- Vim Fugitive for Git
  { "tpope/vim-fugitive" },

  -- For formatting
  {
    'stevearc/conform.nvim',
    config = function()
      require("plugins.conform")
    end,
  },

  -- biblatex plugings for notes and citations
  {
      "nvim-telescope/telescope-bibtex.nvim",
      dependencies = {'nvim-telescope/telescope.nvim'},
  },

  -- Go To Preview for previewing function definitions
  {
      "rmagatti/goto-preview",
      dependencies = { "rmagatti/logger.nvim" },
      opts = {}
  },

  -- Otter for LSP in embedded code blocks (e.g. python chunks in quarto/markdown)
  {
      "jmbuhr/otter.nvim",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      config = function()
        require("plugins.otter")
      end,
  },

  -- LaTeX: compilation, SyncTeX, TOC, motions/text-objects
  { "lervag/vimtex", ft = { "tex" } },

  -- Appearance-related plugins
  { "tjdevries/colorbuddy.nvim" },
  { "sainnhe/everforest"},
  { "kyazdani42/nvim-web-devicons" },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
  },

  { "AndrewRadev/linediff.vim" },
    
  -- Send lines to a repl
  { 
    "jpalardy/vim-slime",
    init = function()
      vim.g.slime_target = "kitty"
    end
  },

-- Pi: minimal CLI agent integration
{
  "pablopunk/pi.nvim",
  config = function()
    require("plugins.pi")
  end,
  cmd = { "PiAsk", "PiAskSelection" },
  keys = {
    { "<leader>ai", "<cmd>PiAsk<cr>", desc = "Ask pi" },
    { "<leader>ai", "<cmd>PiAskSelection<cr>", mode = "v", desc = "Ask pi (selection)" },
  },
},

},
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

