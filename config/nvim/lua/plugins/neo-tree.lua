-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2023-Jan-30 21:28
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    config = function()
      local cmd = '<cmd>Neotree toggle reveal<cr>'
      vim.api.nvim_set_keymap('n', '<F7>', cmd, { noremap = true, silent = true, })
    end,
  }
}
