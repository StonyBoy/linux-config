-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2022-May-30 20:04
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

--Set colorscheme
vim.opt.termguicolors = true
vim.opt.background = 'light'
if vim.env['USER'] == 'root' or vim.env['TERM'] == 'linux' then
  vim.opt.background = 'dark'
end

vim.cmd [[
try
  colorscheme solarized8_high
catch /^Vim\%((\a\+)\)\=:E185/
endtry
]]


