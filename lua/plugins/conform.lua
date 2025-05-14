return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			html = { "prettierd" },
			htmlangular = { "prettierd" },
			javascript = { "biome" },
			javascriptreact = { "biome" },
			typescript = { "biome" },
			typescriptreact = { "biome" },
			css = { "prettierd" },
			json = { "biome" },
		},
		formatters = {
			biome = {
				command = "biome",
				args = { "format", "--stdin-file-path", "$FILENAME" },
				stdin = true,
				require_cwd = true,
			},
			prettierd = {
				command = "prettierd",
				args = { "$FILENAME" },
				stdin = true,
				require_cwd = true,
			},
		},
		format_on_save = {
			timeout_ms = 3000,
			lsp_format = "fallback",
		},
	},
}
