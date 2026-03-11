-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2026-Mar-11
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Clangd extensions: AST view, inlay hints, memory usage, symbol info, type hierarchy
return {
  {
    'p00f/clangd_extensions.nvim',
    ft = { 'c', 'cpp', 'objc', 'objcpp' },
    keys = {
      { '<leader>ca', '<cmd>ClangdAST<cr>', ft = { 'c', 'cpp', 'objc', 'objcpp' }, desc = 'Clangd AST' },
      { '<leader>cm', '<cmd>ClangdMemoryUsage<cr>', ft = { 'c', 'cpp', 'objc', 'objcpp' }, desc = 'Clangd memory usage' },
      { '<leader>cs', '<cmd>ClangdSymbolInfo<cr>', ft = { 'c', 'cpp', 'objc', 'objcpp' }, desc = 'Clangd symbol info' },
      { '<leader>ct', '<cmd>ClangdTypeHierarchy<cr>', ft = { 'c', 'cpp', 'objc', 'objcpp' }, desc = 'Clangd type hierarchy' },
      { '<leader>ch', '<cmd>ClangdSwitchSourceHeader<cr>', ft = { 'c', 'cpp', 'objc', 'objcpp' }, desc = 'Clangd switch source/header' },
    },
    opts = {},
  },
}
