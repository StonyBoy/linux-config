-- Neovim Language Server Configuration
-- Steen Hegelund
-- Time-Stamp: 2025-Sep-18 14:28
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Enable Language Servers - prefer the language name if possible
vim.lsp.enable({ 'lua_ls', 'rust_ls', 'python_ls', 'yaml_ls', 'bash_ls', 'ruby_ls', 'vim_ls', 'typescript_ls', 'clangd' })

-- Show diagnostics
vim.diagnostic.config({
  virtual_text = { current_line = true }
})

-- Enable autocompletion and add more keybindings
vim.api.nvim_create_autocmd('LspAttach', {
  -- These GLOBAL keymaps are created unconditionally when Nvim starts:
  -- "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
  -- "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
  -- "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
  -- "gri" is mapped in Normal mode to |vim.lsp.buf.implementation()|
  -- "grt" is mapped in Normal mode to |vim.lsp.buf.type_definition()|
  -- "gO" is mapped in Normal mode to |vim.lsp.buf.document_symbol()|
  -- CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
    vim.keymap.set({ 'n', 'v' }, 'gd', vim.lsp.buf.definition,
      { noremap = true, buffer = ev.buf, silent = true, desc = 'LSP definition' })
    vim.keymap.set({ 'n', 'v' }, 'gT', vim.lsp.buf.type_definition,
      { noremap = true, buffer = ev.buf, silent = true, desc = 'LSP type definition' })
    vim.keymap.set({ 'n', 'v' }, 'gff', function() vim.lsp.buf.format({ async = true }) end,
      { noremap = true, buffer = ev.buf, silent = true, desc = 'LSP format buffer or selection' })
  end,
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
