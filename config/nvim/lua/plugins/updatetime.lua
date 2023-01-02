-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2022-Jun-02 21:49
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Add name-timestamp header in the beginning of the file
return {
  {
    'tpope/vim-commentary',                        -- Comment in/out lines of text in various languages
    lazy = false,
  },
  {
    'vim-scripts/update-time',                     -- Insert/Update timestamps in files
    lazy = false,
    config = function()
      vim.cmd [[
        function! AddFileHeader()
        call append(0, ["Steen Hegelund", "Time-Stamp: #", ""])
        exec '0,3Commentary'
        endfunction
        nnoremap <silent> <Leader><Leader>h :call AddFileHeader()<CR>

        let g:update_time_time_stamp_leader = 'Time-Stamp: '
        let g:update_time_time_format = '%Y-%b-%d %H:%M'

      ]]
    end,
  }
}
