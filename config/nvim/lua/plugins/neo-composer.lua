-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2023-Jul-19 10:32
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :


return {
  {
    "ecthelionvi/NeoComposer.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    config = function()
      local opts = {
        keymaps = {
          toggle_record = "qq",
        },
      }
      require('NeoComposer').setup(opts)
      require('telescope').load_extension('macros')
    end,
  },
}
