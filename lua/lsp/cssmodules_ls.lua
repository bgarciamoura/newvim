if not vim.lsp.config then
	vim.lsp.config = {}
end

vim.lsp.config["cssmodulesls"] = {
	cmd = { "cssmodules-language-server" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = { "package.json", ".git" },
	single_file_support = false, -- Geralmente precisa do contexto do projeto
	settings = {
		-- Configurações específicas para CSS Modules se disponíveis
	},
	capabilities = (function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		return capabilities
	end)(),
}

-- Ativa o servidor com tratamento de erro
local success, err = pcall(function()
	vim.lsp.enable("cssmodulesls")
end)

if not success then
	vim.notify("Falha ao habilitar o servidor CSS Modules: " .. tostring(err), vim.log.levels.ERROR)
end
