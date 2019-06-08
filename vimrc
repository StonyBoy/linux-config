" VIM settings
" Steen Hegelund
" Time-Stamp: 2019-Jun-08 19:01

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
set formatoptions=tcrqnj " See Help (complex)
set linebreak       " Insert automatic line breaks while typing
set nowrap          " No wrap while displaying long lines
set cinoptions=h2,g2,i8,N-s,(0,w1,Ws,t0,+s,:0,=s,l1,b0

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
" Remapping XTERM specialities
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <silent> <ESC>[1;5D  <C-left>
nmap <silent> <ESC>[1;5C  <C-right>
cmap <silent> <ESC>[1;5D  <C-left>
cmap <silent> <ESC>[1;5C  <C-right>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Reload VIMRC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <silent> <leader>rv   :source $MYVIMRC<cr>:echom ".vimrc reloaded"<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Useful VIM shortcuts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Search visual selection by //
vnoremap // y/<C-r>"<cr>

" Open file in the same folder as the current file using %%/
cabbr <expr> %% expand('%:p:h')


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Timestamps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:update_time_time_stamp_leader = 'Time-Stamp: '
let g:update_time_time_format = '%Y-%b-%d %H:%M'

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
  \         'left': [['mode'], ['paste', 'gitbranch', 'absolutepath']],
  \         'right': [['session', 'fileencoding', 'fileformat', 'filetype', 'readonly', 'percent', 'lineinfo'], ['filemod']]
  \     },
  \     'inactive': {
  \         'left': [['absolutepath']],
  \         'right': [[], [], ['filemod', 'fileencoding', 'fileformat', 'filetype', 'readonly', 'percent', 'lineinfo']]
  \     },
  \     'component_function': {
  \       'session': 'obsession#ObsessionStatus',
  \       'gitbranch': 'fugitive#head',
  \       'filemod': 'CustomFilemod'
  \     },
  \ }


function! CustomFilemod()
  return &modified ? ' {+}' : ''
endfunction


" YouCompleteMe configuration
let g:ycm_confirm_extra_conf = 0
nmap <silent> <leader>g :YcmCompleter GoTo<cr>

" FZF
command! -bang -nargs=* Rgu call fzf#vim#grep("rg -u --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, <bang>0)'
command! -bang -nargs=* Bli call fzf#vim#buffer_lines(<q-args>, <bang>0)'

" Colorscheme configuration
syntax enable
set background=light
colorscheme solarized

" Do not set special background
highlight SpecialKey ctermbg=NONE guibg=NONE

" Highlight lines
nmap <silent> <leader>hh  :highlight SpecialKey ctermbg=NONE guibg=NONE<cr>:set shiftwidth=8<cr>
nmap <silent> <leader>lw  :set nowrap<cr>

" Window resizing
nmap <F2> :vertical resize -1<cr>
nmap <F3> :resize -1<cr>
nmap <F4> :resize +1<cr>
nmap <F5> :vertical resize +1<cr>

" Help shortcut
nmap <F6> <C-]>

" Veloce helpers
" nmap <silent> <leader>vb :Make -C ~/src/veloce/buildroot O=veloce/ linux-rebuild all && cp -v ~/src/veloce/buildroot/veloce/images/* /home/shegelun/mnt/vel05/bootup && echo "Build:" $(date)<cr>
