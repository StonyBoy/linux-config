-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2022-May-22 17:20
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

vim.g.mapleader = ' '    -- use space as a the leader key
vim.opt.swapfile = false -- Do not create swapfiles

-- Install package manager and plugins
local ok, ret = pcall(require, 'plugins')
if not ok then
  print('Plugin error:', ret)
end

-- Text formatting defaults
vim.opt.textwidth = 120     -- Set the line width default value
vim.opt.colorcolumn = '120' -- Set the colour marker
vim.opt.shiftwidth = 4      -- Default 4 spaces
vim.opt.tabstop = 4         -- 4 spaces per tab
vim.opt.softtabstop = 4     -- 4 spaces per tab when unindenting
vim.opt.expandtab = true    -- Use spaces
vim.opt.smarttab = true     -- Indent smart

-- Visual Cues
vim.opt.guicursor = 'n-v-c-sm:block-blinkwait300-blinkon200-blinkoff150,i-ci-ve:ver25-blinkwait300-blinkon200-blinkoff150,r-cr-o:hor200-blinkwait300-blinkon200-blinkoff150'
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
vim.opt.cinoptions = '(0,w1,Ws,t0,:0,l1'  -- C indent, Linux Kernel Style

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
local grp = vim.api.nvim_create_augroup('filetype_settings', {})
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = grp,
  pattern =  '*.in',
  command = 'setf make'
})
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = grp,
  pattern =  {'*.c', '*.h', '*.S', '*.dts', '*.dtsi'},
  command = 'setlocal tabstop=8 shiftwidth=8 softtabstop=8 textwidth=80 noexpandtab colorcolumn=80 cindent'
})
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = grp,
  pattern = {'*.cxx', '*.hxx'},
  command = 'setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120 expandtab colorcolumn=120 cindent',
})
vim.api.nvim_create_autocmd('BufWritePre', {
  group = grp,
  pattern = {'*.c', '*.h'},
  command = 'TrailspaceTrim',
})
vim.api.nvim_create_autocmd('FileType', {
  group = grp,
  pattern = {'bash', 'ruby'},
  command = 'setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120 expandtab colorcolumn=120 cindent',
})
vim.api.nvim_create_autocmd('FileType', {
  group = grp,
  pattern = {'lua'},
  command = 'setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120 expandtab colorcolumn=120 cindent',
})
vim.api.nvim_create_autocmd('FileType', {
  group = grp,
  pattern = {'gitcommit', 'gitsendemail', 'mail'},
  command = 'setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=75 expandtab colorcolumn=75 cindent',
})
vim.api.nvim_create_autocmd('FileType', {
  group = grp,
  pattern = {'md', 'markdown', 'asciidoc', 'text', 'gitcommit', 'gitsendemail'},
  command = 'setlocal spell spelllang=en_us',
})
vim.api.nvim_create_autocmd('FileType', {
  group = grp,
  pattern = {'make'},
  command = 'setlocal tabstop=8 shiftwidth=8 softtabstop=8 textwidth=80 colorcolumn=80',
})

-- Auto resize all VIM windows when VIM is resized
grp = vim.api.nvim_create_augroup('nvim_windows', {})
vim.api.nvim_create_autocmd({'VimResized'}, {
  group = grp,
  command = 'wincmd ='
})

-- Open file in the same folder as the current file using %%/
vim.cmd [[cabbr <expr> %% expand('%:p:h')]]

-- Local Project Configuration: Read .vimlocal
vim.cmd [[silent! source .vimlocal]]

-- Configure the keymappings
-- package.loaded['keymaps'] = nil
require('keymaps')

-- Create Globale Ex functions
require('commands')

-- Show that this configuration file was loaded
print('loaded init.lua')
