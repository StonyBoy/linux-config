-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2024-Feb-11 17:00
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :


-- Automatically add closing tags for HTML and JSX

return {
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    -- event = "LazyFile",
    opts = {},
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
}
