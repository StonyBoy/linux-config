-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2022-Sep-27 08:39
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

return {
  {
    'jlanzarotta/bufexplorer',                     -- Manage Buffers
    config = function()
      vim.api.nvim_set_keymap('n', '<F8>', '<cmd>ToggleBufExplorer<cr>', { noremap = true, silent = true, })
      vim.cmd[[let g:bufExplorerSortBy='fullpath']]
    end,
  }
}
