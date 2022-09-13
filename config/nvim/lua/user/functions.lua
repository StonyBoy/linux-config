-- Function Library
-- Steen Hegelund
-- Time-Stamp: 2022-Sep-13 21:52
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local Module = {}

Module.trailspace_trim = function()
  -- Save cursor position to later restore
  local curpos = vim.api.nvim_win_get_cursor(0)

  -- Search and replace trailing whitespace
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.api.nvim_win_set_cursor(0, curpos)
end

Module.get_visual_selection = function()
  local first = vim.fn.getpos("v") -- bufno, lnum, col, off
  local last = vim.fn.getpos(".")
  local lines = vim.fn.getline(first[2], last[2])
  if #lines == 0 then
    return ''
  else
    lines[#lines] = string.sub(lines[#lines], 0, last[3])
    lines[1] = string.sub(lines[1], first[3])
    return table.concat(lines, '\n')
  end
end

Module.ripgrep_args = function(args)
  local cmd = 'rg --vimgrep ' .. args.args
  if args.path then
    cmd = cmd .. ' ' .. args.path
  end
  print('Running:', cmd)
  local lines = {}
  vim.fn.jobstart(cmd, {
    on_stdout = function(_, data, _)
      for _, line in ipairs(data) do
        if #line ~= 0 then
          table.insert(lines, line)
        end
      end
    end,
    on_exit = function()
      vim.fn.setqflist({}, 'r', {lines = lines, title = args.pattern})
    end,
  })
end

-- Debugging lua implementation
Module.P = function(obj)
  print(vim.inspect(obj))
  return obj
end

-- Function for reloading the Neovim configuration
Module.reload_neovim = function()
  -- Ensure the plugin listing gets reloaded
  package.loaded['plugins'] = nil
  vim.cmd('source $MYVIMRC')
end

Module.reload_module = function(name)
  package.loaded[name] = nil
  require(name)
  print('Reloaded', name)
end

return Module
