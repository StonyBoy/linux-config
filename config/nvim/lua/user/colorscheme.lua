-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2022-Oct-08 17:42
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

--Set colorscheme
vim.opt.termguicolors = true
vim.opt.background = 'light'
if vim.env['USER'] == 'root' or vim.env['TERM'] == 'linux' then
  vim.opt.background = 'dark'
end

-- Try 3 schemes in prioritized order
local ok, _ = pcall(vim.cmd, 'colorscheme solarized8_high')
if ok then
  if vim.go.background == 'dark' then
    vim.cmd('highlight NormalNC guifg=#eee8d5 guibg=#073642')
    require('lualine').setup({
      options = {
        theme = 'solarized_dark',
      }
    })
  else
    vim.cmd('highlight NormalNC guifg=#073642 guibg=#eee8d5')
    require('lualine').setup({
      options = {
        theme = 'solarized_light',
      }
    })
  end
  vim.opt.laststatus = 3 -- show global status line for all windows
else
  ok, _ = pcall(vim.cmd, 'colorscheme kanagawa')
  if ok then
    vim.opt.laststatus = 3 -- show global status line for all windows
  else
    pcall(vim.cmd, 'colorscheme quiet')
  end
end
