if not vim.lsp.config then
	vim.lsp.config = {}
end

vim.lsp.config["jsonls"] = {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
	root_markers = { ".git", "package.json" },
	single_file_support = true,
	init_options = {
		provideFormatter = true,
	},
	settings = {
		json = {
			validate = { enable = true },
			format = { enable = true },
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
			},
		},
	},
	capabilities = (function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		return capabilities
	end)(),
}

-- Ativa o servidor com tratamento de erro
local success, err = pcall(function()
	vim.lsp.enable("jsonls")
end)

if not success then
	vim.notify("Falha ao habilitar o servidor JSON: " .. tostring(err), vim.log.levels.ERROR)
end
