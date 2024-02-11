-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2024-Feb-11 16:26
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Displays a popup with possible key bindings of the command you started typing
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
}
