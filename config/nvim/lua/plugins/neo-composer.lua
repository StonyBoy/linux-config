-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2023-Apr-29 18:05
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :


return {
  {
    "ecthelionvi/NeoComposer.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    opts = {},
    config = function(opts)
      require('NeoComposer').setup(opts)
      require('telescope').load_extension('macros')
    end,
  },
}
