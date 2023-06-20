-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2023-Jun-20 21:55
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Highlight, edit, and navigate code using a fast incremental parsing library
return {
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require 'nvim-treesitter'.setup()
      require 'nvim-treesitter.configs'.setup {
        -- Modules and its options go here
        highlight = { enable = true },
        incremental_selection = { enable = true },
        textobjects = { enable = true },
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects', -- Additional textobjects for treesitter
  }
}
