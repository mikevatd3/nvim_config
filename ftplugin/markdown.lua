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

keymap('x', '<leader>si', ':lua require"sqid".web()<CR>', opts)
keymap('x', '<leader>sf', ':lua require"sqid".web_to_file()<CR>', opts)
keymap('x', '<leader>sw', ':lua require"sqid".pop_window()<CR>', opts)
keymap('x', '<leader>saw', ':lua require"sqid".askwayne()<CR>', opts)
keymap('x', '<leader>slu', ':lua require"sqid".lookupinoed()<CR>', opts)
keymap('v', '<leader>S', ':MStickIt<CR>', opts)

vim.cmd[[set textwidth=80]]
vim.cmd[[:setlocal linebreak nolist]]
vim.cmd[[:let g:vim_markdown_frontmatter = 1]]
vim.cmd[[:setlocal spell spelllang=en]]
