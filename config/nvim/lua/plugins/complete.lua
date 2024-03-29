-- completion configuration
-- Steen Hegelund
-- Time-Stamp: 2022-May-30 21:37
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local sel_next = function(fallback)
  local luasnip = require('luasnip')
  local cmp = require('cmp')
  if cmp.visible() then
    cmp.select_next_item()
  elseif luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    fallback()
  end
end

local sel_prev = function(fallback)
  local luasnip = require('luasnip')
  local cmp = require('cmp')
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end

local sel_choice = function()
  local luasnip = require('luasnip')
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end

return {
  {
    "hrsh7th/nvim-cmp",
    -- load cmp on InsertEnter
    event = "InsertEnter",
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'saadparwaiz1/cmp_luasnip'
    },
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<C-l>'] = sel_choice,
          ['<C-n>'] = sel_next,
          ['<Tab>'] = sel_next,
          ['<Down>'] = sel_next,
          ['<S-Tab>'] = sel_prev,
          ['<C-p>'] = sel_prev,
          ['<Up>'] = sel_prev,
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<C-y>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
        },
        sources = {
          { name = "buffer" },
          { name = "nvim_lsp" },
          { name = "treesitter" },
          { name = "nvim_lua" },
          { name = "path" },
          { name = "luasnip" },
        },
      })
    end,
  },
}
