if not vim.lsp.config then
	vim.lsp.config = {}
end

vim.lsp.config["dockerls"] = {
	cmd = { "docker-langserver", "--stdio" },
	filetypes = { "dockerfile" },
	root_markers = { "Dockerfile", ".git", "docker-compose.yml" },
	single_file_support = true,
	settings = {
		-- Configurações específicas do Docker Language Server
	},
	capabilities = (function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		return capabilities
	end)(),
}

-- Ativa o servidor com tratamento de erro
local success, err = pcall(function()
	vim.lsp.enable("dockerls")
end)

if not success then
	vim.notify("Falha ao habilitar o servidor Docker: " .. tostring(err), vim.log.levels.ERROR)
end
