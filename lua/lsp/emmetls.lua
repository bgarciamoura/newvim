if not vim.lsp.config then
	vim.lsp.config = {}
end

vim.lsp.config["emmetls"] = {
	cmd = { "emmet-language-server", "--stdio" },
	filetypes = {
		"css",
		"eruby",
		"html",
		"htmldjango",
		"javascriptreact",
		"less",
		"pug",
		"sass",
		"scss",
		"typescriptreact",
		"htmlangular",
	},
	root_markers = { ".git", "package.json" },
	single_file_support = true,
	init_options = {
		-- Você pode adicionar configurações específicas aqui
		provideFormatter = true,
	},
	capabilities = (function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		return capabilities
	end)(),
}

-- Ativa o servidor com tratamento de erro
local success, err = pcall(function()
	vim.lsp.enable("emmetls")
end)

if not success then
	vim.notify("Falha ao habilitar o servidor Emmet Language Server: " .. tostring(err), vim.log.levels.ERROR)
end
