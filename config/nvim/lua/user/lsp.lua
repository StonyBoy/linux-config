-- Neovim configuration Adding Language Server support
-- Steen Hegelund
-- Time-Stamp: 2022-May-30 20:52
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- yay ccls
-- npm i -g pyright
-- gem install solargraph
-- npm install -g rome
-- npm install -g typescript typescript-language-server
-- yay rust-analyzer
-- yay lua-language-server

local status_ok, nvim_lsp = pcall(require, 'lsp_config')
if not status_ok then
  return
end

local servers = { 'ccls', 'pyright', 'solargraph', 'rome', 'tsserver', 'rust_analyzer' }

nvim_lsp.ccls.setup{}
nvim_lsp.pyright.setup{}
nvim_lsp.solargraph.setup{}
nvim_lsp.rome.setup{}
nvim_lsp.tsserver.setup{}
nvim_lsp.rust_analyzer.setup{}
nvim_lsp.sumneko_lua.setup{}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gT', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<space>K', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    -- map buffer local keybindings when the language server attaches
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
  }
end

-- The lua language server gets special treatment
nvim_lsp.sumneko_lua.setup {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  runtime = {
    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
    version = 'LuaJIT',
    -- Setup your lua path
    path = vim.split(package.path, ';')
  },
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  },
}
