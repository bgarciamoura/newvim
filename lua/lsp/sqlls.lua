if not vim.lsp.config then
	vim.lsp.config = {}
end

vim.lsp.config["sqlls"] = {
	cmd = { "sql-language-server", "up", "--method", "stdio" },
	filetypes = { "sql", "mysql" },
	root_markers = { ".sqllsrc.json", ".git" },
	single_file_support = true,
	settings = {
		-- Configurações específicas do SQL Language Server
		sqlLanguageServer = {
			-- Exemplos de configurações que você pode ajustar
			-- connections: [],
			-- lint: { },
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
	vim.lsp.enable("sqlls")
end)

if not success then
	vim.notify("Falha ao habilitar o servidor SQL: " .. tostring(err), vim.log.levels.ERROR)
end
