-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2022-Oct-08 17:58
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

return {
  {
    'lifepillar/vim-solarized8',
    lazy = false,
    config = function()
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
        else
          vim.cmd('highlight NormalNC guifg=#073642 guibg=#eee8d5')
        end
      else
        ok, _ = pcall(vim.cmd, 'colorscheme kanagawa')
        if not ok then
          pcall(vim.cmd, 'colorscheme quiet')
        end
      end
    end,
  },
}
