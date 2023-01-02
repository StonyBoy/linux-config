-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2022-May-31 09:11
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", {
  ui = { border = "single" }})
