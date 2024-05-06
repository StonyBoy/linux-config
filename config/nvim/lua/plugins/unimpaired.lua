-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2024-May-06 11:24
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

return {
  {
    'tummetott/unimpaired.nvim',
    event = "VeryLazy",
    config = function()
      require('unimpaired').setup {
        -- add any options here or leave empty
      }
    end
  }
}
