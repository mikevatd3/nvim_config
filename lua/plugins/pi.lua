-- Resolve via a login shell (sources ~/.bash_profile, which loads nvm) so this
-- doesn't break when the node version behind `pi` changes, and works even if
-- the Hyprland/systemd session environment doesn't have nvm's PATH entry yet.
local function resolve_pi_binary()
  local result = vim.fn.system({ "bash", "-lc", "command -v pi" })
  local path = vim.trim(result)
  if vim.v.shell_error == 0 and path ~= "" then
    return path
  end
  return "pi"
end

require("pi").setup({
  binary = resolve_pi_binary(),
})
