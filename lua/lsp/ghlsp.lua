if not vim.lsp.config then
	vim.lsp.config = {}
end

vim.lsp.config["gh_actions_ls"] = {
	cmd = { "gh-actions-language-server", "--stdio" },
	filetypes = { "yaml.github" },
	root_markers = { ".github", ".git" },
	single_file_support = true,
	capabilities = {
		workspace = {
			didChangeWorkspaceFolders = {
				dynamicRegistration = true,
			},
		},
		textDocument = {
			completion = {
				completionItem = {
					snippetSupport = true,
				},
			},
		},
	},
}

-- Configurar os padrões de arquivo YAML para GitHub Actions
local filetype_added = pcall(function()
	vim.filetype.add({
		pattern = {
			[".*/%.github/workflows/.*%.ya?ml"] = "yaml.github",
		},
	})
end)

if not filetype_added then
	vim.notify(
		"Aviso: A função vim.filetype.add não está disponível, filetype github yaml pode não funcionar corretamente",
		vim.log.levels.WARN
	)
end

-- Ativa o servidor com tratamento de erro
local success, err = pcall(function()
	vim.lsp.enable("gh_actions_ls")
end)

if not success then
	vim.notify("Falha ao habilitar o servidor GitHub Actions: " .. tostring(err), vim.log.levels.ERROR)
end
