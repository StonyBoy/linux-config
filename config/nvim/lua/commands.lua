-- Neovim create global commands
-- Steen Hegelund
-- Time-Stamp: 2022-Apr-05 20:56
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Create Global Ex functions from Lua functions
vim.cmd([[
command! TrailspaceTrim lua require('functions').trailspace_trim()
command! -nargs=* Rg lua require('functions').ripgrep_args(<f-args>)
command! -nargs=* Rgf lua require('functions').ripgrep_args(vim.fn.expand('%:p:h'), <f-args>)
]])
