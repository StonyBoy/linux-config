" Steen Hegelund
" Time-Stamp: 2022-Feb-09 23:16
" Lightline Configuration
" vim: set ts=4 sw=4 sts=4 tw=120 et cc=120 ft=vim :

set laststatus=2
set noshowmode " Do not show 2nd line edit mode information

let g:lightline = {
  \ 'colorscheme': 'selenized_light',
  \     'active': {
  \         'left': [['mode'], ['gitbranch', 'll_abbrevpath']],
  \         'right': [['ll_fileformat', 'll_fileposition', 'percent'], ['ll_filestate', 'll_editcfg']]
  \     },
  \     'inactive': {
  \         'left': [[], [], ['absolutepath', 'll_filestate']],
  \         'right': []
  \     },
  \     'component_function': {
  \       'gitbranch': 'fugitive#head',
  \       'll_filestate': 'LlFileState',
  \       'll_editcfg': 'LlEditConfig',
  \       'll_abbrevpath': 'LlAbbrevPath',
  \       'll_fileformat': 'LlFileFormat',
  \       'll_fileposition': 'LlFilePosition'
  \     },
  \ }

" Show linenumber and virtual column number (when eg tabs are expanded to spaces)
function! LlFilePosition()
    return printf('%03d:%02d', line('.'), virtcol('.'))
endfunction

" Show if the file has been modified
function! LlFileState()
    return &modified ? '[+]' : '   '
endfunction

" Show file format information: encoding, format, type
function! LlFileFormat()
    let sep = ' | '
    let rostr = &readonly ? 'ro' : 'wr'
    let result = rostr . sep . &fileencoding . sep . &fileformat . sep . &filetype
    return winwidth(0) > 100 ? result : &filetype
endfunction

" Show editor configuration: tabs/spaces, tabstop, softtabstop, shiftwidth and textwidth (wrapping)
function! LlEditConfig()
    let sep = ' | '
    let tabstr = &expandtab ? 'spc' : 'tab'
    let result = tabstr . sep . 'ts:' . &tabstop . sep . 'sw:' . &shiftwidth . sep . 'sts:' . &softtabstop . sep . 'tw:' . &textwidth
    return winwidth(0) > 140 ? result : tabstr
endfunction

" Show a full path if there is room. For fugitive file only show 'git:filename'
function! LlAbbrevPath()
    let fpath = expand('%:p:~') " Full path optionally using ~ for home
    let margin = winwidth(0) - strchars(fpath) - 100
        let elems = split(fpath, ':')
    if len(elems) > 1
        let ret = "git:" . expand("%:t")
    elseif margin > 10
        let ret = fpath
    else
        let ret = expand("%:t")
    end
    return ret
endfunction
