-- statusline configuration
-- Steen Hegelund
-- Time-Stamp: 2022-May-30 23:06
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local status_ok, lualine = pcall(require, 'lualine')
if not status_ok then
  return
end

vim.opt.laststatus = 2
vim.opt.showmode = false -- Do not show 2nd line edit mode information

-- Show editor configuration: tabs/spaces, tabstop, softtabstop, shiftwidth and textwidth (wrapping)
local edit_config = function()
  local tabstr = vim.bo.expandtab and 'spc' or 'tab'
  local result = string.format('%s | ts:%d | sw:%d | sts:%d | tw:%d',
    tabstr, vim.bo.tabstop, vim.bo.shiftwidth, vim.bo.softtabstop, vim.bo.textwidth)
  return vim.api.nvim_win_get_width(0) > 140 and result or tabstr
end

lualine.setup({
  options = {
    theme = 'solarized_light',
    always_divide_middle = true,
    component_separators = { left = '|', right = '|' },
    section_separators = { left = '|', right = '|' },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', {'filename', path = 3} },
    lualine_c = {},
    lualine_x = {},
    lualine_y = { edit_config },
    lualine_z = { 'bo:fileformat', 'location', 'progress' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { {'filename', path = 3} },
    lualine_x = { 'progress' },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
})

