-- Neovim Language Server Configuration
-- Steen Hegelund
-- Time-Stamp: 2025-Mar-31 22:18
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :
--
return {
  filetypes = { 'sh', 'bash' },
  cmd = { "bash-language-server", "start" },
  root_markers = {},
  settings = {
    bashIde = {
      globPattern = "*@(.sh|.inc|.bash|.command)"
    }
  }
}
