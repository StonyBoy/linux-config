-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2022-May-30 20:43
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local status_ok, gs = pcall(require, 'git_session')
if not status_ok then
  return
end

vim.api.nvim_set_keymap('n', '<Leader><Leader>q', '', { noremap = true, silent = true,
  callback = gs.shutdown,
})
