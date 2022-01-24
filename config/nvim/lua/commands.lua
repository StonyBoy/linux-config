-- Neovim create global commands
-- Steen Hegelund
-- Time-Stamp: 2022-Jan-24 22:39
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Create Global Ex functions from Lua functions
vim.cmd([[
command! TrailspaceTrim lua require('functions').trailspace_trim()
command! -nargs=+ -complete=file RG lua require('functions').args_ripgrep(<f-args>)
]])
