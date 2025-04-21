if not vim.lsp.config then
	vim.lsp.config = {}
end

vim.lsp.config["postgresls"] = {
	cmd = { "postgrestools", "lsp-proxy" },
	filetypes = {
		"sql",
		"pgsql",
	},
	root_markers = { "postgrestools.jsonc", ".git", "package.json" },
	single_file_support = true,
	settings = {
		-- Configurações específicas do PostgreSQL Language Server
		postgres = {
			-- Você pode adicionar configurações específicas aqui
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
	vim.lsp.enable("postgresls")
end)

if not success then
	vim.notify("Falha ao habilitar o servidor PostgreSQL: " .. tostring(err), vim.log.levels.ERROR)
end
