-- Neovim configuration
-- Steen Hegelund
-- Time-Stamp: 2024-Feb-16 14:19
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


local function do_ext_term()
  local dap = require('dap')
  dap.defaults.fallback.external_terminal = {
    command = '/usr/local/bin/alacritty';
    args = {'-e'};
  }
end

-- For C, CPP and Rust you need these packages with these two programs in your path
-- lldb for lldb-vscode
-- llvm for llvm-symbolizer
local function do_lldb()
  local dap = require('dap')
  local cmdstr = '/usr/bin/lldb-vscode'
  if vim.fn.has('macunix') ~= 0 then
    cmdstr = '/usr/local/opt/llvm/bin/lldb-vscode'
  end
  dap.adapters.lldb = {
    type = 'executable',
    command = cmdstr, -- adjust as needed, must be absolute path
    name = 'lldb',
    console = 'internalConsole',
  }
end

-- Download a release from https://github.com/microsoft/vscode-js-debug/releases
-- and install in /opt
local function do_nodejs()
  local dap = require('dap')
  dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "node",
      -- 💀 Make sure to update this path to point to your installation
      args = {"/opt/js-debug/src/dapDebugServer.js", "${port}"},
    }
  }
  dap.configurations.javascript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
  },
}
end


local function do_rust()
  local dap = require('dap')
  dap.configurations.rust = {
    {
      name = 'Launch',
      type = 'lldb',
      request = 'launch',
      program = function()
        return vim.fn.input({
          prompt = 'Path to executable: ',
          default = vim.fn.getcwd() .. '/',
          completion = 'file'
        })
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = function()
        -- completion: see help command-complete
        return vim.split(vim.fn.input({prompt = 'Arguments: ', completion = 'file'}), ' ')
      end,

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


-- Create a ~/python folder and create a virtual environment there, and install debugpy via pip
-- mkdir ~/python && cd ~/python && python -m venv . && ~/python/bin/python -m pip install debugpy
local function do_python()
  require('dap-python').setup('~/python/bin/python')
end


local function do_c_cpp()
  local dap = require('dap')
  dap.configurations.cpp = {
    {
      name = 'Launch',
      type = 'lldb',
      request = 'launch',
      program = function()
        return vim.fn.input({
          prompt = 'Path to executable: ',
          default = vim.fn.getcwd() .. '/',
          completion = 'file'
        })
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      stopAtBeginningOfMainSubprogram = true,
      console = 'internalConsole',
      args = function()
        -- completion: see help command-complete
        return vim.split(vim.fn.input({prompt = 'Arguments: ', completion = 'file'}), ' ')
      end,

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
      runInTerminal = true,
    },
  }
  dap.configurations.c = dap.configurations.cpp
end


local function do_ruby()
  require("dap-ruby").setup()
end


local function setup_ui()
  -- highlight debugPC cterm=reverse ctermfg=162 ctermbg=230 gui=reverse guifg=#d33682 guibg=#fdf6e3
  vim.api.nvim_set_hl(0, "debugPC", {
    fg = "#d33682",
    bg = "#fdf6e3",
    reverse = true,
    ctermbg = 230,
    ctermfg = 162
  })
end

return {
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
      'mfussenegger/nvim-dap-python',
      'mxsdev/nvim-dap-vscode-js',
      'suketa/nvim-dap-ruby',
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')

      dapui.setup({
        layouts = { {
          elements = { {
            id = "breakpoints",
            size = 0.10
          }, {
            id = "watches",
            size = 0.20
          }, {
            id = "stacks",
            size = 0.20
          }, {
            id = "scopes",
            size = 0.50
          } },
          position = "left",
          size = 50
        }, {
          elements = { {
            id = "repl",
            size = 0.5
          }, {
            id = "console",
            size = 0.5
          } },
          position = "bottom",
          size = 10
        } },
      })
      keymaps()
      do_ext_term()
      do_lldb()
      do_rust()
      do_c_cpp()
      do_python()
      do_nodejs()
      do_ruby()
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
      setup_ui()
    end,
  },
}
