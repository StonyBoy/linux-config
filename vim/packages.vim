" VIM packages and the package manager
" Steen Hegelund
" Time-Stamp: 2021-May-26 09:22
" vim: set ts=4 sw=4 sts=4 tw=120 et cc=120 :
"

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'                                         " Sensible VIM settings
Plug 'tpope/vim-tbone'                                            " Tmux commands and yank/put support
Plug 'tpope/vim-fugitive'                                         " GIT support
Plug 'tpope/vim-obsession'                                        " Automatic editing sessions
Plug 'tpope/vim-markdown'                                         " Syntax highlighting for markdown files
Plug 'tpope/vim-dispatch'                                         " Run build commands in the background and parse the result
Plug 'tpope/vim-unimpaired'                                       " Pairs of handy bracket mappings
Plug 'tpope/vim-surround'                                         " Mappings to easily delete, change and add such surroundings in pairs
Plug 'tpope/vim-commentary'                                       " Comment in/out lines of text in various languages
Plug 'tpope/vim-abolish'                                          " Word Case substitution: snake/mixed/camel/upper/
Plug 'itchyny/lightline.vim'                                      " Nice Status Line
Plug 'airblade/vim-gitgutter'                                     " Git: Changed lines since last revision
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Fuzzy File Finder binary
Plug 'junegunn/fzf.vim'                                           " Fuzzy File Finder
Plug 'junegunn/gv.vim'                                            " A git commit browser.
Plug 'junegunn/vim-easy-align'                                    " Align text on specific characters in nice columns
Plug 'lifepillar/vim-solarized8'                                  " Modern SolarlizedColorscheme
Plug 'vim-ruby/vim-ruby'                                          " Ruby support
Plug 'christoomey/vim-tmux-navigator'                             " Go between panes in both vim and tmux
Plug 'jlanzarotta/bufexplorer'                                    " Manage Buffers
Plug 'vim-scripts/update-time'                                    " Insert/Update timestamps in files
Plug 'pangloss/vim-javascript'                                    " Better Javascript indenting support
Plug 'rust-lang/rust.vim'                                         " Rust, syntax highlighting, formatting, Syntastic integration
Plug 'dense-analysis/ale'                                         " Asynchroneous Syntax checker
Plug 'wsdjeg/vim-fetch'                                           " Use line and column jumps in file paths as found in stack traces and similar output
Plug 'aklt/plantuml-syntax'                                       " PlantUML Syntax/Plugin/FTDetect
Plug 'AndrewRadev/linediff.vim'                                   " Diff two separate blocks of text
Plug 'AndrewRadev/splitjoin.vim'                                  " Switching between a single-line statement and a multi-line one
Plug 'idanarye/vim-merginal'                                      " Provides a nice interface for dealing with Git branches on top of fugitive
Plug 'rhysd/vim-clang-format'                                     " Format your code with specific coding style using clang-format
Plug 'yazgoo/unicodemoji'                                         " fast unicode emojis in terminal and vim with fzf
Plug 'nathanalderson/yang.vim'                                    " YANG syntax highlighting and other niceties for VIM
call plug#end()


""""""
" These plugins are not in use due to various problems
"""""
" 'scrooloose/nerdtree'                                                         " Filesystem Explorer: use netrx instead
" 'thaerkh/vim-indentguides'                                                    " Indentation lines - looks weird with black and white blocks
" 'python-mode/python-mode'                                                     " Python support - not working with python3
" 'ctrlpvim/ctrlp.vim'                                                          " Find Files: too few and incorrect suggestions
" 'jremmen/vim-ripgrep'                                                         " Provide ripgrep using :Rg <string|pattern> - FZF supports this
" 'editorconfig/editorconfig-vim'                                               " Adapt editor config to current project, use vim-sleuth
" 'vim-scripts/cscope.vim'                                                      " C code browser : Rather slow and causes windows to be unupdated
" 'ronakg/quickr-cscope.vim'                                                    " Code browser - use ctags instead - this also works for C++
" 'terryma/vim-multiple-cursors'                                                " Multiple cursors: not intuitive, never really used this
" 'vim-scripts/highlight.vim'                                                   " Highlight lines: ctrl+h collides with tmux shortcuts
" 'altercation/vim-colors-solarized'                                            " Colorscheme - replaced by the newer solarized8 using truecolor
" 'Valloric/YouCompleteMe',          { 'do': './install.py --clang-completer' } " Completion support for SW dev - collides with fugitive
" 'rdnetto/YCM-Generator',           { 'branch': 'stable'}                      " Generate a config file for YCM - did not really use this
" 'tpope/vim-sleuth'                                                            " Automatic indentation based of file content - conflicts with filetype plugin on
" 'vim/killersheep'                                                             " Game for testing vim 8.2 - not usable in nvim
