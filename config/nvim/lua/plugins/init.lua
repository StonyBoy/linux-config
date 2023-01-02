-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2022-May-31 09:11
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

return {
    'christoomey/vim-tmux-navigator',              -- Go between panes in both vim and tmux
    'tpope/vim-eunuch',                            -- Vim sugar for the UNIX shell commands that need it the most
    'tpope/vim-fugitive',                          -- GIT support
    'tpope/vim-obsession',                         -- Automatic editing sessions
    'tpope/vim-markdown',                          -- Syntax highlighting for markdown files
    'tpope/vim-dispatch',                          -- Run build commands in the background and parse the result
    'tpope/vim-unimpaired',                        -- Pairs of handy bracket mappings
    'tpope/vim-surround',                          -- Mappings to easily delete, change and add such surroundings in pairs
    'tpope/vim-abolish',                           -- Word Case substitution: snake/mixed/camel/upper/
    'airblade/vim-gitgutter',                      -- Git: Changed lines since last revision
    'AndrewRadev/linediff.vim',                    -- Diff two separate blocks of text
    'AndrewRadev/splitjoin.vim',                   -- Switching between a single-line statement and a multi-line one
    'triglav/vim-visual-increment',                -- Increment lists in visual mode
    'azabiong/vim-highlighter',                    -- Save/Load highlights, finding variables, and customizing colors
    'wsdjeg/vim-fetch',                            -- Use line and column jumps in file paths as found in stack traces and similar output
    'rhysd/vim-clang-format',                      -- Format your code with specific coding style using clang-format
    'yazgoo/unicodemoji',                          -- fast unicode emojis in terminal and vim with fzf
    'vim-ruby/vim-ruby',                           -- Ruby support
    'pangloss/vim-javascript',                     -- Better Javascript indenting support
    'rust-lang/rust.vim',                          -- Rust, syntax highlighting, formatting, Syntastic integration
    'aklt/plantuml-syntax',                        -- PlantUML Syntax/  usein/FTDetect
    'nvim-treesitter/nvim-treesitter',             -- Highlight, edit, and navigate code using a fast incremental parsing library
    'nvim-treesitter/nvim-treesitter-textobjects', -- Additional textobjects for treesitter
    'rafcamlet/nvim-luapad',                       -- Interactive neovim scratchpad for lua
    'ten3roberts/qf.nvim',                         -- Quickfix and location list management for Neovim
}
