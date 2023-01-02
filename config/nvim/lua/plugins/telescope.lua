-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2022-Jun-02 21:49
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

return {
  {
    'StonyBoy/telescope.nvim',                   -- a highly extendable fuzzy finder over lists
    dependencies = {
      'nvim-lua/plenary.nvim',                      -- Lua library
      'nvim-telescope/telescope-live-grep-raw.nvim' -- Live grep raw picker for telescope.nvim.
    },
  }
}

