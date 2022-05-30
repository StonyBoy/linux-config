-- Neovim keymap configuration
-- Steen Hegelund
-- Time-Stamp: 2022-May-30 20:10
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local Module = {}

local locate = function(table, value)
    for i = 1, #table do
        if table[i] == value then return true end
    end
    return false
end

local get_modeline = function()
  local modeline = string.format(' vim: set ts=%d sw=%d sts=%d tw=%d cc=%s %s ft=%s',
  vim.opt.tabstop:get(),
  vim.opt.shiftwidth:get(),
  vim.opt.softtabstop:get(),
  vim.opt.textwidth:get(),
  table.concat(vim.opt.colorcolumn:get(), ','),
  vim.opt.expandtab:get() and 'et' or 'noet',
  vim.opt.filetype:get())
  if locate({ 'c', 'h', 'cpp', 'hpp' }, vim.bo.filetype) then
    modeline = modeline .. string.format(' cino=%s',
    vim.fn.escape(table.concat(vim.opt.cinoptions:get(), ','), ':'))
  end
  modeline = modeline .. ' :'
  return { string.format(vim.opt.commentstring:get(), modeline) }
end

local toggle_c_style = function()
  if vim.bo.expandtab then
    vim.bo.cinoptions   = '(0,w1,Ws,t0,:0,l1' -- C indent, Kernel style
    vim.bo.textwidth    = 80                  -- Set the line width default value
    vim.opt.colorcolumn = '80,100'            -- Set the colour markers
    vim.bo.shiftwidth   = 8                   -- Default 8 spaces
    vim.bo.tabstop      = 8                   -- 8 spaces per tab
    vim.bo.softtabstop  = 8                   -- 8 spaces per tab when unindenting
    vim.bo.expandtab    = false               -- Use tabs
  else
    vim.bo.cinoptions   = '(0,w1,Ws,t0,:s,l1' -- C indent, Userspace style
    vim.bo.textwidth    = 120                 -- Set the line width default value
    vim.opt.colorcolumn = '80,120'            -- Set the colour markers
    vim.bo.shiftwidth   = 4                   -- Default 4 spaces
    vim.bo.tabstop      = 4                   -- 4 spaces per tab
    vim.bo.softtabstop  = 4                   -- 4 spaces per tab when unindenting
    vim.bo.expandtab    = true                -- Use spaces
  end
  vim.bo.cindent        = true                -- Indent smart for C
end

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
vim.api.nvim_set_keymap('n', '<Leader><Leader>x', 'source %', { noremap = true, silent = true, })
vim.api.nvim_set_keymap('n', '<Leader>sv', '', { noremap = true, silent = true,
  callback = require('user.functions').reload_neovim,
})
vim.api.nvim_set_keymap('n', '<Leader>ev', 'vsplit $MYVIMRC', { noremap = true, silent = true, })
vim.api.nvim_set_keymap('n', '<Leader>ml', '', { noremap = true, silent = true,
  callback = function()
    vim.call('nvim_buf_set_lines', 0, -1, -1, 0, get_modeline())
  end,
})

-- Toggle C style formatting and indenting between Linux Kernel and Userspace style
vim.api.nvim_set_keymap('n', '<leader><leader>c', '', { noremap = true, silent = true,
  callback = toggle_c_style
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
    require('user.functions').reload_module(vim.fn.expand('%:t:r'))
  end,
})

return Module
