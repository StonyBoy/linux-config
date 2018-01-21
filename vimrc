let g:clang_make_default_keymappings=0

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'vim-scripts/tlib'            " Utility library
Plug 'tpope/vim-sensible'          " Basic vim settings
Plug 'godlygeek/csapprox'          " Fixes color schema
Plug 'SirVer/ultisnips'            " Snippet engine
Plug 'honza/vim-snippets'

Plug 'vim-ruby/vim-ruby'           " Better ruby support
Plug 'rhysd/vim-clang-format'      " Clang format

"Plug 'vim-scripts/csindent.vim'    " Project specific settings
Plug 'vim-scripts/FSwitch'         " Easy switching between header and c files
Plug 'vim-scripts/highlight.vim'   " Highlight lines

Plug 'wincent/command-t', { 'do': 'cd ruby/command-t && ruby extconf.rb && make' } " fuzzy file search
"Plug 'vim-ctrlspace/vim-ctrlspace'

Plug 'asciidoc/vim-asciidoc'

" For asciidotcot support
"Plug 'dahu/vimple'
"Plug 'dahu/Asif'
"Plug 'Raimondi/VimRegStyle'
"Plug 'vim-scripts/SyntaxRange'
"Plug 'dahu/vim-asciidoc'

Plug 'tpope/vim-tbone'             " Access copy-paster buffer in tmux
Plug 'tpope/vim-repeat'            " Just make '.' work as it used to
Plug 'tpope/vim-fugitive'          " Git plugin
Plug 'tpope/vim-unimpaired'        " short-cuts for cnext/cprev and other
Plug 'tpope/vim-speeddating'       " Make <C-A>/<C-X> work for dates (as well)
Plug 'tpope/vim-characterize'

"Plug 'scrooloose/nerdtree'         " File browser
"Plug 'tpope/vim-vinegar'           " Tuning the buildin file explore

Plug 'airblade/vim-gitgutter'

Plug 'vim-airline/vim-airline'     " Fancy status line, must come after fugitive

Plug 'neomake/neomake'             " Async build current buffer
"Plug 'vim-syntastic/syntastic'

Plug 'vim-scripts/DrawIt'          " Ascii drawings
Plug 'sk1418/blockit'

Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'altercation/vim-colors-solarized' " Color scheme

"Plug 'Lokaltog/vim-powerline', { 'branch': 'develop' }      " Fancy status line
call plug#end()

" Basic Settings
set nocompatible    " Setting an incompatible mode
set ttyfast         " Optimize for quick connection terminal
set number          " Turn on line numbers
set lazyredraw      " Do not redraw while running macros (much faster)
set scrolloff=5     " Scroll before the curser reaches top or buttom
set sidescrolloff=2 " Scroll before the curser reaches left or right side
set textwidth=80    " Set the line width to 80 characters
autocmd FileType c,cpp setlocal colorcolumn=80  " Setting highlight long lines
set hidden          " Allow edit buffers to be hidden
set guioptions=     " Remove menus
colorscheme morning " This is a nice color scheame

if has("multi_byte")
    set fillchars=stl:\ ,stlnc:\ ,vert:┆,fold:-,diff:-    " Displaying symbols to separate windows
    set lcs=tab:\»\ ,trail:•,extends:>,precedes:<,nbsp:¤" " Show white spaces
    let &sbr = nr2char(8618).' '
    set list        " Turn on the display of whitespace
endif

if has("gui_running")
  if has("gui_gtk2")
    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 11
  endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual Cues
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set noerrorbells    " Turn off beep on error
set hlsearch        " highlight search - show the current search pattern
set incsearch       " Do the search while typing in a search pattern
set ignorecase      " Ignore cases while searching
set showmatch       " showmatch:   Show the matching bracket for the last ')'?

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text Formatting/Layout
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoindent      " Auto indent, nice for coding
set smartindent     " Do smart autoindenting when starting a new line.
autocmd FileType c,cpp setlocal cindent
set copyindent      " Mirroring offset with automatic indentation
set shiftwidth=4    " Number of spaces to use for each insertion of (auto)indent.
set tabstop=8       " Number of spaces that a <Tab> in the file counts for
set expandtab       " Expand Tabs (use spaces)?.
set formatoptions=tcrqnj " See Help (complex)
set linebreak       " Insert automatic line breaks while typing
set nowrap          " No wrap while displaying long lines
set cinoptions=h2,l2,g2,t0,i8,+8,(0,w1,W8,N-s

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Storage
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set directory=~/.vim/tmp,~/tmp,.,/tmp " Set the temporary directory
set confirm " Instead of an error message at the end of the editor asks whether to change Saved
set viminfo='100000,f1,:100000,/100000 " Setting File viminfo
set undodir=~/.vim/undodir " Directory for saving undo
set undofile               " Set the file name to undo - automatically
set undolevels=1024        " The number of changes that can be returned
set undoreload=65538       " The maximum number of lines that can be saved in the undo buffer RELOADE

" Bash like tab completion
set wildmode=longest,list,full
set wildmenu

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Powerline status bar
let g:Powerline_symbols="fancy"
let g:Powerline_theme="default"
let g:Powerline_colorscheme="default"
let g:airline_powerline_fonts = 1

" use gid for grepping
set grepprg=gid
set grepformat=%f:%l:%m

autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

let g:DoxygenToolkit_briefTag_pre="\\brief "
let g:DoxygenToolkit_paramTag_pre="\\param "
let g:DoxygenToolkit_returnTag="\\return "
let g:DoxygenToolkit_authorName="Allan W. Nielsen"
let g:DoxygenToolkit_compactOneLineDoc="yes"
let g:DoxygenToolkit_compactDoc="yes"

autocmd BufEnter * :syntax sync minlines=1000

au! BufEnter */vtss_basics/src/*.cxx                       let b:fswitchdst = 'hxx' | let b:fswitchlocs = 'reg:|src|include/vtss/basics|'
au! BufEnter */vtss_basics/src/*/*.cxx                     let b:fswitchdst = 'hxx' | let b:fswitchlocs = 'reg:|src|include/vtss/basics|'
au! BufEnter */vtss_basics/src/*/*/*.cxx                   let b:fswitchdst = 'hxx' | let b:fswitchlocs = 'reg:|src|include/vtss/basics|'
au! BufEnter */vtss_basics/src/*/*/*/*.cxx                 let b:fswitchdst = 'hxx' | let b:fswitchlocs = 'reg:|src|include/vtss/basics|'
au! BufEnter */vtss_basics/include/vtss/basics/*.hxx       let b:fswitchdst = 'cxx' | let b:fswitchlocs = 'reg:/include.vtss.basics/src/'
au! BufEnter */vtss_basics/include/vtss/basics/*/*.hxx     let b:fswitchdst = 'cxx' | let b:fswitchlocs = 'reg:/include.vtss.basics/src/'
au! BufEnter */vtss_basics/include/vtss/basics/*/*/*.hxx   let b:fswitchdst = 'cxx' | let b:fswitchlocs = 'reg:/include.vtss.basics/src/'
au! BufEnter */vtss_basics/include/vtss/basics/*/*/*/*.hxx let b:fswitchdst = 'cxx' | let b:fswitchlocs = 'reg:/include.vtss.basics/src/'

au! BufEnter */vtss_appl/*.hxx let b:fswitchdst = 'cxx' | let b:fswitchlocs = 'rel:.'
au! BufEnter */vtss_appl/*.cxx let b:fswitchdst = 'hxx' | let b:fswitchlocs = 'rel:.'
au! BufEnter */vtss_appl/*/*.hxx let b:fswitchdst = 'cxx' | let b:fswitchlocs = 'rel:.'
au! BufEnter */vtss_appl/*/*.cxx let b:fswitchdst = 'hxx' | let b:fswitchlocs = 'rel:.'

" The transition to alternative buffer (eg, from the header file to cpp and vice versa)
map <F12> :FSHere<CR>
imap <F12> <ESC>:FSHere<CR>


set diffexpr=MyDiff()
function MyDiff()
   let opt = ""
   if &diffopt =~ "icase"
     let opt = opt . "-i "
   endif
   if &diffopt =~ "iwhite"
     let opt = opt . "-b "
   endif
   silent execute "!diff -d -a --binary " . opt . v:fname_in . " " . v:fname_new .
        \  " > " . v:fname_out
endfunction

let g:tex_conceal = ""

let g:neomake_verbose = 3
let g:neomake_logfile = '/tmp/neo'


let g:neomake_cpp_ctidy_maker = {
    \ 'exe': './build/tools/ctidy',
    \ 'append_file': 0,
    \ 'args': ['-e', '-f', '%:p'],
    \ 'errorformat': '%E%f:%l:%c: error: %m,',
    \ }
"let g:neomake_cpp_ctidy_maker = {
"    \ 'exe': './build/tools/ctidy',
"    \ 'append_file': 0,
"    \ 'args': ['-e -f %:p'],
"        \ 'errorformat':
"            \ '%E%f:%l:%c: fatal error: %m,' .
"            \ '%E%f:%l:%c: error: %m,' .
"            \ '%W%f:%l:%c: warning: %m,' .
"            \ '%-G%\m%\%%(LLVM ERROR:%\|No compilation database found%\)%\@!%.%#,' .
"            \ '%E%m',
"    \ }
let g:neomake_cpp_enabled_makers = ['ctidy']

set makeprg =./build/tools/ctidy\ -e\ -f\ %
set makeprg =make\ %

let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax
