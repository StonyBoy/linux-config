-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2024-Feb-01 10:11
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
        colors = {
          bg = "#fdf6e3",
          fg = "#839496",
          red = "#ec5f67",
          blue = "#5fb3b3",
          green = "#99c794",
        }
      }
      require('NeoComposer').setup(opts)
      require('telescope').load_extension('macros')
    end,
  },
}
