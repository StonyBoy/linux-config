" Steen Hegelund 18-dec-2018
source ~/.vim/packages.vim

let mapleader = ","

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible    " Setting an incompatible mode
set ttyfast         " Optimize for quick connection terminal
set number          " Turn on line numbers
set lazyredraw      " Do not redraw while running macros (much faster)
set scrolloff=5     " Scroll before the curser reaches top or buttom
set sidescrolloff=2 " Scroll before the curser reaches left or right side
set textwidth=80    " Set the line width to 80 characters
set hidden          " Allow edit buffers to be hidden
set guioptions=     " Remove menus

if has("multi_byte")
    set fillchars=stl:\ ,stlnc:\ ,vert:┆,fold:-,diff:-    " Displaying symbols to separate windows
    set lcs=tab:\»\ ,trail:•,extends:>,precedes:<,nbsp:¤" " Show white spaces
    let &sbr = nr2char(8618).' '
    set list        " Turn on the display of whitespace
endif

autocmd FileType c,cpp   setlocal colorcolumn=80  " Setting highlight long lines

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
set shiftwidth=8    " Number of spaces to use for each insertion of (auto)indent.
set tabstop=8       " Number of spaces that a <Tab> in the file counts for
set expandtab       " Expand Tabs (use spaces)?.
set formatoptions=tcrqnj " See Help (complex)
set linebreak       " Insert automatic line breaks while typing
set nowrap          " No wrap while displaying long lines
set cinoptions=h2,l2,g2,t0,i8,+8,(0,w1,W8,N-s

autocmd VimResized * :wincmd =    " Auto resize all VIM windows when VIM is resized

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

" Go to buffer number 1-20 (1-20gb)
let c = 1
while c <= 20
    execute "nnoremap " . c . "gb :" . c . "b\<CR>"
    let c += 1
endwhile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Using tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <silent> <leader>t<up> :tabr<cr>
nmap <silent> <leader>t<down> :tabl<cr>
nmap <silent> <leader>t<left> :tabp<cr>
nmap <silent> <leader>t<right> :tabn<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Reload VIMRC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <silent> <leader>rv   :source $MYVIMRC<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Yank and Paste Buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fu! PasteWindow(direction) "{{{
    if exists("g:yanked_buffer")
        if a:direction == 'edit'
            let temp_buffer = bufnr('%')
        endif

        exec a:direction . " +buffer" . g:yanked_buffer

        if a:direction == 'edit'
            let g:yanked_buffer = temp_buffer
        endif
    endif
endf "}}}

"yank/paste buffers
nmap <silent> <leader>wy  :let g:yanked_buffer=bufnr('%')<cr>
nmap <silent> <leader>wd  :let g:yanked_buffer=bufnr('%')<cr>:q<cr>
nmap <silent> <leader>wp :call PasteWindow('edit')<cr>
nmap <silent> <leader>ws :call PasteWindow('split')<cr>
nmap <silent> <leader>wv :call PasteWindow('vsplit')<cr>
nmap <silent> <leader>wt :call PasteWindow('tabnew')<cr>
nmap <silent> <leader>wP :top split
nmap <silent> <leader>wV :set nosplitright \| call PasteWindow('vsplit') \| set splitright<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Lightline
set laststatus=2
set noshowmode
let g:lightline = {
  \ 'colorscheme': 'solarized',
  \     'active': {
  \         'left': [['mode', 'paste' ], ['readonly', 'filename', 'modified', 'gitbranch']],
  \         'right': [['lineinfo'], ['percent'], ['fileformat', 'fileencoding'], ['session']]
  \     },
  \     'component_function': {
  \       'session': 'obsession#ObsessionStatus',
  \       'gitbranch': 'fugitive#head'
  \     },
  \ }

" YouCompleteMe configuration
let g:ycm_confirm_extra_conf = 0
nmap <silent> <leader>g :YcmCompleter GoTo<cr>

" CtrlP configuration
let g:ctrlp_working_path_mode = 'ca'

" Colorscheme configuration
syntax enable
set background=light
if $COLORTERM!="truecolor"
  let g:solarized_termcolors=256
endif
colorscheme solarized
highlight SpecialKey ctermbg=NONE guibg=NONE " Do not set special background

