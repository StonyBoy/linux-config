-- Neovim Language Server Configuration
-- Steen Hegelund
-- Time-Stamp: 2025-Mar-31 22:18
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Enable Language Servers - prefer the language name if possible
vim.lsp.enable({ 'lua_ls', 'rust_ls', 'python_ls', 'yaml_ls', 'bash_ls', 'ruby_ls', 'vim_ls', 'typescript_ls', 'clangd' })

-- Show diagnostics
vim.diagnostic.config({
  virtual_text = { current_line = true }
})

return {
  {
    'williamboman/mason.nvim',
    build = ':MasonUpdate', -- :MasonUpdate updates registry contents
    config = function()
      require('mason').setup({
        ui = {
          border = 'rounded',
        },
      })
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls', 'rust_analyzer', 'pylsp', 'yamlls', 'bashls', 'solargraph', 'vimls', 'ts_ls', 'clangd',
        },
      })
    end,
  },
}
