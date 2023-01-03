-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2023-Jan-03 10:08
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

require('config.options')
require('config.lazy')
require('config.commands')
require('config.functions')
require('config.autocommands')
require('config.keymaps')
print('loaded init.lua')
