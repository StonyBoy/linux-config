-- Neovim statusline/bufferline configuration
-- Steen Hegelund
-- Time-Stamp: 2022-Feb-06 16:18
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local function bufinfo()
  local tbstat = vim.bo.expandtab and ' spc' or ' tab'
  return 'ts:' .. vim.bo.tabstop .. ' sw:' .. vim.bo.shiftwidth .. ' sts:' .. vim.bo.softtabstop .. ' tw:' .. vim.bo.textwidth .. tbstat
end

local function bufstate()
  return vim.bo.modified and '[+]' or ''
end

local function fileinfo()
  return vim.bo.fileformat .. ' ' .. vim.bo.fileencoding .. ' ' .. vim.bo.filetype
end

local function filepath()
    local colons = {}
    for w in string.gmatch(vim.fn.expand('%:f'), ':') do
       colons[#colons+1] = w
    end
    local ret = ''
    if #colons > 1 then
        ret = "git:" .. vim.fn.expand("%:t")
    else
        ret = vim.fn.expand("%:f")
    end
    return ret
end

local function editmode()
  local mode = vim.api.nvim_get_mode()['mode']
  local no_unicode_modes = {
    ['n']  = 'N ',
    ['i']  = 'I',
    ['ic'] = 'IC',
    ['c']  = 'C',
    ['v']  = 'V',
    ['V']  = 'VL',
    [''] = 'VB',
    ['x']  = 'X',
    ['s']  = 'S',
    ['S']  = 'SL',
  }
  return no_unicode_modes[mode]
end


-- Statusline and bufferline configuration
package.loaded['staline'] = nil
vim.opt.laststatus = 2
vim.opt.showmode = false -- 2nd line edit mode information
vim.opt.showtabline = 2
local solarized_mode_colors = {
  ['n']  = '#268bd2',
  ['i']  = '#859900',
  ['ic'] = '#dc322f',
  ['c']  = '#dc322f',
  ['v']  = '#d33682',
  ['V']  = '#d33682',
  [''] = '#d33682',
  ['x']  = '#d33682',
  ['s']  = '#986fec',
  ['S']  = '#986fec',
}
require('staline').setup{
  sections = {
    left = {
      'right_sep', editmode,
      'right_sep', 'branch',
      bufstate,
    },
    mid  = {filepath},
    right= {
      bufinfo, 'left_sep',
      fileinfo, 'left_sep',
      'line_column', 'left_sep',
    }
  },
  defaults={
    fg = '#839496',
    bg = '#eee8d5',
    inactive_fgcolor = '#002b36',
    inactive_bgcolor = '#839496',
    left_separator = ' ',
    right_separator = ' ',
    true_colors = true,
    line_column = '[%03l:%03c] %02p%%',
    -- font_active = 'bold'
  },
  mode_colors = solarized_mode_colors,
}

package.loaded['stabline'] = nil
require('stabline').setup {
  style       = "bubble", -- others: arrow, slant, bubble
  stab_left   = "",
  stab_right  = "",

  fg = '#839496',
  bg = '#eee8d5',
  inactive_fg = '#002b36',
  inactive_bg = '#839496',
  stab_bg     = '#839496',

  font_active = "bold",
  exclude_fts = { 'NvimTree', 'dashboard', 'lir' },
  stab_start  = "",   -- The starting of stabline
  stab_end    = "",
}


