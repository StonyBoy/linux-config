-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2022-May-30 20:02
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Filetype handling
local grp = vim.api.nvim_create_augroup('filetype_settings', {})
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = grp,
  pattern =  '*.in',
  command = 'setf make'
})
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = grp,
  pattern =  {'*.c', '*.h', '*.S', '*.dts', '*.dtsi'},
  command = 'setlocal tabstop=8 shiftwidth=8 softtabstop=8 textwidth=80 noexpandtab colorcolumn=80 cindent'
})
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = grp,
  pattern = {'*.cxx', '*.hxx'},
  command = 'setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120 expandtab colorcolumn=120 cindent',
})
vim.api.nvim_create_autocmd('BufWritePre', {
  group = grp,
  pattern = {'*.c', '*.h'},
  command = 'TrailspaceTrim',
})
vim.api.nvim_create_autocmd('FileType', {
  group = grp,
  pattern = {'bash', 'ruby'},
  command = 'setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120 expandtab colorcolumn=120 cindent',
})
vim.api.nvim_create_autocmd('FileType', {
  group = grp,
  pattern = {'lua'},
  command = 'setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120 expandtab colorcolumn=120 cindent',
})
vim.api.nvim_create_autocmd('FileType', {
  group = grp,
  pattern = {'gitcommit', 'gitsendemail', 'mail'},
  command = 'setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=75 expandtab colorcolumn=75 cindent',
})
vim.api.nvim_create_autocmd('FileType', {
  group = grp,
  pattern = {'md', 'markdown', 'asciidoc', 'text', 'gitcommit', 'gitsendemail'},
  command = 'setlocal spell spelllang=en_us',
})
vim.api.nvim_create_autocmd('FileType', {
  group = grp,
  pattern = {'make'},
  command = 'setlocal tabstop=8 shiftwidth=8 softtabstop=8 textwidth=80 colorcolumn=80',
})

-- Close the QuickFix buffer when hitting Enter to leave
vim.api.nvim_create_autocmd('FileType', {
    group = grp,
    pattern = {'qf'},
    callback = function(opts)
      vim.api.nvim_buf_set_keymap(opts.buf, 'n', '<cr>', '', { noremap = true, silent = true,
        callback = function()
          vim.cmd 'cclose'
        end,
      })
    end,
})

-- Auto resize all VIM windows when VIM is resized
grp = vim.api.nvim_create_augroup('nvim_windows', {})
vim.api.nvim_create_autocmd({'VimResized'}, {
  group = grp,
  command = 'wincmd ='
})

