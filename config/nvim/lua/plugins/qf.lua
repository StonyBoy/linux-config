-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2023-Jan-31 16:20
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Quickfix and location list management for Neovim

return {
    { 'ten3roberts/qf.nvim',
      config = function()
        require('qf').setup({
          c = { wide = true, auto_follow = false, number = true, },
          l = { wide = true, auto_follow = false, number = true, },
        })
        -- Toggle quickfix list (c) and stay in current window
        vim.api.nvim_set_keymap('n', '<F11>', '', { noremap = true, silent = true,
          callback = function()
            require('qf').toggle('c', false)
          end,
        })
      end,
    },
}
