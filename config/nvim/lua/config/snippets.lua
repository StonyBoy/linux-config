-- Lua Snippets
-- Steen Hegelund
-- Time-Stamp: 2022-Mar-30 22:58
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local ls = require('luasnip')
local s = ls.s
local fmt = require('luasnip.extras.fmt').fmt
local i = ls.insert_node
local rep = require('luasnip.extras').rep

print('initialize snippets')

ls.config.set_config({
  history = true,
  update_events = "TextChanged,TextChangedI",
  delete_check_events = "TextChanged",
})

ls.snippets = {
  lua = {
    s('req', {
      fmt("local {} = require('{}')", {i(1, "functions"), rep(1)})
    }),
  },
}
