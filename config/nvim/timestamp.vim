" Steen Hegelund
" Time-Stamp: 2022-Jan-23 00:59
" Timestamp configuration

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
