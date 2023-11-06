-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2023-Nov-06 20:21
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local function set_background()
  vim.opt.termguicolors = true
  vim.opt.background = 'light'
  if vim.env['USER'] == 'root' or vim.env['TERM'] == 'linux' then
    vim.opt.background = 'dark'
  end
end

return {
  {
    'lifepillar/vim-solarized8',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    enabled = true,
    config = function()
      set_background()
      vim.cmd([[colorscheme solarized8_high]])
      -- Dim the inactive windows
      if vim.go.background == 'dark' then
        vim.cmd('highlight NormalNC guifg=#eee8d5 guibg=#073642')
      else
        vim.cmd('highlight NormalNC guifg=#073642 guibg=#eee8d5')
      end
    end,
  },
}
