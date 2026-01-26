-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2026-Jan-26 14:51
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local function set_background()
  vim.opt.termguicolors = true
  vim.opt.background = 'light'
  if vim.env['USER'] == 'root' or vim.env['TERM'] == 'linux' then
    vim.opt.background = 'dark'
  end
end

return {
  {
    'lifepillar/vim-solarized8',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    enabled = true,
    config = function()
      set_background()
      vim.cmd([[colorscheme solarized8_high]])
      --
      -- Define highlight groups for focused and unfocused gutters
      vim.cmd([[
        highlight FocusedGutter guifg=#002b36 guibg=#eee8d5
        highlight UnfocusedGutter guifg=#586e75 guibg=#fdf6e3
      ]])

      -- Add autocommands to handle the window events
      vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
        pattern = "*",
        callback = function()
          vim.opt_local.winhighlight = "LineNr:FocusedGutter,SignColumn:FocusedGutter"
        end,
      })

      vim.api.nvim_create_autocmd("WinLeave", {
        pattern = "*",
        callback = function()
          vim.opt_local.winhighlight = "LineNr:UnfocusedGutter,SignColumn:UnfocusedGutter"
        end,
      })
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    enabled = false,
    config = function()
      set_background()
      vim.cmd([[colorscheme tokyonight-day]])
    end,
  },
  {
    'rebelot/kanagawa.nvim', -- Colorscheme inspired by the colors of the famous painting by Katsushika Hokusai.
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    enabled = false,
    config = function()
      set_background()
      vim.cmd([[colorscheme kanagawa]])
    end,
  },
  {
    "shaunsingh/solarized.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    enabled = false,
    config = function()
      set_background()
      vim.cmd([[colorscheme solarized]])
    end,
  },
}
