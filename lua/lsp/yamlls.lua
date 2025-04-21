if not vim.lsp.config then
	vim.lsp.config = {}
end

vim.lsp.config["yamlls"] = {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yml" },
	root_markers = { ".git" },
	single_file_support = true,
	settings = {
		yaml = {
			format = {
				enable = true,
				singleQuote = false,
				bracketSpacing = true,
			},
			validate = true,
			hover = true,
			completion = true,
			schemaStore = {
				enable = true,
				url = "https://www.schemastore.org/api/json/catalog.json",
			},
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.{yml,yaml}",
				["https://json.schemastore.org/gitlab-ci.json"] = { ".gitlab-ci.yml", "ci/*.yml" },
				["https://json.schemastore.org/kustomization.json"] = "kustomization.{yml,yaml}",
				["https://json.schemastore.org/helmfile.json"] = "helmfile.{yml,yaml}",
				["https://json.schemastore.org/docker-compose.json"] = "docker-compose*.{yml,yaml}",
			},
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
	vim.lsp.enable("yamlls")
end)

if not success then
	vim.notify("Falha ao habilitar o servidor YAML: " .. tostring(err), vim.log.levels.ERROR)
end
