-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2023-Jul-10 13:03
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Portable package manager for Neovim that runs everywhere Neovim runs.
-- Easily install and manage LSP servers, DAP servers, linters, and formatters.

return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate", -- :MasonUpdate updates registry contents
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd", "pylsp", "lua_ls", "rust_analyzer", "pylsp", "yamlls", "bashls", "solargraph", "vimls", "tsserver",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require('lspconfig')

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local opts = { noremap = true, buffer = args.buf, silent = true }
          vim.keymap.set({'n', 'v'}, '<a-CR>', vim.lsp.buf.code_action, opts)
          vim.keymap.set({'n', 'v'}, 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
          vim.keymap.set({'n', 'v'}, 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
          vim.keymap.set({'n', 'v'}, 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
          vim.keymap.set({'n', 'v'}, 'gT', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
          vim.keymap.set({'n', 'v'}, 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
          vim.keymap.set({'n', 'v'}, 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
          vim.keymap.set({'n', 'v'}, '<space>K', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
          vim.keymap.set({'n', 'v'}, '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
          vim.keymap.set({'n', 'v'}, '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
          vim.keymap.set({'n', 'v'}, '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
          vim.keymap.set({'n', 'v'}, '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
          vim.keymap.set({'n', 'v'}, '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
          vim.keymap.set({'n', 'v'}, '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
          vim.keymap.set({'n', 'v'}, '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
          vim.keymap.set({'n', 'v'}, '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
          vim.keymap.set({'n', 'v'}, ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
          vim.keymap.set({'n', 'v'}, '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
          vim.keymap.set({'n', 'v'}, '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
        end
      })
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
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = {'vim', 'it', 'describe'}
            },
            runtime = {
              version = "LuaJIT",
              path = vim.split(package.path, ';')
            },
            telemetry = {
              enable = false,
            },
          }
        }
      })
      lspconfig.bashls.setup({})
      lspconfig.solargraph.setup({})
      lspconfig.tsserver.setup({})
      lspconfig.rust_analyzer.setup({})
      lspconfig.vimls.setup({})
    end,
  },
}
