return {
	"folke/trouble.nvim",
	event = "VeryLazy",
	keys = {
		{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Workspace)" },
		{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (Buffer)" },
		{ "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix" },
		{ "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
	},
	opts = {
		use_diagnostic_signs = true,
		win = {
			position = "right",
		},
		diagnostics = {
			desc = "diagnostics",
			events = { "DiagnosticChanged", "BufEnter" },
			source = "diagnostics",
			groups = {
				{ "directory" },
				{ "filename", format = "{file_icon} {basename} {count}" },
			},
			sort = { "severity", "filename", "pos", "message" },
			format = "{severity_icon} {message:md} {item.source} {code} {pos}",
		},
		preview_float = {
			mode = "diagnostics",
			preview = {
				type = "float",
				relative = "editor",
				border = "rounded",
				title = "Preview",
				title_pos = "center",
				position = { 0, -2 },
				size = { width = 0.3, height = 0.3 },
				zindex = 200,
			},
		},
	},
}
