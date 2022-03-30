-- nvim-cmp configuration
-- Steen Hegelund
-- Time-Stamp: 2022-Mar-30 23:37
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

print('initialize nvim-cmp')

local cmp = require('cmp')

cmp.setup {
  snippet = {
    expand = function(args)
      local luasnip = require('luasnip')
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      local luasnip = require('luasnip')
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      local luasnip = require('luasnip')
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = "buffer" },
    { name = "nvim_lsp" },
    { name = "treesitter" },
    { name = "nvim_lua" },
    { name = "path" },
    { name = "luasnip" },
  },
}
