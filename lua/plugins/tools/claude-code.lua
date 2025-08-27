return {
	"greggh/claude-code.nvim",
	event = "VeryLazy",
	cmd = { "ClaudeCode", "ClaudeCodeToggle" },
	keys = {
		{ "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Open Claude Code" },
		{ "<leader>ct", "<cmd>ClaudeCodeToggle<cr>", desc = "Toggle Claude Code" },
	},
	opts = {
		-- Configure claude-code.nvim settings here
		-- Window configuration
		window = {
			width = 80,
			height = 20,
			border = "rounded",
			position = "vertical",
		},
		-- Keymaps within claude-code buffer
		keymaps = {
			close = "q",
			send = "<C-CR>",
			clear = "<C-l>",
		},
		-- Auto-start behavior
		auto_start = false,
		-- Integration with your existing tools
		integrations = {
			telescope = true,
			lsp = true,
		},
	},
	config = function(_, opts)
		require("claude-code").setup(opts)
	end,
}

