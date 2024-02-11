-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2024-Feb-11 17:00
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

return {
  "echasnovski/mini.indentscope",
  version = false, -- wait till new 0.7.0 release to put it back on semver
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  -- event = "LazyFile",
  opts = {
    -- symbol = "▏",
    symbol = "│",
    options = { try_as_border = true },
  },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
        "bufexplorer",
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })
  end,
}
