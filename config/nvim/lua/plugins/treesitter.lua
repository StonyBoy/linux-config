-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2024-Feb-11 16:38
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Highlight, edit, and navigate code using a fast incremental parsing library
return {
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require 'nvim-treesitter'.setup()
      require 'nvim-treesitter.configs'.setup {
        -- Modules and its options go here
        ensure_installed = {
          "awk",
          "bash",
          "c",
          "cmake",
          "css",
          "devicetree",
          "diff",
          "dockerfile",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "python",
          "query",
          "regex",
          "ruby",
          "rust",
          "toml",
          "vim",
          "vimdoc",
          "yaml",
          "yang"
        },
        highlight = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
        textobjects = {
          move = {
            enable = true,
            goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
            goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
            goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
          },
        },
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects', -- Additional textobjects for treesitter
  }
}
