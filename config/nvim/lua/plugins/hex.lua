-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2025-Jan-21 17:02
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :


return {
  {
    'StonyBoy/hex.nvim',                        -- Hex editing done right.  Uses xxd utility, so it must be in $PATH
    config = function()
      require('hex').setup()
    end,
  },
}
