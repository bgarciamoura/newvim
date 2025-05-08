return {
	settings = {
		json = {
			schemas = {
				{
					fileMatch = { "package.json" },
					url = "https://json.schemastore.org/package.json",
				},
				{
					fileMatch = { "tsconfig*.json" },
					url = "https://json.schemastore.org/tsconfig.json",
				},
				{
					fileMatch = { ".prettierrc", ".prettierrc.json" },
					url = "https://json.schemastore.org/prettierrc",
				},
				{
					fileMatch = { ".eslintrc", ".eslintrc.json" },
					url = "https://json.schemastore.org/eslintrc",
				},
				{
					fileMatch = { "biome.json" },
					url = "https://biomejs.dev/schemas/1.0.0/schema.json",
				},
				{
					fileMatch = { "lerna.json" },
					url = "https://json.schemastore.org/lerna.json",
				},
				{
					fileMatch = { "nest-cli.json" },
					url = "https://json.schemastore.org/nest-cli.json",
				},
				{
					fileMatch = { ".stylelintrc", ".stylelintrc.json", "stylelint.config.json" },
					url = "https://json.schemastore.org/stylelintrc.json",
				},
				{
					fileMatch = { "/.github/workflows/*" },
					url = "https://json.schemastore.org/github-workflow.json",
				},
			},
			validate = { enable = true },
			format = { enable = true },
		},
	},
	commands = {
		Format = {
			function()
				vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
			end,
		},
	},
}
