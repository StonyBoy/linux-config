-- Steen Hegelund
-- Time-Stamp: 2022-Apr-18 22:37

-- Steen Hegelund
-- Time-Stamp: #

-- Neovim keymap configuration
-- Steen Hegelund
-- Time-Stamp: 2022-Apr-18 18:46
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local Module = {}

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

-- Telescope usage
vim.api.nvim_set_keymap('n', '<Leader>ff', '', { noremap = true, silent = true,
  callback = require('telescope.builtin').find_files,
})
vim.api.nvim_set_keymap('n', '<Leader>fg', '', { noremap = true, silent = true,
  callback = require('telescope.builtin').live_grep,
})
vim.api.nvim_set_keymap('n', '<Leader>fh', '', { noremap = true, silent = true,
  callback = require('telescope.builtin').help_tags,
})
vim.api.nvim_set_keymap('n', '##', '', { noremap = true, silent = true,
  callback = require('telescope.builtin').grep_string,
})
vim.api.nvim_set_keymap('v', '##', '', { noremap = true, silent = true,
  callback = function()
    require('telescope.builtin').grep_string({search = require('functions').get_visual_selection()})
  end,
})
vim.api.nvim_set_keymap('n', '<Leader>fb', '', { noremap = true, silent = true,
  callback = function()
    require('telescope.builtin').current_buffer_fuzzy_find({ case_mode = 'ignore_case', sort = require('telescope.sorters').highlighter_only })
  end,
})

-- Assorted usage
vim.api.nvim_set_keymap('n', '<Leader><Leader>x', 'source %', { noremap = true, silent = true, })
vim.api.nvim_set_keymap('n', '<Leader>sv', '', { noremap = true, silent = true,
  callback = require("functions").reload_neovim,
})
vim.api.nvim_set_keymap('n', '<Leader>ev', 'vsplit $MYVIMRC', { noremap = true, silent = true, })
vim.api.nvim_set_keymap('n', '<Leader>ml', '', { noremap = true, silent = true,
  callback = function()
    local modeline = {
      string.format(vim.opt.commentstring:get(),
        string.format(" vim: set ts=%d sw=%d sts=%d tw=%d %s cc=%d ft=%s :",
          vim.opt.tabstop:get(),
          vim.opt.shiftwidth:get(),
          vim.opt.softtabstop:get(),
          vim.opt.textwidth:get(),
          vim.opt.expandtab:get() and 'et' or 'noet',
          vim.opt.colorcolumn:get()[1],
          vim.opt.filetype:get()))
    }
    vim.call('nvim_buf_set_lines', 0, -1, -1, 0, modeline)
  end,
})
vim.api.nvim_set_keymap('n', '<F6>', 'g<c-]>', { noremap = true, silent = true, }) -- Follow link
vim.api.nvim_set_keymap('v', '<F6>', 'g<c-]>', { noremap = true, silent = true, })
vim.api.nvim_set_keymap('n', '<F8>', '<cmd>ToggleBufExplorer<cr>', { noremap = true, silent = true, })
vim.api.nvim_set_keymap('n', '<F9>', '<cmd>e!<cr>', { noremap = true, silent = true, })  -- Reload current buffer
vim.api.nvim_set_keymap('n', '<F10>', '<cmd>call setreg("/", [])<cr>', { noremap = true, silent = true, }) -- Clear search highlight
vim.api.nvim_set_keymap('n', '#%', '<cmd>echo expand("%:p:~")<cr>', { noremap = true, silent = true, }) -- Show full path and optionally referring to $HOME
vim.api.nvim_set_keymap('n', 'ZA', '<cmd>qa!<cr>', { noremap = true, silent = true, }) -- Getting out quickly
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true, }) -- Exit Terminal mode
vim.api.nvim_set_keymap('n', 'ga', '<cmd>EasyAlign<cr>', { noremap = true, silent = true, }) -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
vim.api.nvim_set_keymap('x', 'ga', '<cmd>EasyAlign<cr>', { noremap = true, silent = true, }) -- Start interactive EasyAlign in visual mode (e.g. vipga)

-- LuaSnip usage
vim.api.nvim_set_keymap('n', '<Leader><Leader>s', '', { noremap = true, silent = true,
  callback = require('functions').ls_load,
})

-- gitto usage
vim.api.nvim_set_keymap('n', '<Leader><Leader>q', '', { noremap = true, silent = true,
  callback = require('git_session').shutdown,
})

return Module
