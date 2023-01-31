-- Neovim keymap configuration
-- Steen Hegelund
-- Time-Stamp: 2023-Jan-31 16:19
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local Module = {}

local funcs = require('config.functions')

-- Using tabs
vim.api.nvim_set_keymap('n', '<Leader>t<Up>', '<cmd>tabr<cr>', { noremap = true, silent = true, })
vim.api.nvim_set_keymap('n', '<Leader>t<Down>', '<cmd>tabl<cr>', { noremap = true, silent = true, })
vim.api.nvim_set_keymap('n', '<Leader>t<Left>', '<cmd>tabp<cr>', { noremap = true, silent = true, })
vim.api.nvim_set_keymap('n', '<Leader>t<Right>', '<cmd>tabn<cr>', { noremap = true, silent = true, })

-- Remapping XTERM specialities
vim.api.nvim_set_keymap('n', '<ESC>[1;5D', '<C-Left>', { noremap = true, silent = true, })
vim.api.nvim_set_keymap('n', '<ESC>[1;5C', '<C-Right>', { noremap = true, silent = true, })
vim.api.nvim_set_keymap('c', '<ESC>[1;5D', '<C-Left>', { noremap = true, silent = true, })
vim.api.nvim_set_keymap('c', '<ESC>[1;5C', '<C-Right>', { noremap = true, silent = true, })

-- Window resize
vim.api.nvim_set_keymap('n', '<C-M-S-Left>', '<cmd>vertical resize -1<cr>', { noremap = true, silent = true, })
vim.api.nvim_set_keymap('n', '<C-M-S-Right>', '<cmd>vertical resize +1<cr>', { noremap = true, silent = true, })
vim.api.nvim_set_keymap('n', '<C-M-S-Down>', '<cmd>resize -1<cr>', { noremap = true, silent = true, })
vim.api.nvim_set_keymap('n', '<C-M-S-Up>', '<cmd>resize +1<cr>', { noremap = true, silent = true, })

-- Developer specialities
vim.api.nvim_set_keymap('n', '<Leader>is', '<cmd>r ~/work/patches/signedoffby.txt<cr>', { noremap = true, silent = true, })
vim.api.nvim_set_keymap('n', '<leader>it', 'Opr_info("%s:%d\\n", __func__, __LINE__);<esc>', { noremap = true, silent = true, })
vim.api.nvim_set_keymap('n', '<leader>id', 'OCFLAGS_*.o := -DDEBUG<CR><esc>', { noremap = true, silent = true, })
vim.api.nvim_set_keymap('n', '<leader>fm', '<cmd>setlocal foldmethod=syntax<CR>',  { noremap = true, silent = true, })
vim.api.nvim_set_keymap('c', 'w!!', 'execute "silent! write !sudo tee % >/dev/null" <bar> edit!', { noremap = true, silent = true, })

-- Assorted usage
vim.api.nvim_set_keymap('n', '<Leader><Leader>x', '<cmd>source %<cr>', { noremap = true, silent = true, })
vim.api.nvim_set_keymap('n', '<Leader>sv', '', { noremap = true, silent = true,
  callback = require('config.functions').reload_neovim,
})
vim.api.nvim_set_keymap('n', '<Leader>ev', 'vsplit $MYVIMRC', { noremap = true, silent = true, })
vim.api.nvim_set_keymap('n', '<Leader>ml', '', { noremap = true, silent = true,
  callback = function()
    vim.call('nvim_buf_set_lines', 0, -1, -1, 0, funcs.get_modeline_struct())
  end,
})

-- Toggle C style formatting and indenting between Linux Kernel and Userspace style
vim.api.nvim_set_keymap('n', '<leader><leader>c', '', { noremap = true, silent = true,
  callback = funcs.toggle_c_style
})

vim.api.nvim_set_keymap('n', '<F6>', 'g<c-]>', { noremap = true, silent = true, }) -- Follow link
vim.api.nvim_set_keymap('v', '<F6>', 'g<c-]>', { noremap = true, silent = true, })
vim.api.nvim_set_keymap('n', '<F9>', '<cmd>e!<cr>', { noremap = true, silent = true, })  -- Reload current buffer
vim.api.nvim_set_keymap('n', '<F10>', '<cmd>call setreg("/", [])<cr>', { noremap = true, silent = true, }) -- Clear search highlight
vim.api.nvim_set_keymap('n', '#%', '<cmd>echo expand("%:p:~")<cr>', { noremap = true, silent = true, }) -- Show full path and optionally referring to $HOME
vim.api.nvim_set_keymap('n', 'ZA', '<cmd>qa!<cr>', { noremap = true, silent = true, }) -- Getting out quickly
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true, }) -- Exit Terminal mode

-- Load the currently edited lua module
vim.api.nvim_set_keymap('n', '<leader><leader>l', '', { noremap = true, silent = true,
  callback = function()
    require('config.functions').reload_module(vim.fn.expand('%:t:r'))
  end,
})

return Module
