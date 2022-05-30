-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2022-May-30 22:00
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

require('user.options')
require('user.plugins')
require('user.colorscheme')
require('user.keymaps')
require('user.commands')
require('user.functions')
require('user.lualine')
require('user.gitto')
require('user.easyalign')
require('user.bufexplorer')
require('user.updatetime')
require('user.lsp')
require('user.telescope')
print('loaded init.lua')
