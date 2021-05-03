" VIM settings
" Steen Hegelund
" Time-Stamp: 2021-May-03 09:09
" vim: set ts=4 sw=4 sts=4 tw=120 et cc=120 :

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
set hidden          " Allow edit buffers to be hidden
set guioptions=     " Remove menus
set noswapfile      " Do not create swapfiles

" Enable true color
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

if has("multi_byte")
    set fillchars=stl:\ ,stlnc:\ ,vert:┆,fold:―,diff:―    " Displaying symbols to separate windows
    set lcs=tab:\»\ ,trail:•,extends:>,precedes:<,nbsp:¤" " Show white spaces
    let &sbr = nr2char(8618).' '
    set list        " Turn on the display of whitespace
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text formatting defaults
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set textwidth=120   " Set the line width default value
set colorcolumn=120 " Set the colour marker
set shiftwidth=4    " Default 4 spaces
set tabstop=4       " 4 spaces per tab
set softtabstop=4   " 4 spaces per tab when unindenting
set expandtab       " Use spaces
set smarttab        " Indent smart
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filetype handling
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin on
augroup filetype_settings
    autocmd!
    autocmd BufNewFile,BufRead *.in setf make
    autocmd BufNewFile,BufRead *.c,*.h,*.S,*.dts,*.dtsi setlocal tabstop=8 shiftwidth=8 softtabstop=8 textwidth=80 noexpandtab colorcolumn=80 cindent
    autocmd BufNewFile,BufRead *.cxx,*.hxx              setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120 expandtab colorcolumn=120 cindent
    autocmd FileType c,h autocmd BufWritePre * :call TrimWhitespace()
    autocmd FileType bash                               setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120 expandtab colorcolumn=120 cindent
    autocmd FileType gitcommit,gitsendemail,mail        setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=75 expandtab colorcolumn=75
    autocmd FileType md,markdown,asciidoc,text,gitcommit,gitsendemail setlocal spell spelllang=en_us
    autocmd FileType c,cpp,js                           nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
    autocmd FileType c,cpp,js                           vnoremap <buffer><Leader>cf :ClangFormat<CR>
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual Cues
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set noerrorbells    " Turn off beep on error
set hlsearch        " highlight search - show the current search pattern
set incsearch       " Do the search while typing in a search pattern
set ignorecase      " Ignore cases while searching
set showmatch       " showmatch:   Show the matching bracket for the last ')'?

" Do not highlight special key background
highlight SpecialKey ctermbg=NONE guibg=NONE

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text Formatting/Layout
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoindent      " Auto indent, nice for coding
set smartindent     " Do smart autoindenting when starting a new line.
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
set wildignorecase  " Ignore case when tab-expanding filenames

" Empty the search register
let @/ = "__=#?__"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Using tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <leader>t<up> :tabr<cr>
nnoremap <silent> <leader>t<down> :tabl<cr>
nnoremap <silent> <leader>t<left> :tabp<cr>
nnoremap <silent> <leader>t<right> :tabn<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remapping XTERM specialities
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <ESC>[1;5D  <C-left>
nnoremap <silent> <ESC>[1;5C  <C-right>
cnoremap <silent> <ESC>[1;5D  <C-left>
cnoremap <silent> <ESC>[1;5C  <C-right>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Reload VIMRC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <leader>ev   :vsplit $MYVIMRC<cr>
nnoremap <silent> <leader>sv   :source $MYVIMRC<cr>:echom ".vimrc reloaded"<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Setup Spell Checking - also in autocommands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set spellfile=~/.vim/spell/en.utf-8.add

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Useful VIM shortcuts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Getting out quickly
nnoremap ZA :qa!<CR>

" Add signed-off-by
nnoremap <leader>is :r ~/work/patches/signedoffby.txt<CR>

" Use ripgrep on selected word
nnoremap ## :Rg \b<C-R><C-W>\b<CR>

" Terminal mode
tnoremap <Esc> <C-\><C-n>
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'

" Search visual selection
xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

function! s:VSetSearch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

" Open file in the same folder as the current file using %%/
cabbr <expr> %% expand('%:p:h')

" Window resizing
if has('nvim')
    nnoremap <C-M-S-Left>  :vertical resize -1<cr>
    nnoremap <C-M-S-Right> :vertical resize +1<cr>
    nnoremap <C-M-S-Down>  :resize -1<cr>
    nnoremap <C-M-S-Up>    :resize +1<cr>
else
    nnoremap <F2>        :vertical resize -1<cr>
    nnoremap <F5>        :vertical resize +1<cr>
    nnoremap <F3>        :resize -1<cr>
    nnoremap <F4>        :resize +1<cr>
endif

" Follow link shortcut
nnoremap <F6> g<c-]>
vnoremap <F6> g<c-]>

" Toggle BufExplorer
nnoremap <F8> :ToggleBufExplorer<cr>

" Reload the current buffer
nnoremap <F9> :e!<cr>

" Clear the last search pattern (removes highlight)
nnoremap <F10> :let @/ = ""<cr>

" Clear old part of logfile
nnoremap <F11> G?Starting kernelkdgg

" Build helpers
nnoremap <silent> <leader>fb :Make -C ~/work/fireant/buildroot O=../../build/buildroot-ls1046-fireant/ linux-rebuild all<cr>

" Edit helpers
nnoremap <silent> <leader>it Opr_info("%s:%d\n", __func__, __LINE__);<esc>
nnoremap <silent> <leader>id OCFLAGS_*.o := -DDEBUG<CR><esc>
nnoremap <silent> <leader>fm :setlocal foldmethod=syntax<CR>
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Super Macros
" :let @n = @n + 10/phy3ldw"nP/@ldw"nPj0/<ldw"nPjj:let @/ = ""
" /reg =f<ldw:let @o = @" - @n"oP
" 0/port4ldw"nP/port5ldw"nPa /reg =f<ldw"nP/phys =4wdt "oPwdw"nP/sfp =/eth3ldw"nPjj:let @n = @n + 1:let @o = @o + 1
" 0/sfp_eth7ldw"nP/sfp-eth7ldw"nPa /&i2c4ldw"oP2j:let @n = @n + 1:let @o = @o + 1

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d sts=%d tw=%d %set cc=%d ft=%s :",
        \ &tabstop, &shiftwidth, &softtabstop, &textwidth, &expandtab ? '' : 'no', &colorcolumn, &filetype)
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" Add name-timestamp header in the beginning of the file
function! AddFileHeader()
  call append(0, ["Steen Hegelund", "Time-Stamp: #", ""])
  exec '0,3Commentary'
endfunction
nnoremap <silent> <Leader>fh :call AddFileHeader()<CR>

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
nnoremap <silent> <leader>wy  :let g:yanked_buffer=bufnr('%')<cr>
nnoremap <silent> <leader>wd  :let g:yanked_buffer=bufnr('%')<cr>:q<cr>
nnoremap <silent> <leader>wp :call PasteWindow('edit')<cr>
nnoremap <silent> <leader>ws :call PasteWindow('split')<cr>
nnoremap <silent> <leader>wv :call PasteWindow('vsplit')<cr>
nnoremap <silent> <leader>wt :call PasteWindow('tabnew')<cr>
nnoremap <silent> <leader>wP :top split
nnoremap <silent> <leader>wV :set nosplitright \| call PasteWindow('vsplit') \| set splitright<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Local Project Configuration: Read .vimlocal
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
silent! source .vimlocal

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colorscheme configuration
syntax on
if $USER == "root"
    set background=dark
elseif $TERM == "alacritty" || $TERM == "xterm-256color" || $TERM == "tmux-256color" || $TERM == "linux"
    set background=light
endif
colorscheme solarized8

" Lightline
set laststatus=2
set noshowmode
let g:lightline = {
  \ 'colorscheme': 'solarized',
  \     'active': {
  \         'left': [['mode'], ['paste', 'gitbranch', 'fpath']],
  \         'right': [['session', 'fileencoding', 'fileformat', 'filetype', 'readonly', 'percent', 'lineinfo'], ['filemod', 'editcfg']]
  \     },
  \     'inactive': {
  \         'left': [['fpath']],
  \         'right': [[], [], ['filemod', 'fileencoding', 'fileformat', 'filetype', 'readonly', 'percent', 'lineinfo']]
  \     },
  \     'component_function': {
  \       'session': 'obsession#ObsessionStatus',
  \       'gitbranch': 'fugitive#head',
  \       'filemod': 'CustomFilemod',
  \       'editcfg': 'CustomEditConfig',
  \       'fpath': 'CustomFilepath'
  \     },
  \ }


function! CustomFilemod()
  return &modified ? ' {+}' : ''
endfunction


function! CustomEditConfig()
  let expandtabstr = &expandtab ? ' spc' : ' tab'
  return 'ts:' . &tabstop . ' sw:' . &shiftwidth . ' sts:' . &softtabstop . ' tw:' . &textwidth . expandtabstr
endfunction

function! CustomFilepath()
    let elems = split(expand('%:f'), ':')
    if len(elems) > 1
        let ret = "git:" . expand("%:t")
    else
        let ret = expand("%:t")
    end
    return ret
endfunction

" Show full path and optionally referring to $HOME
nnoremap #% :echo expand('%:p:~')<CR>

" FZF
command! -bang -nargs=* Rgu call fzf#vim#grep("rg -u --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, <bang>0)'
command! -bang -nargs=* Bli call fzf#vim#buffer_lines(<q-args>, <bang>0)'

" ALE linter
" Do not lint when opening a file
let g:ale_lint_on_enter = 0
" Lint on save
let g:ale_lint_on_save = 1
" Less obtrusive lint highligting
let g:ale_sign_error = '●'
let g:ale_sign_warning = '.'

" Provide EasyAlign shortcuts

" Start interactive EasyAlign in visual mode (e.g. vipga)
xnoremap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nnoremap ga <Plug>(EasyAlign)

" Remove trailing whitespace and restore search history and position in file
function! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
command! TrimWhitespace call TrimWhitespace()

source ~/.vim/config/autoclose.vim
source ~/.vim/config/emacsstyle.vim
