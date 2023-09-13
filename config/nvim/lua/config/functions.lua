-- Function Library
-- Steen Hegelund
-- Time-Stamp: 2023-Sep-13 10:41
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local Module = {}

Module.locate = function(table, value)
    for i = 1, #table do
        if table[i] == value then return true end
    end
    return false
end

Module.get_modeline = function()
  local modeline = string.format('vim: set ts=%d sw=%d sts=%d tw=%d cc=%s %s ft=%s',
  vim.opt.tabstop:get(),
  vim.opt.shiftwidth:get(),
  vim.opt.softtabstop:get(),
  vim.opt.textwidth:get(),
  table.concat(vim.opt.colorcolumn:get(), ','),
  vim.opt.expandtab:get() and 'et' or 'noet',
  vim.opt.filetype:get())
  if Module.locate({ 'c', 'h', 'cpp', 'hpp' }, vim.bo.filetype) then
    modeline = modeline .. string.format(' cino=%s',
    vim.fn.escape(table.concat(vim.opt.cinoptions:get(), ','), ':'))
  end
  modeline = modeline .. ' :'
  return modeline
end

Module.get_modeline_struct = function()
  return { string.format(vim.opt.commentstring:get(), modeline) }
end

Module.toggle_c_style = function()
  if vim.bo.expandtab then
    vim.bo.cinoptions   = '(0,w1,Ws,t0,:0,l1' -- C indent, Kernel style
    vim.bo.textwidth    = 80                  -- Set the line width default value
    vim.opt.colorcolumn = '80,100'            -- Set the colour markers
    vim.bo.shiftwidth   = 8                   -- Default 8 spaces
    vim.bo.tabstop      = 8                   -- 8 spaces per tab
    vim.bo.softtabstop  = 8                   -- 8 spaces per tab when unindenting
    vim.bo.expandtab    = false               -- Use tabs
  else
    vim.bo.cinoptions   = '(0,w1,Ws,t0,:s,l1' -- C indent, Userspace style
    vim.bo.textwidth    = 120                 -- Set the line width default value
    vim.opt.colorcolumn = '80,120'            -- Set the colour markers
    vim.bo.shiftwidth   = 4                   -- Default 4 spaces
    vim.bo.tabstop      = 4                   -- 4 spaces per tab
    vim.bo.softtabstop  = 4                   -- 4 spaces per tab when unindenting
    vim.bo.expandtab    = true                -- Use spaces
  end
  vim.bo.cindent        = true                -- Indent smart for C
end

Module.trailspace_trim = function()
  -- Save cursor position to later restore
  local curpos = vim.api.nvim_win_get_cursor(0)

  -- Search and replace trailing whitespace
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.api.nvim_win_set_cursor(0, curpos)
end

Module.add_mode_line = function()
  local cmt = vim.opt.commentstring:get()
  if string.len(cmt) > 0 then
    vim.api.nvim_buf_set_lines(0, 0, 0, false, {string.format(vim.opt.commentstring:get(), Module.get_modeline())})
  else
    vim.api.nvim_buf_set_lines(0, 0, 0, false, {string.format("// %s ", Module.get_modeline())})
  end
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
