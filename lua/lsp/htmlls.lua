if not vim.lsp.config then
	vim.lsp.config = {}
end

vim.lsp.config["html"] = {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
	root_markers = { ".git", "package.json" },
	single_file_support = true,
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = {
			css = true,
			javascript = true,
		},
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
	vim.lsp.enable("html")
end)

if not success then
	vim.notify("Falha ao habilitar o servidor HTML: " .. tostring(err), vim.log.levels.ERROR)
end
