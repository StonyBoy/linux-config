-- Neovim configuration: BASH shell script Language Server support
-- Steen Hegelund
-- Time-Stamp: 2022-Oct-03 22:07
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- npm i -g bash-language-server

local config = {
  name = 'bash-language-server',
  cmd = { 'bash-language-server', 'start' },
  root_dir = vim.fs.dirname(vim.fs.find({'.git'}, { upward = true })[1]),
}

vim.lsp.start(config, {
  reuse_client = function(client, conf)
    return (client.name == conf.name and client.config.root_dir == conf.root_dir)
  end
})
