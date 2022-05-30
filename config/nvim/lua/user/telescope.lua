-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2022-May-30 20:59
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local status_ok, ts = pcall(require, 'telescope.builtin')
if not status_ok then
  return
end

vim.api.nvim_set_keymap('n', '<Leader>ff', '', { noremap = true, silent = true,
  callback = ts.find_files,
})
vim.api.nvim_set_keymap('n', '<Leader>fg', '', { noremap = true, silent = true,
  callback = ts.live_grep,
})
vim.api.nvim_set_keymap('n', '<Leader>fh', '', { noremap = true, silent = true,
  callback = ts.help_tags,
})
vim.api.nvim_set_keymap('n', '##', '', { noremap = true, silent = true,
  callback = ts.grep_string,
})
vim.api.nvim_set_keymap('v', '##', '', { noremap = true, silent = true,
  callback = function()
    ts.grep_string({search = require('user.functions').get_visual_selection()})
  end,
})
vim.api.nvim_set_keymap('n', '<Leader>fb', '', { noremap = true, silent = true,
  callback = function()
    ts.current_buffer_fuzzy_find({ case_mode = 'ignore_case', sort = require('telescope.sorters').highlighter_only })
  end,
})

