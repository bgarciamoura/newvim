if not vim.lsp.config then
	vim.lsp.config = {}
end

vim.lsp.config["emmet_lsp"] = {
	cmd = { "emmet-ls", "--stdio" },
	filetypes = {
		"astro",
		"css",
		"eruby",
		"html",
		"htmldjango",
		"javascriptreact",
		"less",
		"pug",
		"sass",
		"scss",
		"svelte",
		"typescriptreact",
		"vue",
		"htmlangular",
	},
	root_markers = { ".git", "package.json" },
	single_file_support = true,
	init_options = {
		-- Opções específicas de inicialização, se houver
	},
	capabilities = (function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		return capabilities
	end)(),
}

-- Ativa o servidor com tratamento de erro
local success, err = pcall(function()
	vim.lsp.enable("emmet_lsp")
end)

if not success then
	vim.notify("Falha ao habilitar o servidor Emmet-LS: " .. tostring(err), vim.log.levels.ERROR)
end
