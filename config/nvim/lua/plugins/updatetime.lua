-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2023-Jan-16 21:11
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Add name-timestamp header in the beginning of the file

local add_file_header = function()
  local template = {'Steen Hegelund', 'Time-Stamp: #', require('config.functions').get_modeline()}
  local lines = {}

  for _, line in ipairs(template) do
    -- line = ' ' .. line .. ' '
    line = string.format(vim.opt.commentstring:get(), line)
    table.insert(lines, line)
  end
  table.insert(lines, '')
  vim.api.nvim_buf_set_text(0, 0, 0, 0, 0, lines)
end

vim.api.nvim_create_user_command('AddFileHeader', add_file_header, {})

return {
  {
    'StonyBoy/nvim-update-time',
    config = function()
      require('nvim-update-time').setup({ last = 5 })
    end,
  },
}
