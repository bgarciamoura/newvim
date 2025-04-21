if not vim.lsp.config then
	vim.lsp.config = {}
end

vim.lsp.config["marksman"] = {
	cmd = { "marksman", "server" },
	filetypes = { "markdown", "markdown.mdx" },
	root_markers = { ".git", ".marksman.toml" },
	single_file_support = true,
	settings = {
		-- Configurações específicas do marksman, se houver
	},
	capabilities = (function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		return capabilities
	end)(),
}

-- Ativa o servidor com tratamento de erro
local success, err = pcall(function()
	vim.lsp.enable("marksman")
end)

if not success then
	vim.notify("Falha ao habilitar o servidor Marksman: " .. tostring(err), vim.log.levels.ERROR)
end
