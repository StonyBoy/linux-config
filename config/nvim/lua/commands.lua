-- Neovim create global commands
-- Steen Hegelund
-- Time-Stamp: 2022-Apr-19 22:27
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Create Global Ex functions from Lua functions

vim.api.nvim_create_user_command('TrailspaceTrim', function()
  require('functions').trailspace_trim()
end, {
  nargs = '*',
  desc = 'Trim off trailing line whitespace'
})

vim.api.nvim_create_user_command('Rg', function(opts)
  require('functions').ripgrep_args(opts.args)
end, {
  nargs = '*',
  complete = 'file',
  desc = 'Grep command line arguments',
})

vim.api.nvim_create_user_command('Rgf', function(opts)
  require('functions').ripgrep_args(vim.fn.expand('%:p:h'), opts.args)
end, {
  nargs = '*',
  complete = 'file',
  desc = 'Grep command line arguments and use current file path as start folder',
})

