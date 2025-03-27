-- statusline configuration
-- Steen Hegelund
-- Time-Stamp: 2025-Mar-27 21:04
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

-- Show editor configuration: tabs/spaces, tabstop, softtabstop, shiftwidth and textwidth (wrapping)
local edit_config = function()
  local tabstr = vim.bo.expandtab and 'spc' or 'tab'
  local result = string.format('%s | ts:%d | sw:%d | sts:%d | tw:%d',
    tabstr, vim.bo.tabstop, vim.bo.shiftwidth, vim.bo.softtabstop, vim.bo.textwidth)
  return result
end

-- Show linenumber and virtual column number (when eg tabs are expanded to spaces)
local function file_location()
  return '%03l:%02v'
end

-- Show the file modification state of the active buffer
local filemod_state = function()
    local ret = ''
    if vim.bo.modified then
      ret = '[+]'
    end
    if vim.bo.modifiable == false or vim.bo.readonly == true then
      ret = '[-]'
    end
    return ret
end

-- Show a full path if there is room. For fugitive file only show 'git:filename'
local abbrev_path = function()
    local ret = vim.fn.expand("%:t") -- Tail part of path (name)
    local fpath = vim.fn.expand('%:p:~') -- Full path optionally using ~ for home
    local margin = vim.api.nvim_win_get_width(0) - string.len(fpath) - 100

    if vim.startswith(fpath, 'fugitive') then
        ret = "git:" .. ret
    elseif vim.go.laststatus == 3 or margin > 10 then
        ret = fpath
    end
    return ret
end

-- Show which language server is attatched to the active buffer
local language_server = function()
  local buf_clients = vim.lsp.get_clients()
  local original_bufnr = vim.api.nvim_get_current_buf()

  for _, client in pairs(buf_clients) do
    local attached_buffers_list = vim.lsp.get_buffers_by_client_id(client.id)
    for _, bufno in pairs(attached_buffers_list) do
      if bufno == original_bufnr then
        return client.name
      end
    end
  end
  return ''
end

local colorscheme = function()
  local cscheme = vim.g.colors_name
  if vim.startswith(cscheme, 'solarized') then
    cscheme = 'solarized_' .. vim.go.background
  end
  return cscheme
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  config = function()
    require('lualine').setup({
      options = {
        theme = colorscheme(),
        always_divide_middle = true,
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '|', right = '|' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', filemod_state, { abbrev_path } },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'encoding', 'bo:fileformat', 'filetype', file_location, 'progress' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { filemod_state, {'filename', path = 3} },
        lualine_x = { 'progress' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {
        lualine_a = {
          { 'tabs',
          mode = 2,
          max_length = vim.o.columns,
          },
        },
        lualine_b = { { require('NeoComposer.ui').status_recording } },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { language_server },
        lualine_z = { edit_config },
      },
      extensions = {},
    })
  end,
}
