-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2023-May-10 10:06
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :


return {
  {
    'RaafatTurki/hex.nvim',                        -- Hex editing done right.  Uses xxd utility, so it must be in $PATH
    config = function()
      require('hex').setup()
    end,
  },
}
