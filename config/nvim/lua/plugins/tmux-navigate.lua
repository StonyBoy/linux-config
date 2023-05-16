-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2023-May-16 16:50
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Intelligently navigate tmux panes and Vim splits using the same keys. This also supports SSH tunnels where Vim is
-- running on a remote host.
return {
  {
    'sunaku/tmux-navigate',
    config = function()
      -- Simpler window navigation in neovim, aligns with the tmux config
      vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true, })
      vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true, })
      vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true, })
      vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true, })
    end,
  }
}
