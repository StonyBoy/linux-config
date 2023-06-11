-- Neovim configuration for stylua
-- Steen Hegelund
-- Time-Stamp: 2023-Jun-11 21:14
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- A simple plugin that format your Lua code using StyLua

return {
  {
    'wesleimp/stylua.nvim',
    config = function()
      local stylua = require('stylua')
      local opts = {
        config_path = vim.fn.expand('~/.config/nvim/stylua.toml'),
      }
      vim.keymap.set('n', '<leader>sf', function()
        stylua.format(opts)
      end)
    end,
  },
}
