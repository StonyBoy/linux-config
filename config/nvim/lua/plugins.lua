-- NVIM packages and the package manager
-- Steen Hegelund
-- Time-Stamp: 2022-Apr-19 22:36
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 :

-- Install packer
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local packer_bootstrap = nil

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

local telescope_keymaps = function()
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
end

local easyalign_keymaps = function()
  vim.api.nvim_set_keymap('n', 'ga', '<cmd>EasyAlign<cr>', { noremap = true, silent = true, }) -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
  vim.api.nvim_set_keymap('x', 'ga', '<cmd>EasyAlign<cr>', { noremap = true, silent = true, }) -- Start interactive EasyAlign in visual mode (e.g. vipga)
end

-- Plugins will be installed in ~/.local/share/nvim/site/pack/packer/start
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Package manager
  use {
    'itchyny/lightline.vim',                        -- Nice Status Line
    config = 'vim.cmd[[source ~/.config/nvim/lightline.vim]]',
  }
  use {
    'StonyBoy/nvim-gitto',                          -- Git log plugin
    config = function()
      vim.api.nvim_set_keymap('n', '<Leader><Leader>q', '', { noremap = true, silent = true,
        callback = require('git_session').shutdown,
      })
    end,
  }
  use 'tpope/vim-sensible'                          -- Sensible VIM settings
  use 'tpope/vim-tbone'                             -- Tmux commands and yank/put support
  use 'tpope/vim-fugitive'                          -- GIT support
  use 'tpope/vim-obsession'                         -- Automatic editing sessions
  use 'tpope/vim-markdown'                          -- Syntax highlighting for markdown files
  use 'tpope/vim-dispatch'                          -- Run build commands in the background and parse the result
  use 'tpope/vim-unimpaired'                        -- Pairs of handy bracket mappings
  use 'tpope/vim-surround'                          -- Mappings to easily delete, change and add such surroundings in pairs
  use 'tpope/vim-abolish'                           -- Word Case substitution: snake/mixed/camel/upper/
  use 'tpope/vim-commentary'                        -- Comment in/out lines of text in various languages
  use 'airblade/vim-gitgutter'                      -- Git: Changed lines since last revision
  use {
    'junegunn/vim-easy-align',                      -- Align text on specific characters in nice columns
    config = easyalign_keymaps,
  }
  use 'lifepillar/vim-solarized8'                   -- Modern SolarlizedColorscheme
  use 'vim-ruby/vim-ruby'                           -- Ruby support
  use 'christoomey/vim-tmux-navigator'              -- Go between panes in both vim and tmux
  use {
    'jlanzarotta/bufexplorer',                      -- Manage Buffers
    config = function()
      vim.api.nvim_set_keymap('n', '<F8>', '<cmd>ToggleBufExplorer<cr>', { noremap = true, silent = true, })
    end,
  }
  use {
    'vim-scripts/update-time',                      -- Insert/Update timestamps in files
    config = 'vim.cmd [[source ~/.config/nvim/timestamp.vim]]',
  }
  use 'pangloss/vim-javascript'                     -- Better Javascript indenting support
  use 'rust-lang/rust.vim'                          -- Rust, syntax highlighting, formatting, Syntastic integration
  use 'wsdjeg/vim-fetch'                            -- Use line and column jumps in file paths as found in stack traces and similar output
  use 'aklt/plantuml-syntax'                        -- PlantUML Syntax/  usein/FTDetect
  use 'AndrewRadev/linediff.vim'                    -- Diff two separate blocks of text
  use 'AndrewRadev/splitjoin.vim'                   -- Switching between a single-line statement and a multi-line one
  use 'idanarye/vim-merginal'                       -- Provides a nice interface for dealing with Git branches on top of fugitive
  use 'rhysd/vim-clang-format'                      -- Format your code with specific coding style using clang-format
  use 'yazgoo/unicodemoji'                          -- fast unicode emojis in terminal and vim with fzf
  use {
    'nathanalderson/yang.vim',                      -- YANG syntax highlighting and other niceties for VIM
    branch = 'main',
  }
  use 'azabiong/vim-highlighter'                    -- Save/Load highlights, finding variables, and customizing colors
  use 'nvim-treesitter/nvim-treesitter'             -- Highlight, edit, and navigate code using a fast incremental parsing library
  use 'nvim-treesitter/nvim-treesitter-textobjects' -- Additional textobjects for treesitter
  use 'rafcamlet/nvim-luapad'                       -- Interactive neovim scratchpad for lua
  use {
    'neovim/nvim-lspconfig',                        -- Collection of configurations for built-in LSP client
    config = function()
      require('config.lsp').setup()
    end,
    disable = false,
  }
  use {'nvim-telescope/telescope.nvim',             -- a highly extendable fuzzy finder over lists
    requires = {
      'nvim-lua/plenary.nvim',                      -- Lua library
      'nvim-telescope/telescope-live-grep-raw.nvim' -- Live grep raw picker for telescope.nvim.
    },
    config = telescope_keymaps,
  }
  use {
    "L3MON4D3/LuaSnip",                             -- Snippet engine
    after = "nvim-cmp",
    config = function()
      require("config.snippets")
      vim.api.nvim_set_keymap('n', '<Leader><Leader>s', '<cmd>source ~/.config/nvim/lua/config/snippets.lua<cr>', { noremap = true, silent = true, })
    end,
    disable = false,
  }
  use {
    "hrsh7th/nvim-cmp",                             -- Completion engine
    event = "BufRead",
    requires = {
      { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
      { "hrsh7th/cmp-path", after = "nvim-cmp" },
      { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
      { "saadparwaiz1/cmp_luasnip", after = "LuaSnip" },
    },
    config = function()
      require("config.ncmp")
    end,
    disable = false,
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- These plugins are not in use due to various problems or newer neovim specific plugins

-- 'scrooloose/nerdtree'               -- Filesystem Explorer: use netrx instead
-- 'thaerkh/vim-indentguides'          -- Indentation lines - looks weird with black and white blocks
-- 'python-mode/python-mode'           -- Python support - not working with python3
-- 'ctrlpvim/ctrlp.vim'                -- Find Files: too few and incorrect suggestions
-- 'jremmen/vim-ripgrep'               -- Provide ripgrep using :Rg <string|pattern> - FZF supports this
-- 'editorconfig/editorconfig-vim'     -- Adapt editor config to current project, use vim-sleuth
-- 'vim-scripts/cscope.vim'            -- C code browser : Rather slow and causes windows to be unupdated
-- 'ronakg/quickr-cscope.vim'          -- Code browser - use ctags instead - this also works for C++
-- 'terryma/vim-multiple-cursors'      -- Multiple cursors: not intuitive, never really used this
-- 'vim-scripts/highlight.vim'         -- Highlight lines: ctrl+h collides with tmux shortcuts
-- 'altercation/vim-colors-solarized'  -- Colorscheme - replaced by the newer solarized8 using truecolor
-- 'Valloric/YouCompleteMe'            -- Completion support for SW dev - collides with fugitive
-- 'rdnetto/YCM-Generator'             -- Generate a config file for YCM - did not really use this
-- 'tpope/vim-sleuth'                  -- Automatic indentation based of file content - conflicts with filetype plugin on
-- 'vim/killersheep'                   -- Game for testing vim 8.2 - not usable in nvim
-- 'rootkiter/vim-hexedit'             -- Activates on plain text files, and then triggers script errors
-- 'dense-analysis/ale'                -- Asynchroneous Syntax checker, may not be needed anymore...
-- 'junegunn/fzf.vim'                  -- Fuzzy File Finder
-- 'junegunn/fzf'                      -- Fuzzy File Finder binary
-- 'kyazdani42/nvim-tree.lua',         -- A File Explorer For Neovim
-- 'numToStr/Comment.nvim'             -- Smart and Powerful commenting plugin for neovim
-- 'tamton-aquib/staline.nvim'         -- A simple statusline and bufferline for neovim written in lua.
