-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2023-Jun-24 13:28
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Highlight, edit, and navigate code using a fast incremental parsing library
return {
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require 'nvim-treesitter'.setup()
      require 'nvim-treesitter.configs'.setup {
        -- Modules and its options go here
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "yaml", "python", "javascript", "ruby", "devicetree",
          "bash", "rust", "awk", "cmake", "dockerfile", "cpp", "css", "regex", "yang" },
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
