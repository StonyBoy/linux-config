" Steen Hegelund
" Time-Stamp: 2021-Feb-15 22:41
" From https://alldrops.info/posts/vim-drops/2019-02-13_custom-autoclose-mappings/

"-- AUTOCLOSE --  
"autoclose and position cursor to write text inside  
inoremap ' ''<left>  
inoremap ` ``<left>  
inoremap " ""<left>  
inoremap ( ()<left>  
inoremap [ []<left>  
inoremap { {}<left>  
"autoclose with ; and position cursor to write text inside  
inoremap '; '';<left><left>  
inoremap `; ``;<left><left>  
inoremap "; "";<left><left>  
inoremap (; ();<left><left>  
inoremap [; [];<left><left>  
inoremap {; {};<left><left>  
"autoclose with , and position cursor to write text inside  
inoremap ', '',<left><left>  
inoremap `, ``,<left><left>  
inoremap ", "",<left><left>  
inoremap (, (),<left><left>  
inoremap [, [],<left><left>  
inoremap {, {},<left><left>  
"autoclose and position cursor after  
inoremap '<tab> ''  
inoremap `<tab> ``  
inoremap "<tab> ""  
inoremap (<tab> ()  
inoremap [<tab> []  
inoremap {<tab> {}  
"autoclose with ; and position cursor after  
inoremap ';<tab> '';  
inoremap `;<tab> ``;  
inoremap ";<tab> "";  
inoremap (;<tab> ();  
inoremap [;<tab> [];  
inoremap {;<tab> {};  
"autoclose with , and position cursor after  
inoremap ',<tab> '',  
inoremap `,<tab> ``,  
inoremap ",<tab> "",  
inoremap (,<tab> (),  
inoremap [,<tab> [],  
inoremap {,<tab> {},  
"autoclose 2 lines below and position cursor in the middle   
inoremap '<CR> '<CR>'<ESC>O  
inoremap `<CR> `<CR>`<ESC>O  
inoremap "<CR> "<CR>"<ESC>O  
inoremap (<CR> (<CR>)<ESC>O  
inoremap [<CR> [<CR>]<ESC>O  
inoremap {<CR> {<CR>}<ESC>O  
"autoclose 2 lines below adding ; and position cursor in the middle   
inoremap ';<CR> '<CR>';<ESC>O  
inoremap `;<CR> `<CR>`;<ESC>O  
inoremap ";<CR> "<CR>";<ESC>O  
inoremap (;<CR> (<CR>);<ESC>O  
inoremap [;<CR> [<CR>];<ESC>O  
inoremap {;<CR> {<CR>};<ESC>O  
"autoclose 2 lines below adding , and position cursor in the middle   
inoremap ',<CR> '<CR>',<ESC>O  
inoremap `,<CR> `<CR>`,<ESC>O  
inoremap ",<CR> "<CR>",<ESC>O  
inoremap (,<CR> (<CR>),<ESC>O  
inoremap [,<CR> [<CR>],<ESC>O  
inoremap {,<CR> {<CR>},<ESC>O
