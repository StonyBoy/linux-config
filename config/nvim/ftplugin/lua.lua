-- Neovim configuration: Lua Language Server support
-- Steen Hegelund
-- Time-Stamp: 2023-Apr-27 17:13
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- yay lua-language-server

-- local util = require 'lspconfig.util'

local config = {
  name = 'luals',
  cmd = {'lua-language-server'},
  filetypes = { 'lua' },
  -- root_dir = util.root_pattern('.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml'),
  root_dir = vim.fs.dirname(vim.fs.find({'.git'}, { upward = true })[1]),
  settings = {
    Lua = {
      diagnostics = {
        globals = {'vim', 'it', 'describe'}
      },
      runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ';')
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    }
  }
}

vim.lsp.start(config, {
  reuse_client = function(client, conf)
    return (client.name == conf.name and client.config.root_dir == conf.root_dir)
  end
})
