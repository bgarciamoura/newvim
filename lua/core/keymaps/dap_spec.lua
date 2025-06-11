return {
	group_name = "DAP",
	group_prefix = "<leader>k",
	mappings = {
		{ "n", "<leader>dc", function() require("dap").continue() end, "DAP Continue" },
		{ "n", "<leader>db", function() require("dap").toggle_breakpoint() end, "Toggle Breakpoint" },
		{ "n", "<leader>dr", function() require("dap").repl.toggle() end, "Toggle REPL" },
		{ "n", "<leader>du", function() require("dapui").toggle() end, "DAP UI" },
	},
}
