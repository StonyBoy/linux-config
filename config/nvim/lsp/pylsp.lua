-- Neovim Language Server Configuration
-- Steen Hegelund
-- Time-Stamp: 2025-Nov-01 14:05
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :
--
return {
  filetypes = { 'python' },
  cmd = { 'pylsp' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile' },
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'W391','E501', 'E231'},
          maxLineLength = 120
        }
      }
    }
  },
}

