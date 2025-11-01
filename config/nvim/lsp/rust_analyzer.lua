-- Neovim Language Server Configuration
-- Steen Hegelund
-- Time-Stamp: 2025-Nov-01 14:03
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :
--
return {
  filetypes = { 'rust' },
  cmd = { 'rust-analyzer' },
  root_markers = {'Cargo.toml'},
  -- settings = {
  --   autoformat = true,
  --   rust_analyzer = {
  --     check = {
  --       command = 'clippy'
  --     }
  --   }
  -- }
}
