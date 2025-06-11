return {
	"neovim/nvim-lspconfig",
	config = function()
		require("mason").setup({
			registries = { "github:crashdummyy/mason-registry", "github:mason-org/mason-registry" },
		})
		require("mason-lspconfig").setup()
		require("roslyn").setup()

		vim.diagnostic.config({
			signs = {
				numhl = {
					[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
					[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
					[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
					[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
				},
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.HINT] = "",
					[vim.diagnostic.severity.INFO] = "󰋽",
					[vim.diagnostic.severity.WARN] = "",
				},
			},
			update_in_insert = true,
			virtual_text = false,
			virtual_lines = { current_line = true },
		})
	end,
	dependencies = {
		"seblyng/roslyn.nvim",
		"mason-org/mason-lspconfig.nvim",
		"mason-org/mason.nvim",
                { "saghen/blink.cmp" },
        },
}
