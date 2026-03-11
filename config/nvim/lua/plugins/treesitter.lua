-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2026-Mar-11 14:48
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Highlight, edit, and navigate code using a fast incremental parsing library
--
-- Setup notes for the new nvim-treesitter API (post-rewrite plugin + Neovim 0.11+):
--
-- 1. The plugin stores highlight queries in runtime/queries/ but Neovim does not
--    search that subdirectory automatically. Adding plugin.dir .. "/runtime" to rtp
--    is required, otherwise parsers load but highlighting is missing.
--
-- 2. treesitter.install() downloads and compiles unconditionally. To avoid re-downloading
--    on every startup, filter with vim.treesitter.language.add first and only install
--    languages where that call fails (i.e. the parser .so is missing).
--
-- 3. The new API does not auto-enable highlighting. An explicit FileType autocmd calling
--    vim.treesitter.start() is needed for the desired filetypes.
--
-- 4. If the Neovim source build has newer runtime queries than what nvim-treesitter ships
--    (e.g. the except* node for Python 3.11+), vim.treesitter.start() will fail for that
--    language. The pcall in the autocmd callback handles this gracefully: highlighting is
--    silently skipped for incompatible languages and automatically enabled when an updated
--    parser/query becomes available.
--
-- On a fresh system: copy this file, open nvim. First launch downloads and compiles all
-- parsers (one-time). Subsequent launches will be silent.
return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ":TSUpdate",
    config = function(plugin)
      local treesitter = require("nvim-treesitter")
      treesitter.setup()
      -- Add bundled queries to runtimepath so highlights.scm etc. are found
      vim.opt.rtp:append(plugin.dir .. "/runtime")
      local languages = {
          "awk",
          "bash",
          "c",
          "cmake",
          "css",
          "devicetree",
          "dockerfile",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "python",
          "query",
          "regex",
          "ruby",
          "rust",
          "toml",
          "vim",
          "vimdoc",
          "yaml",
          "yang",
      }
      local missing = vim.tbl_filter(function(lang)
        return not pcall(vim.treesitter.language.add, lang)
      end, languages)
      if #missing > 0 then
        treesitter.install(missing)
      end
      vim.api.nvim_create_user_command('Tsast', function()
        vim.treesitter.inspect_tree()
      end, { desc = "Show treesitter AST for current buffer" })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = languages,
        callback = function()
          local ok, err = pcall(vim.treesitter.start)
          if ok then
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            -- vim.wo.foldmethod = 'expr'
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects', -- Additional textobjects for treesitter
    -- commit = "73e44f43c70289c70195b5e7bc6a077ceffddda4", -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/513
  }
}
