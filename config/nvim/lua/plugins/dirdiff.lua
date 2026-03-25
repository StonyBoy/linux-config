-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2026-Mar-25 14:58
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- If you like Vim's diff mode, you would love to do this recursively on two directories!
return {
  {
    'StonyBoy/vim-dirdiff',
    config = function()
      vim.g.DirDiffExcludes = ".git"
    end,
  }
}

