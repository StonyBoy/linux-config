-- Function Library
-- Steen Hegelund
-- Time-Stamp: 2022-Jan-24 20:44
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local Module = {}

Module.trailspace_trim = function()
  -- Save cursor position to later restore
  local curpos = vim.api.nvim_win_get_cursor(0)

  -- Search and replace trailing whitespace
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.api.nvim_win_set_cursor(0, curpos)
end

Module.selected_word_ripgrep = function()
  local rgcmd = string.format('rg --column --line-number --no-heading --color=always --smart-case -- %s',
     string.format('"\\b(%s)\\b"', vim.call('expand', '<cword>'))
  )
  local cmd = [[call fzf#vim#grep('%s', 1, fzf#vim#with_preview())]]
  vim.cmd(cmd:format(rgcmd))
end

Module.args_ripgrep = function(pattern, path, option)
  local rgcmd = string.format('rg --column --line-number --no-heading --color=always --smart-case %s -- %s',
    option and option or '',
    path and string.format("'%s' %s", pattern, path) or string.format("'%s'", pattern)
  )
  local cmd = [[call fzf#vim#grep("%s", 1, fzf#vim#with_preview())]]
  vim.cmd(cmd:format(rgcmd))
end

Module.get_visual_selection = function()
  local _, line_start, col_start, _ = unpack(vim.fn.getpos("'<"))
  local _, line_end, col_end, _ = unpack(vim.fn.getpos("'>"))
  local lines = vim.fn.getline(line_start, line_end)
  if #lines == 0 then
    return ''
  else
    lines[#lines] = string.sub(lines[#lines], 0, col_end)
    lines[1] = string.sub(lines[1], col_start)
    return table.concat(lines, '\n')
  end
end

Module.visual_selection_ripgrep = function()
  local rgcmd = string.format('rg --column --line-number --no-heading --color=always --smart-case %s -- %s',
    option and option or '',
    string.format("'%s'", Module.get_visual_selection())
  )
  local cmd = [[call fzf#vim#grep("%s", 1, fzf#vim#with_preview())]]
  vim.cmd(cmd:format(rgcmd))
end

return Module
