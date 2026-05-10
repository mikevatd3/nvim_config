require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_fix", "ruff_format" },
    rust = { "rustfmt", lsp_format = "fallback" },
    javascript = { "prettier" },
    sql = { "pg_format" },
  },
})
