" VIM packages and the package manager
" Steen Hegelund
" Time-Stamp: 2019-Oct-11 16:22
"

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'                   " Sensible VIM settings
Plug 'tpope/vim-tbone'                      " Tmux commands and yank/put support
Plug 'itchyny/lightline.vim'                " Nice Status Line
Plug 'airblade/vim-gitgutter'               " Git: Changed lines since last revision
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Fuzzy File Finder binary
Plug 'junegunn/fzf.vim'                     " Fuzzy File Finder
Plug 'altercation/vim-colors-solarized'     " Colorscheme
Plug 'vim-ruby/vim-ruby'                    " Ruby support
Plug 'tpope/vim-fugitive'                   " GIT support
Plug 'tpope/vim-obsession'                  " Automatic editing sessions
Plug 'tpope/vim-sleuth'                     " Automatic indentation based of file content
Plug 'christoomey/vim-tmux-navigator'       " Go between panes in both vim and tmux
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' } " Completion support for SW dev
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'} " Generate a config file for YCM
Plug 'jlanzarotta/bufexplorer'              " Manage Buffers
Plug 'tpope/vim-markdown'                   " Syntax highlighting for markdown files
Plug 'tpope/vim-dispatch'                   " Run build commands in the background and parse the result
Plug 'vim-scripts/update-time'              " Insert/Update timestamps in files
call plug#end()


" Plug 'scrooloose/nerdtree'                " Filesystem Explorer
" Plug 'thaerkh/vim-indentguides'           " Indentation lines - looks weird with black and white blocks
" Plug 'python-mode/python-mode'            " Python support - not working with python3
" Plug 'ctrlpvim/ctrlp.vim'                 " Find Files: too few and incorrect suggestions
" Plug 'jremmen/vim-ripgrep'                " Provide ripgrep using :Rg <string|pattern> - FZF supports this
" Plug 'editorconfig/editorconfig-vim'      " Adapt editor config to current project, use vim-sleuth
" Plug 'vim-scripts/cscope.vim'             " C code browser : Rather slow and causes windows to be unupdated
" Plug 'vim-scripts/highlight.vim'          " Highlight lines
" Plug 'ronakg/quickr-cscope.vim'           " Code browser - use ctags instead - this also works for C++
" Plug 'terryma/vim-multiple-cursors'         " Multiple cursors: not intuitive, never really used this
