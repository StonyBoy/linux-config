-- Lua Snippets for all filetypes
-- Steen Hegelund
-- Time-Stamp: 2022-Jul-07 20:29
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local ls = require('luasnip')
local snp = ls.s
local ins = ls.insert_node
local txt = ls.text_node
local fun = ls.function_node
local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep


-- args is a table, where 1 is the text in Placeholder 1, 2 the text in
-- placeholder 2,...
local function copy(args)
  return args[1]
end

local date = function()
  return { os.date "%Y-%m-%d" }
end

-- Make sure to not pass an invalid command, as io.popen() may write over nvim-text.
local function bash(_, _, command)
  local file = io.popen(command, "r")
  local res = {}
  for line in file:lines() do
    table.insert(res, line)
  end
  return res
end

return {
  -- Use a function to execute any shell command and print its text.
  snp("pwd", { fun(bash, {}, { user_args = {"pwd"}}), }),
  snp("lsl", { fun(bash, {}, { user_args = {"ls -la"}}), }),
  snp("fn", {
    -- Simple static text.
    txt("-- Parameters: "),
    -- function, first parameter is the function, second the Placeholders
    -- whose text it gets as input.
    fun(copy, 2),
    txt({ "", "function " }),
    -- Placeholder/Insert.
    ins(1),
    txt("("),
    -- Placeholder with initial text.
    ins(2, "int foo"),
    -- Linebreak
    txt({ ") {", "\t" }),
    -- Last Placeholder, exit Point of the snippet. EVERY 'outer' SNIPPET NEEDS Placeholder 0.
    ins(0),
    txt({ "", "}" }),
  }),
}
