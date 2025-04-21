if not vim.lsp.config then
	vim.lsp.config = {}
end

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
	root_markers = { "biome.json", "biome.jsonc", ".git" },
	single_file_support = true,
	-- Garantir que as capacidades sejam definidas corretamente
	capabilities = (function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		return capabilities
	end)(),
}

-- Ativa o servidor com tratamento de erro
local success, err = pcall(function()
	vim.lsp.enable("biome")
end)

if not success then
	vim.notify("Falha ao habilitar o servidor Biome: " .. tostring(err), vim.log.levels.ERROR)
end
