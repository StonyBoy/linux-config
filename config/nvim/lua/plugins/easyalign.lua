-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2025-May-26 15:31
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

return {
  {
    'junegunn/vim-easy-align',                     -- Align text on specific characters in nice columns
    config = function()
      vim.api.nvim_set_keymap('n', 'ga', '<Plug>(EasyAlign)', {}) -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
      vim.api.nvim_set_keymap('v', 'ga', '<Plug>(EasyAlign)', {}) -- Start interactive EasyAlign in visual mode (e.g. vipga), Visual and Select mode
      vim.api.nvim_set_keymap('x', 'ga', '<Plug>(EasyAlign)', {}) -- Start interactive EasyAlign in visual mode (e.g. vipga), Visual mode

      -- User defined alignment
      vim.g.easy_align_delimiters = {
        ['>'] = {
          pattern = '>>\\|=>\\|>'
        },
        ['/'] = {
          pattern = '//\\+\\|/\\*\\|\\*/',
          delimiter_align = 'l',
        },
        [']'] = {
          pattern = '[[\\]]',
          left_margin = 0,
          right_margin = 0,
          stick_to_left = 0
        },
        [')'] = {
          pattern = '[()]',
          left_margin = 0,
          right_margin = 0,
          stick_to_left = 0
        },
        ['d'] = {
          pattern = ' \\(\\S\\+\\s*[;=]\\)\\@=',
          left_margin = 0,
          right_margin = 0,
          stick_to_left = 0
        }
      }
    end,
  }
}
