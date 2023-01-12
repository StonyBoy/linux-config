-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2023-Jan-12 16:18
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Add name-timestamp header in the beginning of the file

return {
    { 'ten3roberts/qf.nvim',                         -- Quickfix and location list management for Neovim
      config = function()
        require('qf').setup({
          c = { wide = true, auto_follow = false, number = true, },
          l = { wide = true, auto_follow = false, number = true, },
        })
      end,
    },
}
