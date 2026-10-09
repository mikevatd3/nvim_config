local bibtex_utils = require('telescope-bibtex.utils')
local bibtex_actions = require('telescope-bibtex.actions')
local tele_actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

-- Last names only, no initials: "Smith" / "Smith and Jones" / "Smith et al."
local function format_authors(author_field)
  local names = {}
  for _, auth in ipairs(vim.split(author_field, ' and ', { plain = true })) do
    local lastname = auth:match('^%s*(.-)%s*,')
    if not lastname or lastname == '' then
      lastname = auth:match('(%S+)%s*$') or auth
    end
    table.insert(names, vim.trim(lastname))
  end
  if #names == 0 then
    return ''
  elseif #names == 1 then
    return names[1]
  elseif #names == 2 then
    return names[1] .. ' and ' .. names[2]
  else
    return names[1] .. ' et al.'
  end
end

-- The plugin's own {{date}}/{{title}} template engine is unreliable (date
-- silently drops out when title is also in the template), and its bib
-- entries store a full ISO date rather than just a year anyway. Build the
-- "Author (Year)[, Title.]" citation ourselves instead of going through
-- citation_format.
local function readable_citation(entry_content, with_title)
  local parsed = bibtex_utils.parse_entry(entry_content)
  local author = parsed.author and format_authors(parsed.author) or ''
  local year = parsed.date and parsed.date:match('%d%d%d%d') or ''
  local citation = author .. ' (' .. year .. ')'
  if with_title and parsed.title then
    citation = citation .. ', ' .. parsed.title .. '.'
  end
  return citation
end

local function insert_readable_citation(with_title)
  return function(prompt_bufnr)
    local entry = action_state.get_selected_entry().id.content
    tele_actions.close(prompt_bufnr)
    local citation = readable_citation(entry, with_title)
    local mode = vim.api.nvim_get_mode().mode
    if mode == 'i' then
      vim.api.nvim_put({ citation }, '', false, true)
      vim.api.nvim_feedkeys('a', 'n', true)
    else
      vim.api.nvim_paste(citation, true, -1)
    end
  end
end

require"telescope".setup {
  extensions = {
    bibtex = {
      global_files = { "~/4_library/references.bib" },
      search_keys = { "author", "date", "title" },
      mappings = {
        -- The plugin merges this table shallowly (per-mode, not per-key), so
        -- overriding <C-c> alone would silently drop <C-e>/<C-f> too --
        -- restate the plugin's defaults for those alongside our override.
        i = {
          ["<C-e>"] = bibtex_actions.entry_append,
          ["<C-f>"] = bibtex_actions.field_append(),
          ["<C-c>"] = insert_readable_citation(true),
        },
      },
    },
  },
}

return { insert_readable_citation = insert_readable_citation }
