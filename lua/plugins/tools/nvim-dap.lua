return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- DAP UI
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-neotest/nvim-nio" },
      opts = {},
      config = function(_, opts)
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup(opts)
        
        -- Auto open/close DAP UI
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open({})
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close({})
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close({})
        end
      end,
    },
    -- Virtual text
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        clear_on_continue = false,
        display_callback = function(variable, buf, stackframe, node, options)
          if options.virt_text_pos == "inline" then
            return " = " .. variable.value
          else
            return variable.name .. " = " .. variable.value
          end
        end,
        virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
      },
    },
    -- Mason DAP
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = "mason.nvim",
      cmd = { "DapInstall", "DapUninstall" },
      opts = {
        automatic_installation = true,
        handlers = {},
        ensure_installed = {
          "node2",
          "chrome",
        },
      },
    },
  },
  keys = {
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
    { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
  },
  config = function()
    local dap = require("dap")
    
    -- DAP signs
    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
    
    for name, sign in pairs({
      DapBreakpoint = { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" },
      DapBreakpointCondition = { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" },
      DapLogPoint = { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" },
      DapStopped = { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" },
      DapBreakpointRejected = { text = "", texthl = "DapBreakpointRejected", linehl = "", numhl = "" },
    }) do
      vim.fn.sign_define(name, sign)
    end

    -- Node.js/TypeScript debugging
    dap.adapters.node2 = {
      type = "executable",
      command = "node",
      args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
    }

    -- Chrome debugging
    dap.adapters.chrome = {
      type = "executable",
      command = "node",
      args = { vim.fn.stdpath("data") .. "/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js" },
    }

    -- JavaScript/TypeScript configurations
    dap.configurations.javascript = {
      {
        name = "Launch file",
        type = "node2",
        request = "launch",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
      },
      {
        name = "Attach to process",
        type = "node2",
        request = "attach",
        processId = require("dap.utils").pick_process,
      },
      {
        name = "Launch via NPM",
        type = "node2",
        request = "launch",
        cwd = vim.fn.getcwd(),
        runtimeArgs = { "run-script", "debug" },
        runtimeExecutable = "npm",
        console = "integratedTerminal",
      },
      {
        name = "Debug Jest Tests",
        type = "node2",
        request = "launch",
        cwd = vim.fn.getcwd(),
        runtimeArgs = { "--inspect-brk=9229", "node_modules/.bin/jest", "--runInBand" },
        runtimeExecutable = "node",
        console = "integratedTerminal",
        internalConsoleOptions = "neverOpen",
      },
      {
        name = "Debug React (Chrome)",
        type = "chrome",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}",
      },
    }

    -- TypeScript uses same configs as JavaScript
    dap.configurations.typescript = dap.configurations.javascript
    dap.configurations.typescriptreact = dap.configurations.javascript
    dap.configurations.javascriptreact = dap.configurations.javascript

    -- React Native debugging
    dap.configurations.javascript = vim.list_extend(dap.configurations.javascript or {}, {
      {
        name = "Debug React Native",
        type = "node2",
        request = "attach",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
        port = 8081,
        address = "localhost",
        localRoot = "${workspaceFolder}",
        remoteRoot = nil,
        skipFiles = { "<node_internals>/**/*.js" },
      },
    })
  end,
}