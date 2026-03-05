-- ============================================================================
-- DEBUG ADAPTER PROTOCOL (DAP) CONFIGURATION
-- ============================================================================
--
-- WHAT IS DAP?
-- ------------
-- DAP (Debug Adapter Protocol) is a standardized protocol for debuggers,
-- similar to how LSP standardizes language features. nvim-dap is the DAP
-- client for Neovim.
--
-- With DAP, you can:
--   - Set breakpoints (stop execution at specific lines)
--   - Step through code (into, over, out)
--   - Inspect variables and their values
--   - Evaluate expressions during debugging
--   - View the call stack
--
-- SUPPORTED LANGUAGES IN THIS CONFIG
-- ----------------------------------
-- Java:       Configured via nvim-jdtls (see java.lua)
-- JavaScript: Can add via :MasonInstall js-debug-adapter
-- TypeScript: Uses same adapter as JavaScript
--
-- HOW IT WORKS WITH SPRING BOOT
-- -----------------------------
-- 1. Set breakpoints in your Java code (<leader>db)
-- 2. Start your Spring Boot app in debug mode:
--    - Via JDTLS: Use <leader>jtm on a @Test method, or
--    - Via terminal: mvn spring-boot:run -Dspring-boot.run.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"
-- 3. Attach debugger (<leader>dc)
-- 4. Execution stops at breakpoints
-- 5. Step through code, inspect variables
--
-- nvim-dap-ui provides a visual interface showing:
--   - Variables in scope
--   - Watch expressions
--   - Call stack
--   - Breakpoints list
--   - REPL for evaluating expressions
--
-- ============================================================================

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- UI for the debugger (variable inspector, call stack, etc.)
			"rcarriga/nvim-dap-ui",
			-- Required by nvim-dap-ui
			"nvim-neotest/nvim-nio",
			-- Virtual text showing variable values inline
			"theHamsta/nvim-dap-virtual-text",
		},
		cmd = { "DapToggleBreakpoint", "DapContinue" },
		keys = {
			{ "<leader>db", desc = "Toggle Breakpoint" },
			{ "<leader>dB", desc = "Conditional Breakpoint" },
			{ "<leader>dc", desc = "Continue / Start" },
			{ "<leader>di", desc = "Step Into" },
			{ "<leader>do", desc = "Step Over" },
			{ "<leader>dO", desc = "Step Out" },
			{ "<leader>dr", desc = "Restart" },
			{ "<leader>dq", desc = "Terminate" },
			{ "<leader>du", desc = "Toggle DAP UI" },
			{ "<leader>de", desc = "Evaluate Expression" },
			{ "<leader>dR", desc = "Open REPL" },
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- ================================================================
			-- DAP UI SETUP
			-- ================================================================
			-- The UI provides panels for:
			--   - scopes: Local variables and their values
			--   - breakpoints: All breakpoints in the project
			--   - stacks: Call stack (how you got to current line)
			--   - watches: Custom expressions to monitor
			--   - repl: Interactive evaluation
			--   - console: Debug output

			dapui.setup({
				-- Customize layout if needed
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						size = 40,
						position = "left",
					},
					{
						elements = {
							{ id = "repl", size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						size = 10,
						position = "bottom",
					},
				},
			})

			-- ================================================================
			-- VIRTUAL TEXT
			-- ================================================================
			-- Shows variable values inline next to the code
			-- e.g., `int x = 5;` shows "x = 5" after the line while debugging

			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true, -- Highlight when value changes
				highlight_new_as_changed = false,
				show_stop_reason = true, -- Show why execution stopped
				commented = false, -- Don't prefix with comment syntax
				virt_text_pos = "eol", -- Show at end of line
			})

			-- ================================================================
			-- AUTO OPEN/CLOSE UI
			-- ================================================================
			-- Automatically show the debug UI when debugging starts
			-- and hide it when debugging ends

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- ================================================================
			-- BREAKPOINT SIGNS
			-- ================================================================
			-- Customize the appearance of breakpoints in the sign column

			vim.fn.sign_define("DapBreakpoint", {
				text = "",
				texthl = "DiagnosticSignError",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapBreakpointCondition", {
				text = "",
				texthl = "DiagnosticSignWarn",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapLogPoint", {
				text = "",
				texthl = "DiagnosticSignInfo",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapStopped", {
				text = "",
				texthl = "DiagnosticSignWarn",
				linehl = "Visual",
				numhl = "DiagnosticSignWarn",
			})
			vim.fn.sign_define("DapBreakpointRejected", {
				text = "",
				texthl = "DiagnosticSignHint",
				linehl = "",
				numhl = "",
			})

			-- ================================================================
			-- KEYMAPS
			-- ================================================================
			-- All debugging keymaps use <leader>d prefix

			-- Breakpoints
			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Conditional Breakpoint" })
			vim.keymap.set("n", "<leader>dl", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end, { desc = "Log Point" })

			-- Execution control
			vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue / Start" })
			vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
			vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
			vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step Out" })
			vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "Restart" })
			vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "Terminate" })

			-- UI controls
			vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
			vim.keymap.set("n", "<leader>de", dapui.eval, { desc = "Evaluate Expression" })
			vim.keymap.set("v", "<leader>de", dapui.eval, { desc = "Evaluate Selection" })
			vim.keymap.set("n", "<leader>dR", dap.repl.open, { desc = "Open REPL" })

			-- ================================================================
			-- JAVASCRIPT/TYPESCRIPT ADAPTER (Optional)
			-- ================================================================
			-- Uncomment if you want to debug Angular/frontend code
			-- First run: :MasonInstall js-debug-adapter
			--
			-- local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"
			-- if vim.fn.isdirectory(js_debug_path) == 1 then
			-- 	require("dap").adapters["pwa-node"] = {
			-- 		type = "server",
			-- 		host = "localhost",
			-- 		port = "${port}",
			-- 		executable = {
			-- 			command = "node",
			-- 			args = { js_debug_path .. "/js-debug/src/dapDebugServer.js", "${port}" },
			-- 		},
			-- 	}
			--
			-- 	for _, lang in ipairs({ "javascript", "typescript" }) do
			-- 		dap.configurations[lang] = {
			-- 			{
			-- 				type = "pwa-node",
			-- 				request = "launch",
			-- 				name = "Launch file",
			-- 				program = "${file}",
			-- 				cwd = "${workspaceFolder}",
			-- 			},
			-- 		}
			-- 	end
			-- end
		end,
	},
}

-- ============================================================================
-- QUICK REFERENCE: DEBUG KEYMAPS
-- ============================================================================
--
-- BREAKPOINTS
-- -----------
-- <leader>db - Toggle breakpoint at current line
-- <leader>dB - Set conditional breakpoint (stops only when condition is true)
-- <leader>dl - Set log point (logs message without stopping)
--
-- EXECUTION CONTROL
-- -----------------
-- <leader>dc - Continue execution (or start debugging)
-- <leader>di - Step into (enter function calls)
-- <leader>do - Step over (execute line, don't enter functions)
-- <leader>dO - Step out (finish current function, return to caller)
-- <leader>dr - Restart debugging session
-- <leader>dq - Terminate/quit debugging
--
-- UI & EVALUATION
-- ---------------
-- <leader>du - Toggle debug UI panels
-- <leader>de - Evaluate expression under cursor (or selection in visual)
-- <leader>dR - Open REPL for interactive evaluation
--
-- ============================================================================
-- DEBUGGING WORKFLOW
-- ============================================================================
--
-- 1. JAVA/SPRING BOOT:
--    a) Set breakpoints with <leader>db
--    b) Run test: <leader>jtm (runs test under cursor with debugger)
--    c) Or use :lua require('jdtls.dap').pick_test() to select a test
--    d) Code stops at breakpoints, inspect variables in DAP UI
--
-- 2. ATTACHING TO RUNNING APP:
--    a) Start Spring Boot with debug port:
--       ./mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005"
--    b) Create attach configuration in java.lua if needed
--    c) Run <leader>dc and select attach configuration
--
-- ============================================================================
