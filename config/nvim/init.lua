-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2022-Feb-05 21:47
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :
--

vim.g.mapleader = ' '    -- use space as a the leader key
vim.opt.swapfile = false -- Do not create swapfiles

-- Install package manager and plugins
require('plugins')

-- Configure the Language Servers
require('lsp_config').setup{}

-- Configure the keymappings
require('keymaps')

-- Create Globale Ex functions
require('commands')

-- Get Nvim Tree configured
vim.cmd [[
source ~/.config/nvim/nvim-tree-config.vim
]]
require'nvim-tree'.setup()

local function bufinfo()
  local tbstat = vim.bo.expandtab and ' spc' or ' tab'
  return 'ts:' .. vim.bo.tabstop .. ' sw:' .. vim.bo.shiftwidth .. ' sts:' .. vim.bo.softtabstop .. ' tw:' .. vim.bo.textwidth .. tbstat
end

local function bufstate()
  return vim.bo.modified and '[+]' or ''
end

local function fileinfo()
  return vim.bo.fileformat .. ' ' .. vim.bo.fileencoding .. ' ' .. vim.bo.filetype
end

local function filepath()
    local colons = {}
    for w in string.gmatch(vim.fn.expand('%:f'), ':') do
       colons[#colons+1] = w
    end
    local ret = ''
    if #colons > 1 then
        ret = "git:" .. vim.fn.expand("%:t")
    else
        ret = vim.fn.expand("%:f")
    end
    return ret
end


-- Statusline and bufferline configuration
package.loaded['staline'] = nil
require('staline').setup{
  sections = {
    left = {
      'right_sep', '-mode',
      'right_sep', filepath,
      'right_sep', 'branch',
    },
    mid  = {'cwd'},
    right= {
      bufstate,
      'cool_symbol', 'left_sep',
      'lsp_name', 'left_sep',
      bufinfo, 'left_sep',
      fileinfo, 'left_sep',
      'line_column', 'left_sep',
    }
  },
  defaults={
    fg = '#839496',
    bg = '#eee8d5',
    inactive_fgcolor = '#002b36',
    inactive_bgcolor = '#839496',
    left_separator = ' ',
    right_separator = ' ',
    true_colors = true,
    line_column = '[%03l:%03c] %02p%%',
    -- font_active = 'bold'
  },
  mode_colors = {
    n  = '#268bd2',
    i  = '#859900',
    ic = '#dc322f',
    c  = '#dc322f',
    v  = '#d33682',
    V  = '#d33682',
    x  = '#d33682',
    s  = '#986fec',
    S  = '#986fec',
  }
}

package.loaded['stabline'] = nil
require('stabline').setup {
  style       = "bubble", -- others: arrow, slant, bubble
  stab_left   = "",
  stab_right  = "",

  fg = '#839496',
  bg = '#eee8d5',
  inactive_fg = '#002b36',
  inactive_bg = '#839496',
  stab_bg     = '#839496',

  font_active = "bold",
  exclude_fts = { 'NvimTree', 'dashboard', 'lir' },
  stab_start  = "",   -- The starting of stabline
  stab_end    = "",
}

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

-- Show that this configuration file was loaded
print('loaded init.lua')
