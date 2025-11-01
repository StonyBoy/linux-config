-- Neovim Language Server Configuration
-- Steen Hegelund
-- Time-Stamp: 2025-Nov-01 14:12
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :
--
return {
  filetypes = {'javascript', 'typescript', 'typescriptreact'},
  cmd = {'typescript-language-server', '--stdio'},
  root_markers = {'tsconfig.json'},
}
