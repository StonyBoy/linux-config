-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2023-Jul-05 23:00
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Portable package manager for Neovim that runs everywhere Neovim runs.
-- Easily install and manage LSP servers, DAP servers, linters, and formatters.

return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate", -- :MasonUpdate updates registry contents
    config = function()
      require("mason").setup({
        ensure_installed = {
          "clangd", "pylsp", "lua_ls", "rust_analyzer", "pylsp", "yamlls", "bashls", "solargraph", "vimls", "tsserver",
        },
        ui = {
          border = "rounded",
        },
      })
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require('lspconfig')

      lspconfig.pylsp.setup({
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = {
                ignore = {'W391'},
                maxLineLength = 120
              }
            }
          }
        }
      })

      lspconfig.yamlls.setup({
        settings = {
          yaml = {
            keyOrdering = false
          }
        }
      })

      lspconfig.clangd.setup({})
      lspconfig.lua_ls.setup({})
      lspconfig.bashls.setup({})
      lspconfig.solargraph.setup({})
      lspconfig.tsserver.setup({})
      lspconfig.rust_analyzer.setup({})
      lspconfig.vimls.setup({})
    end,
  },
}
