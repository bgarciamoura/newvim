if not vim.lsp.config then
	vim.lsp.config = {}
end

vim.lsp.config["nxls"] = {
	cmd = { "nxls", "--stdio" },
	filetypes = { "json", "jsonc" },
	root_markers = { "nx.json", ".git" },
	single_file_support = false, -- NX geralmente requer contexto do projeto
	settings = {
		-- Configurações específicas do nxls, se disponíveis
	},
	capabilities = (function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		return capabilities
	end)(),
}

-- Ativa o servidor com tratamento de erro
local success, err = pcall(function()
	vim.lsp.enable("nxls")
end)

if not success then
	vim.notify("Falha ao habilitar o servidor NX: " .. tostring(err), vim.log.levels.ERROR)
end
