-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2023-Jan-03 09:58
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

return {
  {
    'StonyBoy/telescope.nvim',                   -- a highly extendable fuzzy finder over lists
    dependencies = {
      'nvim-lua/plenary.nvim',                      -- Lua library
      'nvim-telescope/telescope-live-grep-raw.nvim' -- Live grep raw picker for telescope.nvim.
    },
    config = function()
      local ts = require('telescope.builtin')

      vim.api.nvim_set_keymap('n', '<Leader>ff', '', { noremap = true, silent = true, callback = ts.find_files })
      vim.api.nvim_set_keymap('n', '<Leader>fg', '', { noremap = true, silent = true, callback = ts.live_grep })
      vim.api.nvim_set_keymap('n', '<Leader>fh', '', { noremap = true, silent = true, callback = ts.help_tags })
      vim.api.nvim_set_keymap('n', '##', '', { noremap = true, silent = true, callback = ts.grep_string })
      vim.api.nvim_set_keymap('v', '##', '', { noremap = true, silent = true, callback = function()
        ts.grep_string({search = require('config.functions').get_visual_selection() }) end })
      vim.api.nvim_set_keymap('n', '<Leader>fb', '', { noremap = true, silent = true, callback = function()
        ts.current_buffer_fuzzy_find({ case_mode = 'ignore_case', sort = require('telescope.sorters').highlighter_only }) end })
    end,
  }
}
