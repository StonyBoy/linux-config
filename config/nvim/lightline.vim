" Steen Hegelund
" Time-Stamp: 2022-Jan-23 00:59
" Lightline Configuration

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
