vim.lsp.config["biome"] = {
	cmd = { "biome", "lsp-proxy" },
	filetypes = {
		"astro",
		"css",
		"graphql",
		"javascript",
		"javascriptreact",
		"json",
		"jsonc",
		"svelte",
		"typescript",
		"typescript.tsx",
		"typescriptreact",
		"vue",
		"htmlangular",
	},
	root_markers = { "biome.json", "biome.jsonc" },
}

vim.lsp.enable("biome")
