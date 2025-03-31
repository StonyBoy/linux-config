-- Neovim Language Server Configuration
-- Steen Hegelund
-- Time-Stamp: 2025-Mar-31 22:18
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :
-- 
return {
  filetypes = { 'lua' },
  cmd = { 'lua-language-server', },
  root_markers = {'.luarc.json'},
  settings = {
    Lua = {
      diagnostics = {
        globals = {'vim', 'it', 'describe'}
      },
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';')
      },
      telemetry = {
        enable = false,
      },
    }
  }
}
