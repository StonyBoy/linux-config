" VIM packages and the package manager
" 21-dec-2018 Steen Hegelund
"

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

function! GetRunningOS()
  if has("win32")
    return "win"
  endif
  if has("unix")
    if system('uname')=~'Darwin'
      return "mac"
    else
      return "linux"
    endif
  endif
endfunction

let os=GetRunningOS()


call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'                   " Sensible VIM settings
Plug 'itchyny/lightline.vim'                " Nice Status Line
Plug 'terryma/vim-multiple-cursors'         " Multiple cursors
Plug 'airblade/vim-gitgutter'               " Git: Changed lines since last revision
if GetRunningOS() == "mac"
  Plug '/usr/local/opt/fzf'                 " Using the fzf binary (only on MacOS/Brew)
endif
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
Plug 'vim-scripts/cscope.vim'               " C code browser
call plug#end()


" Plug 'tpope/vim-dispatch'                 " Run build commands in the background
" Plug 'scrooloose/nerdtree'                " Filesystem Explorer
" Plug 'thaerkh/vim-indentguides'           " Indentation lines - looks weird with black and white blocks
" Plug 'python-mode/python-mode'            " Python support - not working with python3
" Plug 'ctrlpvim/ctrlp.vim'                 " Find Files: too few and incorrect suggestions
" Plug 'jremmen/vim-ripgrep'                " Provide ripgrep using :Rg <string|pattern> - FZF supports this
" Plug 'editorconfig/editorconfig-vim'      " Adapt editor config to current project, use vim-sleuth
