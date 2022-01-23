-- Function Library
-- Steen Hegelund
-- Time-Stamp: 2022-Jan-23 23:06
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local Module = {}

Module.trailspace_trim = function()
  -- Save cursor position to later restore
  local curpos = vim.api.nvim_win_get_cursor(0)

  -- Search and replace trailing whitespace
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.api.nvim_win_set_cursor(0, curpos)
end

Module.args_ripgrep = function(pattern, path, option)
  local rgcmd = string.format('rg --column --line-number --no-heading --color=always --smart-case %s -- %s',
    option and option or '',
    path and string.format("'%s' %s", pattern, path) or string.format("'%s'", pattern)
  )
  local cmd = [[call fzf#vim#grep("%s", 1, fzf#vim#with_preview())]]
  vim.cmd(cmd:format(rgcmd))
end

return Module
