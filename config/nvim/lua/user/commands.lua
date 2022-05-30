-- Neovim create global commands
-- Steen Hegelund
-- Time-Stamp: 2022-May-30 20:08
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Create Global Ex functions from Lua functions

vim.api.nvim_create_user_command('TrailspaceTrim', function()
  require('user.functions').trailspace_trim()
end, {
  nargs = '*',
  desc = 'Trim off trailing line whitespace'
})

vim.api.nvim_create_user_command('Rg', function(opts)
  require('user.functions').ripgrep_fargs(opts.fargs)
end, {
  nargs = '*',
  complete = 'file',
  desc = 'Grep command line arguments',
})

vim.api.nvim_create_user_command('Rgf', function(opts)
  require('user.functions').ripgrep_args(vim.fn.expand('%:p:h'), opts.args)
end, {
  nargs = '*',
  complete = 'file',
  desc = 'Grep command line arguments and use current file path as start folder',
})

vim.api.nvim_create_user_command('Rp', function(opts)
  require('user.functions').reload_module(opts.args)
end, {
  nargs = '*',
  complete = 'file',
  desc = 'Reload a lua module',
})