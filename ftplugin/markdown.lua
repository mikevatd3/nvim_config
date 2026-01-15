local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

-- This needs more configuration before it'll be usable
-- vim.lsp.config["harper_ls"] = {
--     settings = {
--         ["harper-ls"] = {
--             userDictPath = "~/.config/nvim/spell/en.utf-8.add",
--             linters = {
--                   SpellCheck = true,
--                   SpelledNumbers = false,
--                   AnA = true,
--                   SentenceCapitalization = true,
--                   UnclosedQuotes = true,
--                   WrongQuotes = false,
--                   LongSentences = true,
--                   RepeatedWords = true,
--                   Spaces = true,
--                   Matcher = true,
--                   CorrectNumberSuffix = true
--             },
--             codeActions = {
--                 ForceStable = false
--             },
--             markdown = {
--                 IgnoreLinkTitle = true
--             },
--             diagnosticSeverity = "hint",
--             isolateEnglish = false,
--             dialect = "American",
--             maxFileLength = 120000,
--             ignoredLintsPath = "",
--             excludePatterns = {"#+ [A-Za-z ]+"}
--         }
--     }
-- }
-- vim.lsp.enable("harper_ls")

-- This will add .md to the file search
vim.opt_local.suffixesadd:append(".md")

-- This will try to find the file first, then create a new markdown file if it doesn't yet exist.
vim.keymap.set('n', 'gf', function()
  local ok = pcall(vim.cmd, 'normal! gf')
  if not ok then
    local file = vim.fn.expand('<cfile>')
    if not file:match('%.md$') then
      file = file .. '.md'
    end
    vim.cmd('e ' .. file)
  end
end)

vim.cmd[[set textwidth=80]]
vim.cmd[[:setlocal linebreak nolist]]
vim.cmd[[:let g:vim_markdown_frontmatter = 1]]
vim.cmd[[:setlocal spell spelllang=en]]
