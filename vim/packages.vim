" VIM packages and the package manager
" Steen Hegelund
" Time-Stamp: 2022-Jun-01 19:04
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
Plug 'tpope/vim-unimpaired'                                       " Pairs of handy bracket mappings
Plug 'tpope/vim-surround'                                         " Mappings to easily delete, change and add such surroundings in pairs
Plug 'tpope/vim-commentary'                                       " Comment in/out lines of text in various languages
Plug 'tpope/vim-abolish'                                          " Word Case substitution: snake/mixed/camel/upper/
Plug 'itchyny/lightline.vim'                                      " Nice Status Line
Plug 'airblade/vim-gitgutter'                                     " Git: Changed lines since last revision
Plug 'lifepillar/vim-solarized8'                                  " Modern SolarlizedColorscheme
Plug 'christoomey/vim-tmux-navigator'                             " Go between panes in both vim and tmux
Plug 'jlanzarotta/bufexplorer'                                    " Manage Buffers
Plug 'vim-scripts/update-time'                                    " Insert/Update timestamps in files
Plug 'AndrewRadev/linediff.vim'                                   " Diff two separate blocks of text
Plug 'azabiong/vim-highlighter'                                   " Save/Load highlights, finding variables, and customizing colors
call plug#end()

