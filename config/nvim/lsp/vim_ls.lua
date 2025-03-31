-- Neovim Language Server Configuration
-- Steen Hegelund
-- Time-Stamp: 2025-Mar-31 22:18
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :
--
return {
  filetypes = { 'vim' },
  cmd = { 'vim-language-server', '--stdio' },
  root_markers = {},
  init_options = {
    diagnostic = {
      enable = true
    },
    indexes = {
      count = 3,
      gap = 100,
      projectRootPatterns = { 'runtime', 'nvim', '.git', 'autoload', 'plugin' },
      runtimepath = true
    },
    isNeovim = true,
    iskeyword = '@,48-57,_,192-255,-#',
    runtimepath = '',
    suggest = {
      fromRuntimepath = true,
      fromVimruntime = true
    },
    vimruntime = ''
  },
  single_file_support = true,
}
