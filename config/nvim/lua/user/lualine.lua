-- statusline configuration
-- Steen Hegelund
-- Time-Stamp: 2022-Jun-01 22:46
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

-- Show linenumber and virtual column number (when eg tabs are expanded to spaces)
local function file_location()
  return '%03l:%02v'
end

-- Show a full path if there is room. For fugitive file only show 'git:filename'
local function abbrev_path()
    local ret = vim.fn.expand("%:t") -- Tail part of path (name)
    local fpath = vim.fn.expand('%:p:~') -- Full path optionally using ~ for home
    local parts = #vim.fn.split(fpath, ':') -- Parts separated by colon
    local margin = vim.api.nvim_win_get_width(0) - string.len(fpath) - 100

    if parts > 1 then
        ret = "git:" .. ret
    elseif margin > 10 then
        ret = fpath
    end
    return ret
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
    lualine_b = { 'branch', { abbrev_path } },
    lualine_c = {},
    lualine_x = {},
    lualine_y = { edit_config },
    lualine_z = { 'encoding', 'bo:fileformat', 'filetype', file_location, 'progress' },
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

