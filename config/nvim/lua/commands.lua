-- Load Global Ex Functions

-- Create Global Ex functions from Lua functions
vim.cmd([[
command! TrailspaceTrim lua require('functions').trailspace_trim()
command! -nargs=+ -complete=file RG lua require('functions').args_ripgrep(<f-args>)
]])
