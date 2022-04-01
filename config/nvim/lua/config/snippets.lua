-- Lua Snippets
-- Steen Hegelund
-- Time-Stamp: 2022-Apr-01 19:59
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local ls = require('luasnip')

ls.config.set_config({
  history = true,
  update_events = "TextChanged,TextChangedI",
  delete_check_events = "TextChanged",
})

require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/snippets/"})
