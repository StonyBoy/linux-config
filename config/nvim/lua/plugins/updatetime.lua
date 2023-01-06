-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2023-Jan-06 21:45
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Add name-timestamp header in the beginning of the file

local function add_file_header()
  vim.cmd [[
  call append(0, ["Steen Hegelund", "Time-Stamp: 2023-Jan-06 21:45
  exec '0,3Commentary'
  ]]
end

vim.api.nvim_create_user_command('AddFileHeader', add_file_header, {})

return {
  {
    'StonyBoy/nvim-update-time',
    dependencies = {
      'tpope/vim-commentary', -- Comment in/out lines of text in various languages
    },
    config = function()
      require('nvim-update-time').setup({})
    end,
  },
}
