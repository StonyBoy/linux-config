-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2022-May-30 21:03
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

return {
  {
    'L3MON4D3/LuaSnip',                             -- Snippet engine
    config = function()
      require('luasnip').config.set_config({
        history = true,
        update_events = "TextChanged,TextChangedI",
        delete_check_events = "TextChanged",
      })

      require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/snippets/"})

      vim.api.nvim_set_keymap('n', '<Leader><Leader>s', '<cmd>source ~/.config/nvim/lua/config/snippets.lua<cr>', { noremap = true, silent = true, })
    end,
  }
}
