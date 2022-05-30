-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2022-May-30 21:03
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local status_ok, ls = pcall(require, 'luasnip')
if not status_ok then
  return
end

ls.config.set_config({
  history = true,
  update_events = "TextChanged,TextChangedI",
  delete_check_events = "TextChanged",
})

require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/snippets/"})

vim.api.nvim_set_keymap('n', '<Leader><Leader>s', '<cmd>source ~/.config/nvim/lua/config/snippets.lua<cr>', { noremap = true, silent = true, })
