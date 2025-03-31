-- Neovim Language Server Configuration
-- Steen Hegelund
-- Time-Stamp: 2025-Mar-31 22:18
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :
--
return {
  filetypes = { 'ruby' },
  cmd = { '/home/steen/.rvm/gems/ruby-3.2.3/bin/solargraph', 'stdio' },
  settings = {
    solargraph = {
      diagnostics = true
    }
  }
}
