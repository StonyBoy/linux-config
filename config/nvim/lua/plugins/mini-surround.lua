-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2024-Feb-11 20:16
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

return {
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    config = function()
      local opts = {
        mappings = {
          add = 'gsa', -- Add surrounding in Normal and Visual modes
          delete = 'gsd', -- Delete surrounding
          find = 'gsf', -- Find surrounding (to the right)
          find_left = 'gsF', -- Find surrounding (to the left)
          highlight = 'gsh', -- Highlight surrounding
          replace = 'gsr', -- Replace surrounding
          update_n_lines = 'gsn', -- Update `n_lines`

          suffix_last = 'l', -- Suffix to search with "prev" method
          suffix_next = 'n', -- Suffix to search with "next" method
        },
      }
      require('mini.surround').setup(opts)
    end,
  }
}
