-- Neovim configuration: YAML Language Server support
-- Steen Hegelund
-- Time-Stamp: 2022-Oct-03 22:18
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- yay yaml-language-server

local config = {
  name = 'yaml-ls',
  cmd = {'yaml-language-server', '--stdio'},
  root_dir = vim.fs.dirname(vim.fs.find({'.git'}, { upward = true })[1]),
}

vim.lsp.start(config, {
  reuse_client = function(client, conf)
    return (client.name == conf.name and client.config.root_dir == conf.root_dir)
  end
})
