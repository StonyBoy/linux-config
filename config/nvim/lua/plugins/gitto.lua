-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2022-May-30 20:43
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

return {
  {
    'StonyBoy/nvim-gitto',                         -- Git log plugin
    config = function()
      vim.api.nvim_set_keymap('n', '<Leader><Leader>q', '',
      {
        noremap = true, silent = true,
        callback = require('git_session').shutdown 
      })
    end,
  },
}
