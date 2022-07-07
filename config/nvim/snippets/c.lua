-- Lua Snippets for c filetype
-- Steen Hegelund
-- Time-Stamp: 2022-Jul-07 20:29
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local ls = require('luasnip')
local snp = ls.s
local ins = ls.insert_node
local txt = ls.text_node
local fun = ls.function_node
local cho = ls.choice_node
local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep

return {
  -- Use a function to execute any shell command and print its text.
  snp("pri", {
    txt('pr_info('),
    cho(1, {
      txt('"%s:%d\\n", __func__, __LINE__'),
      txt('"\\n"')
    }),
    ins(0),
    txt(');')
  }),
}

