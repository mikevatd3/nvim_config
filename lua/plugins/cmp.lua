-- Completion set up
local cmp = require "cmp"

-- Show files in notes dir on open bracket in markdown
local filesource = {}

function filesource:is_available()
    return vim.bo.filetype == 'markdown'
end

function filesource:get_trigger_characters() return { '(' } end

function filesource:complete(params, callback)
    local line = params.context.cursor_before_line
    if not line:match('%($') then
        return callback({})
    end

    local items = {}
    for name in vim.fs.dir('.') do
        table.insert(items, { label = name .. ')', insertText = name .. ')' })
    end
    callback(items)
end

cmp.register_source('bracket_files', filesource)


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
    { name = "bracket_files" },
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



