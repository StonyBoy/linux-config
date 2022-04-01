-- Lua Snippets for Lua filetype
-- Steen Hegelund
-- Time-Stamp: 2022-Apr-01 20:02
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local ls = require('luasnip')
local snp = ls.s
local ins = ls.insert_node
local txt = ls.text_node
local fun = ls.function_node
local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep

print('initialize "lua" snippets')

return {
  snp('req',
  fmt("local {} = require('{}')", { ins(1, "functions"), rep(1) })
  ),
  snp('mod', {
    txt('local '),
    ins(1, 'Module'),
    txt({' = {}', '', 'return '}),
    rep(1),
    ins(0),
  }),
  -- snp('test',
  --   fmt("local [] = {}\n\nreturn []", { ins(1, "Module"), rep(1) }, { delimiters = "[]" })
  -- ),
}
