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
call minpac#add('junegunn/fzf.vim')                     " Fuzzy File Finder
call minpac#add('itchyny/lightline.vim')                " Nice Status Line
call minpac#add('terryma/vim-multiple-cursors')         " Multiple cursors
call minpac#add('scrooloose/nerdtree')                  " Filesystem Explorer
call minpac#add('editorconfig/editorconfig-vim')        " Adapt editor config to current project
call minpac#add('airblade/vim-gitgutter')               " Git: Changed lines since last revision
call minpac#add('ctrlpvim/ctrlp.vim')                   " Find Files

packloadall

