-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2024-Dec-04 14:53
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Portable package manager for Neovim that runs everywhere Neovim runs.
-- Easily install and manage LSP servers, DAP servers, linters, and formatters.

local enabled = true
local function toggle_diagnostics()
  -- if this Neovim version supports checking if diagnostics are enabled
  -- then use that for the current state
  if not vim.diagnostic.is_enable() then
    enabled = vim.diagnostic.is_enabled()
  end
  enabled = not enabled

  if enabled then
    vim.diagnostic.enable()
  else
    vim.diagnostic.enable(false)
  end
end

return {
  {
    -- Neovim setup for init.lua and plugin development with full signature help, docs and completion 
    -- for the nvim lua API.
    'folke/neodev.nvim',
    config = function()
      require("neodev").setup({
        -- add any options here, or leave empty to use the default settings
      })
    end,
  },
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
          "lua_ls", "rust_analyzer", "pylsp", "yamlls", "bashls", "solargraph", "vimls", "ts_ls", "clangd",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      'folke/neodev.nvim',
    },
    config = function()
      local lspconfig = require('lspconfig')
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          vim.keymap.set({'n', 'v'}, 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP references'})
          vim.keymap.set({'n', 'v'}, 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP declaration'})
          vim.keymap.set({'n', 'v'}, 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP definition'})
          vim.keymap.set({'n', 'v'}, 'gT', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP type definition'})
          vim.keymap.set({'n', 'v'}, 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP implementation'})
          vim.keymap.set({'n', 'v'}, 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP information'})
          vim.keymap.set({'n', 'v'}, '<leader>K', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP signature help'})
          vim.keymap.set({'n', 'v'}, '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP add workspace folder'})
          vim.keymap.set({'n', 'v'}, '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP remove workspace folder'})
          vim.keymap.set({'n', 'v'}, '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP list workspace folders'})
          vim.keymap.set({'n', 'v'}, '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP type definition'})
          vim.keymap.set({'n', 'v'}, '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP rename symbol'})
          vim.keymap.set({'n', 'v'}, '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP code action'})
          -- vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, { noremap = true, buffer = args.buf, silent = true, desc = 'LSP code action' })
          vim.keymap.set({'n', 'v'}, '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP show line diagnostics'})
          vim.keymap.set({'n', 'v'}, '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP goto prev diagnostics'})
          vim.keymap.set({'n', 'v'}, ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP goto next diagnostics'})
          vim.keymap.set({'n', 'v'}, '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP set loclist with diagnostics'})
          vim.keymap.set({'n', 'v'}, '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', { noremap = true, buffer = args.buf, silent = true, desc = 'LSP formatting'})
          vim.keymap.set({'n', 'v'}, "<leader>ud", function() toggle_diagnostics() end, { desc = "Toggle diagnostics" })
        end
      })
      lspconfig.pylsp.setup({
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = {
                ignore = {'W391','E501', 'E231'},
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
      lspconfig.clangd.setup({
          on_attach = function(client, bufnr)
              -- require("workspace-diagnostics").populate_workspace_diagnostics(vim.lsp.buf_get_clients()[1], 1)
              -- require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
              -- client.server_capabilities.semanticTokensProvider = nil
          end,

          keys = {
              { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
          },
          root_dir = function(fname)
              require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(fname)
          end,
          capabilities = {
              offsetEncoding = { "utf-16" },
          },
          cmd = {
              "clangd",
              "--background-index",
              "--clang-tidy",
              "--completion-style=detailed",
              "--function-arg-placeholders",
              "--fallback-style=llvm",
          },
          init_options = {
              usePlaceholders = true,
              completeUnimported = true,
              clangdFileStatus = true,
          },
      })
      lspconfig.bashls.setup({})
      lspconfig.solargraph.setup({})
      lspconfig.ts_ls.setup({})
      lspconfig.rust_analyzer.setup({})
      lspconfig.vimls.setup({})
    end,
  },
  {
      "p00f/clangd_extensions.nvim",
      --lazy = true,
      config = function() end,
      opts = {
          inlay_hints = {
              inline = false,
          },
          ast = {
              --These require codicons (https://github.com/microsoft/vscode-codicons)
              role_icons = {
                  type = "",
                  declaration = "",
                  expression = "",
                  specifier = "",
                  statement = "",
                  ["template argument"] = "",
              },
              kind_icons = {
                  Compound = "",
                  Recovery = "",
                  TranslationUnit = "",
                  PackExpansion = "",
                  TemplateTypeParm = "",
                  TemplateTemplateParm = "",
                  TemplateParamObject = "",
              },
          },
      },
  },
}
