-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2024-Feb-11 17:37
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- git signs highlights text that has changed since the list git commit, and also lets you interactively 
-- stage & unstage hunks in a commit.

return {
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {},
    config = function()
      require('gitsigns').setup()
    end,
  }
}
