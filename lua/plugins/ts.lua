require("nvim-treesitter").install {
  "lua", "python", "r", "julia", "rust", "sql", "html", "javascript",
  "markdown", "markdown_inline", "latex",
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function() pcall(vim.treesitter.start) end,
})

require("nvim-treesitter-textobjects").setup {
  select = {
    lookahead = true,
    include_surrounding_whitespace = false,
    selection_modes = {
      ["@function.outer"] = "V",
      ["@class.outer"] = "<c-v>",
    },
  },
}

local select = require "nvim-treesitter-textobjects.select"
local textobjects = {
  af = "@function.outer",
  ["if"] = "@function.inner",
  ac = "@class.outer",
  ic = "@class.inner",
}

for lhs, query in pairs(textobjects) do
  for _, mode in ipairs { "x", "o" } do
    vim.keymap.set(mode, lhs, function()
      select.select_textobject(query, "textobjects", mode)
    end)
  end
end

for _, mode in ipairs { "x", "o" } do
  vim.keymap.set(mode, "as", function()
    select.select_textobject("@local.scope", "locals", mode)
  end)
end
