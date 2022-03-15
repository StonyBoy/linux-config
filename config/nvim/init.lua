-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2022-Feb-19 16:48
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

vim.g.mapleader = ' '    -- use space as a the leader key
vim.opt.swapfile = false -- Do not create swapfiles

-- Install package manager and plugins
local ok, ret = pcall(require, 'plugins')
if not ok then
  print('Plugin error:', ret)
end


-- Configure the Language Servers
require('lsp_config').setup()

-- Configure the keymappings
-- package.loaded['keymaps'] = nil
require('keymaps')

-- Create Globale Ex functions
require('commands')

-- Configure statusline/bufferline
vim.cmd [[source ~/.config/nvim/lightline.vim]]

-- Text formatting defaults
vim.opt.textwidth = 120     -- Set the line width default value
vim.opt.colorcolumn = '120' -- Set the colour marker
vim.opt.shiftwidth = 4      -- Default 4 spaces
vim.opt.tabstop = 4         -- 4 spaces per tab
vim.opt.softtabstop = 4     -- 4 spaces per tab when unindenting
vim.opt.expandtab = true    -- Use spaces
vim.opt.smarttab = true     -- Indent smart

-- Visual Cues
vim.opt.hlsearch = true     -- highlight search - show the current search pattern
vim.opt.incsearch = true    -- Do the search while typing in a search pattern
vim.opt.ignorecase = true   -- Ignore cases while searching
vim.opt.showmatch = true    -- showmatch:   Show the matching bracket for the last ')'?
vim.opt.hlsearch = true     -- Set highlight on search
vim.opt.number = true       -- Make line numbers default
vim.opt.list = true         -- Show whitespace
vim.opt.listchars = {tab = '» ', trail = '•', extends = '…', precedes = '…', nbsp = '⎵'}

-- Do not highlight special key background
vim.cmd [[highlight SpecialKey ctermbg=NONE guibg=NONE]]

-- Text Formatting/Layout
vim.opt.autoindent = true        -- Auto indent, nice for coding
vim.opt.smartindent = true       -- Do smart autoindenting when starting a new line.
vim.opt.copyindent = true        -- Mirroring offset with automatic indentation
vim.opt.formatoptions = 'tcrqnj' -- See Help (complex)
vim.opt.linebreak = true         -- Insert automatic line breaks while typing
vim.opt.wrap = false             -- No wrap while displaying long lines
vim.opt.cinoptions = 'h2,g2,i8,N-s,(0,w1,Ws,t0,+s,:0,=s,l1,b0'

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

--Decrease update time
vim.opt.updatetime = 250
vim.opt.signcolumn = 'yes'

--Set colorscheme
vim.opt.termguicolors = true
vim.opt.background = 'light'
if vim.env['USER'] == 'root' or vim.env['TERM'] == 'linux' then
  vim.opt.background = 'dark'
end
vim.cmd [[colorscheme solarized8_high]]

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'

-- Bash like tab completion
vim.opt.wildmode = 'longest,list,full'
vim.opt.wildmenu = true
vim.opt.wildignorecase = true -- Ignore case when tab-expanding filenames

-- Empty the search register
vim.cmd [[call setreg('/', [])]]

-- Filetype handling
vim.cmd [[
filetype plugin on
augroup filetype_settings
    autocmd!
    autocmd BufNewFile,BufRead *.in setf make
    autocmd BufNewFile,BufRead *.c,*.h,*.S,*.dts,*.dtsi setlocal tabstop=8 shiftwidth=8 softtabstop=8 textwidth=80 noexpandtab colorcolumn=80 cindent
    autocmd BufNewFile,BufRead *.cxx,*.hxx              setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120 expandtab colorcolumn=120 cindent
    autocmd FileType c,h autocmd BufWritePre * :TrailspaceTrim
    autocmd FileType bash,ruby                          setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120 expandtab colorcolumn=120 cindent
    autocmd FileType lua                                setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120 expandtab colorcolumn=120 cindent
    autocmd FileType gitcommit,gitsendemail,mail        setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=75 expandtab colorcolumn=75
    autocmd FileType md,markdown,asciidoc,text,gitcommit,gitsendemail setlocal spell spelllang=en_us
    autocmd FileType c,cpp,js                           nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
    autocmd FileType c,cpp,js                           vnoremap <buffer><Leader>cf :ClangFormat<CR>
    autocmd FileType make                               setlocal tabstop=8 shiftwidth=8 softtabstop=8 textwidth=80 noexpandtab colorcolumn=80
augroup END
]]

-- Auto resize all VIM windows when VIM is resized
vim.cmd [[autocmd VimResized * :wincmd = ]]

-- Open file in the same folder as the current file using %%/
vim.cmd [[cabbr <expr> %% expand('%:p:h')]]

-- vim.cmd [[source ~/.config/nvim/lightline.vim]]
vim.cmd [[source ~/.config/nvim/timestamp.vim]]

-- Local Project Configuration: Read .vimlocal
vim.cmd [[silent! source .vimlocal]]

-- Debugging lua implementation
P = function(obj)
  print(vim.inspect(obj))
  return obj
end

RELOAD = function(...)
  return require("plenary.reload").reload_module(...)
end

R = function(name)
  RELOAD(name)
  return require(name)
end

-- Show that this configuration file was loaded
print('loaded init.lua')
