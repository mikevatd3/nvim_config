require("otter").setup()

-- Quarto files use the markdown treesitter grammar
vim.treesitter.language.register("markdown", "quarto")

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "quarto" },
  callback = function()
    require("otter").activate()
  end,
})
