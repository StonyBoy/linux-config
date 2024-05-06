-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2024-May-06 11:29
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

return {
  'tpope/vim-eunuch',                  -- Vim sugar for the UNIX shell commands that need it the most
  'tpope/vim-fugitive',                -- GIT support
  'tpope/vim-obsession',               -- Automatic editing sessions
  'tpope/vim-abolish',                 -- Word Case substitution: snake/mixed/camel/upper/
  'AndrewRadev/linediff.vim',          -- Diff two separate blocks of text
  'triglav/vim-visual-increment',      -- Increment lists in visual mode
  'azabiong/vim-highlighter',          -- Save/Load highlights, finding variables, and customizing colors
  'wsdjeg/vim-fetch',                  -- Use line and column jumps in file paths as found in stack traces and similar output
  'aklt/plantuml-syntax',              -- PlantUML Syntax/  usein/FTDetect
  'rafcamlet/nvim-luapad',             -- Interactive neovim scratchpad for lua
  'nvim-neotest/nvim-nio',             -- A library for asynchronous IO in Neovim, inspired by the asyncio library in Python
}

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
-- 'idanarye/vim-merginal'             -- Never really used this
-- 'duane9/nvim-rg'                    -- Does not allow folders or specific files
-- 'tpope/vim-sensible'                -- Sensible VIM settings: overwrites listchars in neovim 0.8.2
-- 'nathanalderson/yang.vim'           -- YANG syntax highlighting and other niceties for VIM
-- 'rebelot/kanagawa.nvim'             -- Colorscheme inspired by the colors of the famous painting by Katsushika Hokusai.
-- 'tpope/vim-markdown',               -- Syntax highlighting for markdown files
-- 'tpope/vim-dispatch',               -- Run build commands in the background and parse the result
-- 'tpope/vim-unimpaired',             -- Pairs of handy bracket mappings
-- 'tpope/vim-surround',               -- Mappings to easily delete, change and add such surroundings in pairs
-- 'AndrewRadev/splitjoin.vim',        -- Switching between a single-line statement and a multi-line one
-- 'rhysd/vim-clang-format',           -- Format your code with specific coding style using clang-format
-- 'yazgoo/unicodemoji',               -- fast unicode emojis in terminal and vim with fzf
-- 'vim-ruby/vim-ruby',                -- Ruby support
-- 'pangloss/vim-javascript',          -- Better Javascript indenting support
-- 'rust-lang/rust.vim',               -- Rust, syntax highlighting, formatting, Syntastic integration
-- 'kalafut/vim-taskjuggler',          -- Vim syntax highlighting for TaskJuggler files.
-- 'tpope/vim-commentary',             -- Comment in/out lines of text in various languages
-- 'airblade/vim-gitgutter',           -- Git: Changed lines since last revision
