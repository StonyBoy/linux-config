-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2025-Jan-21 09:50
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

return {
  {
    'junegunn/vim-easy-align',                     -- Align text on specific characters in nice columns
    config = function()
      vim.api.nvim_set_keymap('n', 'ga', '<Plug>(EasyAlign)', {}) -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
      vim.api.nvim_set_keymap('v', 'ga', '<Plug>(EasyAlign)', {}) -- Start interactive EasyAlign in visual mode (e.g. vipga), Visual and Select mode
      vim.api.nvim_set_keymap('x', 'ga', '<Plug>(EasyAlign)', {}) -- Start interactive EasyAlign in visual mode (e.g. vipga), Visual mode
    end,
  }
}
