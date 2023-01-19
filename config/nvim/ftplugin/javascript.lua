-- Neovim configuration: javascript and typescript Language Server support
-- Steen Hegelund
-- Time-Stamp: 2023-Jan-19 20:31
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- npm install -g typescript typescript-language-server
--
-- Add a jsconfig.json file in the root of each project
-- {
--   "compilerOptions": {
--     "module": "commonjs",
--     "target": "es6",
--     "checkJs": false
--   },
--   "exclude": [
--     "node_modules"
--   ]
-- }

local config = {
  name = 'tsserver',  -- configuration name in lspconfig plugin
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "javascript.jsx" },
}

vim.lsp.start(config, {
  reuse_client = function(client, conf)
    return (client.name == conf.name
    and (client.config.root_dir == conf.root_dir))
  end
})
