" Steen Hegelund
" Time-Stamp: 2022-Feb-06 18:12
" Lightline Configuration

set laststatus=2
set noshowmode " Do not show 2nd line edit mode information

let g:lightline = {
  \ 'colorscheme': 'selenized_light',
  \     'active': {
  \         'left': [['mode'], ['gitbranch', 'll_abbrevpath']],
  \         'right': [['ll_fileformat', 'll_fileposition', 'percent'], ['ll_filestate', 'll_editcfg']]
  \     },
  \     'inactive': {
  \         'left': [[], [], ['absolutepath']],
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

function! LlFilePosition()
  return printf('%03d:%02d', line('.'), col('.'))
endfunction

function! LlFileState()
  return &modified ? '[+]' : '   '
endfunction

function! LlFileFormat()
  let sep = ' | '
  let rostr = &readonly ? 'ro' : 'wr'
  let result = rostr . sep . &fileencoding . sep . &fileformat . sep . &filetype
  return winwidth(0) > 100 ? result : &filetype
endfunction


function! LlEditConfig()
  let sep = ' | '
  let tabstr = &expandtab ? 'spc' : 'tab'
  let result = tabstr . sep . 'ts:' . &tabstop . sep . 'sw:' . &shiftwidth . sep . 'sts:' . &softtabstop . sep . 'tw:' . &textwidth
  return winwidth(0) > 100 ? result : tabstr
endfunction

function! LlAbbrevPath()
    let fpath = expand('%:f')
    let margin = winwidth(0) - strchars(fpath) - 90
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
