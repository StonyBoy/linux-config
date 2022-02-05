-- NVIM packages and the package manager
-- Steen Hegelund
-- Time-Stamp: 2022-Feb-05 16:06
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 :

-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.cmd [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]]

-- Plugins will be installed in ~/.local/share/nvim/site/pack/packer/start
--
local use = require('packer').use
require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- Package manager
  use 'tpope/vim-sensible'                                         -- Sensible VIM settings
  use 'tpope/vim-tbone'                                            -- Tmux commands and yank/put support
  use 'tpope/vim-fugitive'                                         -- GIT support
  use 'tpope/vim-obsession'                                        -- Automatic editing sessions
  use 'tpope/vim-markdown'                                         -- Syntax highlighting for markdown files
  use 'tpope/vim-dispatch'                                         -- Run build commands in the background and parse the result
  use 'tpope/vim-unimpaired'                                       -- Pairs of handy bracket mappings
  use 'tpope/vim-surround'                                         -- Mappings to easily delete, change and add such surroundings in pairs
  use 'tpope/vim-commentary'                                       -- Comment in/out lines of text in various languages
  use 'tpope/vim-abolish'                                          -- Word Case substitution: snake/mixed/camel/upper/
  use 'airblade/vim-gitgutter'                                     -- Git: Changed lines since last revision
  use 'junegunn/gv.vim'                                            -- A git commit browser.
  use 'junegunn/vim-easy-align'                                    -- Align text on specific characters in nice columns
  use 'lifepillar/vim-solarized8'                                  -- Modern SolarlizedColorscheme
  use 'vim-ruby/vim-ruby'                                          -- Ruby support
  use 'christoomey/vim-tmux-navigator'                             -- Go between panes in both vim and tmux
  use 'jlanzarotta/bufexplorer'                                    -- Manage Buffers
  use 'vim-scripts/update-time'                                    -- Insert/Update timestamps in files
  use 'pangloss/vim-javascript'                                    -- Better Javascript indenting support
  use 'rust-lang/rust.vim'                                         -- Rust, syntax highlighting, formatting, Syntastic integration
  use 'wsdjeg/vim-fetch'                                           -- Use line and column jumps in file paths as found in stack traces and similar output
  use 'aklt/plantuml-syntax'                                       -- PlantUML Syntax/  usein/FTDetect
  use 'AndrewRadev/linediff.vim'                                   -- Diff two separate blocks of text
  use 'AndrewRadev/splitjoin.vim'                                  -- Switching between a single-line statement and a multi-line one
  use 'idanarye/vim-merginal'                                      -- Provides a nice interface for dealing with Git branches on top of fugitive
  use 'rhysd/vim-clang-format'                                     -- Format your code with specific coding style using clang-format
  use 'yazgoo/unicodemoji'                                         -- fast unicode emojis in terminal and vim with fzf
  use 'nathanalderson/yang.vim'                                    -- YANG syntax highlighting and other niceties for VIM
  use 'azabiong/vim-highlighter'                                   -- Save/Load highlights, finding variables, and customizing colors
  -- Highlight, edit, and navigate code using a fast incremental parsing library
  use 'nvim-treesitter/nvim-treesitter'
  -- Additional textobjects for treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
  use 'rafcamlet/nvim-luapad'                                      -- Interactive neovim scratchpad for lua
  use {'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-live-grep-raw.nvim' }
  }
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    config = function() require'nvim-tree'.setup {} end
  }
  use 'tamton-aquib/staline.nvim'                                  -- A simple statusline and bufferline for neovim written in lua.
end)

-- These plugins are not in use due to various problems

--  use 'itchyny/lightline.vim'                                      -- Nice Status Line
-- 'scrooloose/nerdtree'              " Filesystem Explorer: use netrx instead
-- 'thaerkh/vim-indentguides'         " Indentation lines - looks weird with black and white blocks
-- 'python-mode/python-mode'          " Python support - not working with python3
-- 'ctrlpvim/ctrlp.vim'               " Find Files: too few and incorrect suggestions
-- 'jremmen/vim-ripgrep'              " Provide ripgrep using :Rg <string|pattern> - FZF supports this
-- 'editorconfig/editorconfig-vim'    " Adapt editor config to current project, use vim-sleuth
-- 'vim-scripts/cscope.vim'           " C code browser : Rather slow and causes windows to be unupdated
-- 'ronakg/quickr-cscope.vim'         " Code browser - use ctags instead - this also works for C++
-- 'terryma/vim-multiple-cursors'     " Multiple cursors: not intuitive, never really used this
-- 'vim-scripts/highlight.vim'        " Highlight lines: ctrl+h collides with tmux shortcuts
-- 'altercation/vim-colors-solarized' " Colorscheme - replaced by the newer solarized8 using truecolor
-- 'Valloric/YouCompleteMe',          { 'do': './install.py --clang-completer' } " Completion support for SW dev - collides with fugitive
-- 'rdnetto/YCM-Generator',           { 'branch': 'stable'}                      " Generate a config file for YCM - did not really use this
-- 'tpope/vim-sleuth'                 " Automatic indentation based of file content - conflicts with filetype plugin on
-- 'vim/killersheep'                  " Game for testing vim 8.2 - not usable in nvim
-- 'rootkiter/vim-hexedit'            " Activates on plain text files, and then triggers script errors
-- 'dense-analysis/ale'               " Asynchroneous Syntax checker, may not be needed anymore...
  -- use {'junegunn/fzf', dir = '~/.fzf', ['do'] = './install --all' } -- Fuzzy File Finder binary
  -- use 'junegunn/fzf.vim'                                           -- Fuzzy File Finder
