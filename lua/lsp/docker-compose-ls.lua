if not vim.lsp.config then
	vim.lsp.config = {}
end

vim.lsp.config["docker_compose_language_service"] = {
	cmd = { "docker-compose-langserver", "--stdio" },
	filetypes = { "yaml.docker-compose" },
	root_markers = { "docker-compose.yml", "docker-compose.yaml", ".git" },
	single_file_support = true,
	capabilities = (function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		return capabilities
	end)(),
}

-- Configura os tipos de arquivo especiais para docker-compose
local filetype_added = pcall(function()
	vim.filetype.add({
		filename = {
			["docker-compose.yml"] = "yaml.docker-compose",
			["docker-compose.yaml"] = "yaml.docker-compose",
			["compose.yml"] = "yaml.docker-compose",
			["compose.yaml"] = "yaml.docker-compose",
		},
	})
end)

if not filetype_added then
	-- Fallback para configuração anterior ao Neovim 0.11 se necessário
	vim.notify(
		"Aviso: A função vim.filetype.add não está disponível, filetype docker-compose pode não funcionar corretamente",
		vim.log.levels.WARN
	)
end

-- Ativa o servidor com tratamento de erro
local success, err = pcall(function()
	vim.lsp.enable("docker_compose_language_service")
end)

if not success then
	vim.notify("Falha ao habilitar o servidor Docker Compose: " .. tostring(err), vim.log.levels.ERROR)
end
