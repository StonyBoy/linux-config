" VIM packages and the package manager
" 21-dec-2018 Steen Hegelund
"
command! PackUpdate packadd minpac | source $MYVIMRC | redraw | call minpac#update()
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()

if empty(glob('~/.vim/pack/minpac/opt/minpac/plugin/minpac.vim'))
  silent !git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac
endif

if !exists('*minpac#init')
  finish
endif

call minpac#init()

call minpac#add('k-takata/minpac', {'type': 'opt'})     " The minpack itself
call minpac#add('tpope/vim-sensible')                   " Sensible VIM settings
call minpac#add('junegunn/fzf.vim')                     " Fuzzy File Finder
call minpac#add('itchyny/lightline.vim')                " Nice Status Line
call minpac#add('terryma/vim-multiple-cursors')         " Multiple cursors
call minpac#add('scrooloose/nerdtree')                  " Filesystem Explorer
call minpac#add('editorconfig/editorconfig-vim')        " Adapt editor config to current project
call minpac#add('airblade/vim-gitgutter')               " Git: Changed lines since last revision
call minpac#add('ctrlpvim/ctrlp.vim')                   " Find Files
call minpac#add('altercation/vim-colors-solarized')     " Colorscheme
call minpac#add('vim-ruby/vim-ruby')                    " Ruby support
call minpac#add('tpope/vim-fugitive')                   " GIT support
call minpac#add('tpope/vim-obsession')                  " Automatic editing sessions
" call minpac#add('thaerkh/vim-indentguides')           " Indentation lines
" call minpac#add('python-mode/python-mode')            " Python support - not working with python3

packloadall

