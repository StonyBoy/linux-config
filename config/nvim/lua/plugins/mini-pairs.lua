-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2024-Feb-11 17:16
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

return {
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {},
    config = function()
      require('mini.pairs').setup()
    end,
  }
}
