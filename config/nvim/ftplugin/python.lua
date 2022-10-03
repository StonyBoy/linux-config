-- Neovim configuration: Python Language Server support
-- Steen Hegelund
-- Time-Stamp: 2022-Oct-03 21:56
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- npm i -g pyright

local config = {
  name = 'pyright',
  cmd = {'pyright-langserver', '--stdio'},
  root_dir = vim.fs.dirname(vim.fs.find({'setup.py', 'pyproject.toml'}, { upward = true })[1]),
}

vim.lsp.start(config, {
  reuse_client = function(client, conf)
    return (client.name == conf.name
    and (client.config.root_dir == conf.root_dir
    or (conf.root_dir == nil and vim.startswith(vim.api.nvim_buf_get_name(0), "/usr/lib/python"))
    )
    )
  end
})
