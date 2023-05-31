-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2023-May-31 21:01
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- A vim-vinegar like file explorer that lets you edit your filesystem like a normal Neovim buffer.
return {
  {
    'stevearc/oil.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    },
    config = function()
      local oil = require("oil")

      oil.setup()
      oil.set_columns({"icon", "size", "permissions", "mtime"})

    end,
  }
}
