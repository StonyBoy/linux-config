-- Neovim create global commands
-- Steen Hegelund
-- Time-Stamp: 2022-Sep-19 20:18
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Create Global Ex functions from Lua functions

vim.api.nvim_create_user_command('TrailspaceTrim', function()
  require('config.functions').trailspace_trim()
end, {
  nargs = '*',
  desc = 'Trim off trailing line whitespace'
})

vim.api.nvim_create_user_command('Rg', function(args)
  args.path = vim.fn.getcwd()
  require('config.functions').ripgrep_args(args)
end, {
  nargs = '*',
  complete = 'file',
  desc = 'RipGrep the working directory',
})

vim.api.nvim_create_user_command('Rgd', function(args)
  require('config.functions').ripgrep_args(args)
end, {
  nargs = '*',
  complete = 'file',
  desc = 'RipGrep the provided directory',
})

vim.api.nvim_create_user_command('Rgw', function(args)
  args.path = vim.fn.expand('%:p:h')
  require('config.functions').ripgrep_args(args)
end, {
  nargs = '*',
  complete = 'file',
  desc = 'RipGrep using the current file path as start folder',
})

vim.api.nvim_create_user_command('Rgf', function(args)
  args.path = vim.fn.expand('%')
  require('config.functions').ripgrep_args(args)
end, {
  nargs = '*',
  complete = 'file',
  desc = 'RipGrep the current file',
})

vim.api.nvim_create_user_command('Rp', function(opts)
  require('config.functions').reload_module(opts.args)
end, {
  nargs = '*',
  complete = 'file',
  desc = 'Reload a lua module',
})
