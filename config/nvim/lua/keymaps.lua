-- Neovim keymap configuration
-- Steen Hegelund
-- Time-Stamp: 2022-Jan-24 20:49
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local Module = {}

local keymap = function(key)
  -- get the extra options
  local opts = {noremap = true}
  for i, v in pairs(key) do
    if type(i) == 'string' then opts[i] = v end
  end

  -- basic support for buffer-scoped keybindings
  local buffer = opts.buffer
  opts.buffer = nil

  if buffer then
    vim.api.nvim_buf_set_keymap(0, key[1], key[2], key[3], opts)
  else
    vim.api.nvim_set_keymap(key[1], key[2], key[3], opts)
  end
end

-- Using tabs
function tab_usage()
  vim.cmd [[
  nnoremap <silent> <leader>t<up> :tabr<cr>
  nnoremap <silent> <leader>t<down> :tabl<cr>
  nnoremap <silent> <leader>t<left> :tabp<cr>
  nnoremap <silent> <leader>t<right> :tabn<cr>
  ]]
end


-- Remapping XTERM specialities
function xterm_usage()
  vim.cmd [[
  nnoremap <silent> <ESC>[1;5D  <C-left>
  nnoremap <silent> <ESC>[1;5C  <C-right>
  cnoremap <silent> <ESC>[1;5D  <C-left>
  cnoremap <silent> <ESC>[1;5C  <C-right>
  ]]
end

function window_resize()
  keymap {'n', '<C-M-S-Left>', ':vertical resize -1<cr>'}
  keymap {'n', '<C-M-S-Right>', ':vertical resize +1<cr>'}
  keymap {'n', '<C-M-S-Down>', ':resize -1<cr>'}
  keymap {'n', '<C-M-S-Up>', ':resize +1<cr>'}
end

-- Global function for appending a mode line to a buffer
append_modeline = function()
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
end

function dev_usage()
  keymap {'n', '<leader>is', ':r ~/work/patches/signedoffby.txt<CR>'} -- Add signed-off-by
  keymap {'n', '<silent>', '<leader>it Opr_info("%s:%d\n", __func__, __LINE__);<esc>'}
  keymap {'n', '<silent>', '<leader>id OCFLAGS_*.o := -DDEBUG<CR><esc>'}
  keymap {'n', '<silent>', '<leader>fm :setlocal foldmethod=syntax<CR>'}
  keymap {'c', 'w!!', 'execute "silent! write !sudo tee % >/dev/null" <bar> edit!'}
end

function assorted_usage()
  keymap {'n', '<Leader>sv', ':source $MYVIMRC<cr>'}
  keymap {'n', '<Leader>ev', ':vs $MYVIMRC<cr>'}
  keymap {'n', '<F6>', 'g<c-]>'} -- Follow link
  keymap {'v', '<F6>', 'g<c-]>'}
  keymap {'n', '<F8>', ':ToggleBufExplorer<cr>'}
  keymap {'n', '<F9>', ':e!<cr>'}  -- Reload current buffer
  keymap {'n', '<F10>', ':call setreg("/", [])<cr>'} -- Clear search highlight
  keymap {'n', '#%', ':echo expand("%:p:~")<CR>'} -- Show full path and optionally referring to $HOME
  keymap {'n', 'ZA', ':qa!<CR>'} -- Getting out quickly
  keymap {'x', 'ga', '<Plug>(EasyAlign)'} -- Start interactive EasyAlign in visual mode (e.g. vipga)
  keymap {'n', 'ga', '<Plug>(EasyAlign)'} -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
  keymap {'n', '<Leader>ml', ':lua append_modeline()<cr>'}
  keymap {'t', '<Esc>', '<C-\\><C-n>'} -- Terminal mode
  keymap {'n', '##', ':lua require("functions").selected_word_ripgrep()<cr>' }
  keymap {'v', '##', ':lua require("functions").visual_selection_ripgrep()<cr>' }
end

-- Setup all the keymappings
assorted_usage()
tab_usage()
xterm_usage()
window_resize()
dev_usage()

return Module
