-- Neovim Language Server Configuration
-- Steen Hegelund
-- Time-Stamp: 2025-Nov-01 14:55
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :
--

-- Locate the LSP binaru in the folder: ~/.local/share/nvim/mason/bin
return {
  cmd = { "language-server-bitbake", "start", "--stdio" },
  filetypes = { 'bitbake' },
  root_markers = { ".git" },
}

