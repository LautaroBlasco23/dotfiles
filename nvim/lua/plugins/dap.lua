return {
  -- DAP: Debug Adapter Protocol client
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dap_utils = require("dap.utils")

      -- Signs in the gutter
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint", linehl = "", numhl = "" })

      -- --------------------------------------------------
      -- Go (delve) adapter
      -- --------------------------------------------------
      dap.adapters.go = function(callback, config)
        if config.request == "attach" and config.mode == "local" then
          local dlv = dap_utils.find_executable("dlv", "delve")
          if not dlv then
            vim.notify(
              "dlv not found in PATH. Install with: go install github.com/go-delve/delve/cmd/dlv@latest",
              vim.log.levels.ERROR
            )
            return
          end
          callback({
            type = "server",
            port = "${port}",
            executable = {
              command = dlv,
              args = {
                "attach", tostring(config.processId),
                "--headless", "--api-version=2",
                "--listen", "127.0.0.1:${port}",
              },
            },
          })
        elseif config.request == "attach" and config.mode == "remote" then
          callback({
            type = "server",
            port = config.port,
            host = config.host or "127.0.0.1",
          })
        end
      end

      -- --------------------------------------------------
      -- Node / TypeScript (vscode-js-debug) adapter
      -- --------------------------------------------------
      dap.adapters["pwa-node"] = function(callback, config)
        local adapter_path = vim.fn.stdpath("data")
          .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
        if vim.fn.filereadable(adapter_path) == 0 then
          vim.notify(
            "js-debug-adapter not found. Run :MasonInstall js-debug-adapter and restart Neovim",
            vim.log.levels.ERROR
          )
          return
        end
        callback({
          type = "server",
          host = "127.0.0.1",
          port = "${port}",
          executable = {
            command = "node",
            args = { adapter_path, "${port}" },
          },
        })
      end

      -- --------------------------------------------------
      -- Attach configurations
      -- --------------------------------------------------

      -- Go
      dap.configurations.go = {
        {
          type = "go",
          name = "Attach (local, pick PID)",
          request = "attach",
          mode = "local",
          processId = dap_utils.pick_process,
        },
        {
          type = "go",
          name = "Attach (remote delve)",
          request = "attach",
          mode = "remote",
          host = "127.0.0.1",
          port = 38697,
        },
      }

      -- Node / TypeScript (share the same configs)
      local node_attach_configs = {
        {
          type = "pwa-node",
          name = "Attach (local, pick PID)",
          request = "attach",
          processId = dap_utils.pick_process,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
        },
        {
          type = "pwa-node",
          name = "Attach (remote inspector)",
          request = "attach",
          port = 9229,
          address = "127.0.0.1",
          hostName = "127.0.0.1",
          sourceMaps = true,
        },
      }
      dap.configurations.javascript = node_attach_configs
      dap.configurations.typescript = node_attach_configs

      -- --------------------------------------------------
      -- Keymaps
      -- --------------------------------------------------
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { desc = "Debug: " .. desc })
      end

      map("<leader>da", dap.continue, "Run / attach config")
      map("<leader>dc", dap.continue, "Continue / start")
      map("<leader>do", dap.step_over, "Step over")
      map("<leader>di", dap.step_into, "Step into")
      map("<leader>dO", dap.step_out, "Step out")
      map("<leader>db", dap.toggle_breakpoint, "Toggle breakpoint")
      map("<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, "Conditional breakpoint")
      map("<leader>dr", function()
        dap.repl.toggle({}, "belowright")
      end, "Toggle REPL")
      map("<leader>du", function()
        require("dapui").toggle()
      end, "Toggle DAP UI")
      map("<leader>de", function()
        dap.evaluate(vim.fn.expand("<cword>"))
      end, "Evaluate expression")
    end,
  },

  -- DAP UI: scopes, watch, stack, breakpoints, REPL
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dapui = require("dapui")
      dapui.setup({
        icons = { expanded = "", collapsed = "", current_frame = "" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.33 },
              { id = "breakpoints", size = 0.17 },
              { id = "stacks", size = 0.33 },
              { id = "watches", size = 0.17 },
            },
            size = 50,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.50 },
              { id = "console", size = 0.50 },
            },
            size = 12,
            position = "bottom",
          },
        },
        floating = {
          max_height = 0.9,
          max_width = 0.5,
          border = "rounded",
          mappings = { close = { "q", "<Esc>" } },
        },
        controls = {
          enabled = true,
          element = "repl",
        },
      })

      -- Auto-open UI when debug session starts, close on stop
      local dap = require("dap")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  -- Show variable values inline next to the code
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {},
  },
}
