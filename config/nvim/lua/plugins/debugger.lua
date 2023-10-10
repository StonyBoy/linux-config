-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2023-Oct-10 20:27
-- vim: set ts=2 sw=2 sts=2 tw=120 et cc=120 ft=lua :

local function keymaps()
  vim.keymap.set('n', '<F2>', require('dap').toggle_breakpoint)
  vim.keymap.set('n', '<F3>', require('dap').continue)
  vim.keymap.set('n', '<F4>', require('dap').run_last)
  vim.keymap.set('n', '<F5>', require('dap').step_over)
  vim.keymap.set('n', '<F12>', require('dap').step_into)
  vim.keymap.set('n', '<leader>dr', require('dap').step_out)
  vim.keymap.set('n', '<leader>du', require('dap').run_to_cursor)
  vim.keymap.set('n', '<leader>dr', require('dap').restart)
  vim.keymap.set('n', '<leader>dt', require('dap').terminate)
end

-- For rust in Arch Linux you need
-- lldb for lldb-vscode
-- llvm for llvm-symbolizer
local function do_rust()
  local dap = require('dap')
  dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
    name = 'lldb'
  }
  dap.configurations.rust = {
    {
      name = 'Launch',
      type = 'lldb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},

      -- 💀
      -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
      --
      --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
      --
      -- Otherwise you might get the following error:
      --
      --    Error on launch: Failed to attach to the target process
      --
      -- But you should be aware of the implications:
      -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
      runInTerminal = true, -- This allows console interaction with the debuggee

      initCommands = function()
        -- Find out where to look for the pretty printer Python module
        local rustc_sysroot = vim.fn.trim(vim.fn.system('rustc --print sysroot'))

        local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
        local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

        local commands = {}
        local file = io.open(commands_file, 'r')
        if file then
          for line in file:lines() do
            table.insert(commands, line)
          end
          file:close()
        end
        table.insert(commands, 1, script_import)

        return commands
      end,
    },
  }

end

local function do_python()
  require('dap-python').setup('~/.pyenv/versions/3.11.2/bin/python')
end

return {
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
      'mfussenegger/nvim-dap-python',
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')

      dapui.setup()
      keymaps()
      do_rust()
      do_python()
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
    end,
  },
}
