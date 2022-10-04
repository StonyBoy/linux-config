-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2022-Oct-03 14:45
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

vim.g.mapleader = ' '    -- use space as a the leader key
vim.opt.swapfile = false -- Do not create swapfiles

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

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'

-- Bash like tab completion
vim.opt.wildmode = 'longest,list,full'
vim.opt.wildmenu = true
vim.opt.wildignorecase = true -- Ignore case when tab-expanding filenames

-- Empty the search register
vim.cmd [[call setreg('/', [])]]

-- Open file in the same folder as the current file using %%/
vim.cmd [[cabbr <expr> %% expand('%:p:h')]]

-- Local Project Configuration: Read .vimlocal
vim.cmd [[silent! source .vimlocal]]

-- Do not use the mouse (makes copy/paste work as before nvim 0.8)
vim.cmd[[set mouse=]]
