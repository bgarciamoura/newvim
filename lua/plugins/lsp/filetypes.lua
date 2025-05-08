local M = {}

-- Configura tipos de arquivo especiais
function M.setup()
	-- Configuração adicional para suporte a Docker Compose
	vim.filetype.add({
		filename = {
			["docker-compose.yml"] = "yaml.docker-compose",
			["docker-compose.yaml"] = "yaml.docker-compose",
			["compose.yml"] = "yaml.docker-compose",
			["compose.yaml"] = "yaml.docker-compose",
		},
	})

	-- Configuração para GitHub Actions
	vim.filetype.add({
		pattern = {
			[".*/%.github/workflows/.*%.ya?ml"] = "yaml.github",
		},
	})
end

-- Inicializa o módulo
M.setup()

return M
