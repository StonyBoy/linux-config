-- Neovim Language Server Configuration
-- Steen Hegelund
-- Time-Stamp: 2025-Mar-31 22:18
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :
--
-- Run clangd in a transient cgroup so a runaway index cannot exhaust host RAM and swap
local clangd = vim.fn.expand('~/.local/share/nvim/mason/bin/clangd')

return {
  cmd = {
    'systemd-run',
    '--user',
    '--scope',
    '--quiet',
    '-p',
    'MemoryHigh=8G', -- start reclaiming here
    '-p',
    'MemoryMax=12G', -- hard cap, kill only inside this scope
    '-p',
    'MemorySwapMax=0', -- keep clangd out of the swapfile
    clangd,
    '--background-index',
    '-j=8', -- async workers, default is all 32 cores
    '--pch-storage=disk', -- keep preambles on disk instead of RAM
    '--malloc-trim',
  },
  root_markers = { 'compile_commands.json', 'compile_flags.txt' },
  filetypes = { 'c', 'cpp' },
}

