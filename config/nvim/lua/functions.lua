-- Function Library
-- Steen Hegelund
-- Time-Stamp: 2022-Apr-05 20:53
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

Module.ripgrep_args = function(...)
  local opts = {}
  local args = { n = select('#', ...), ... }
  if args.n > 0 then
    local idx = 1
    while idx <= args.n do
      local dir = vim.fn.expand(args[idx])
      if vim.fn.isdirectory(dir) > 0 then
        opts['cwd'] = dir
      else
        opts['search'] = args[idx]
      end
      -- option passing: additional_args = function() return {'-t', 'c'} end
      idx = idx + 1
    end
  end
  require("telescope.builtin").grep_string(opts)
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
end

Module.ls_load = function()
  vim.cmd('source ~/.config/nvim/lua/config/snippets.lua')
end

return Module
