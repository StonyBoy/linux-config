-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2026-Mar-06 14:48
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Highlight, edit, and navigate code using a fast incremental parsing library
return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")
      treesitter.setup()
      treesitter.install {
          "awk",
          "bash",
          "c",
          "cmake",
          "css",
          "devicetree",
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
      }
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
            "awk",
            "bash",
            "c",
            "cmake",
            "css",
            "devicetree",
            "dockerfile",
            "html",
            "javascript",
            "json",
            "lua",
            "markdown",
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
        callback = function()
          -- syntax highlighting, provided by Neovim
          vim.treesitter.start()
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          -- vim.wo.foldmethod = 'expr'
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects', -- Additional textobjects for treesitter
    -- commit = "73e44f43c70289c70195b5e7bc6a077ceffddda4", -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/513
  }
}
