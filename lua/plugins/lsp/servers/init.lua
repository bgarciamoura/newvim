local M = {}

function M.setup()
	-- Importa a configuração de capacidades
	local capabilities = require("plugins.lsp.capabilities").get_capabilities()

	-- Importa as configurações de cada servidor
	local servers = {
		lua_ls = require("plugins.lsp.servers.lua_ls"),
		html = require("plugins.lsp.servers.html"),
		cssls = require("plugins.lsp.servers.css"),
		jsonls = require("plugins.lsp.servers.json"),
		yamlls = require("plugins.lsp.servers.yaml"),
		biome = require("plugins.lsp.servers.biome"),
		tsserver = require("plugins.lsp.servers.typescript"),
		eslint = require("plugins.lsp.servers.eslint"),
		tailwindcss = require("plugins.lsp.servers.tailwind"),
		dockerls = require("plugins.lsp.servers.docker"),
		emmet_ls = require("plugins.lsp.servers.emmet"),
		prismals = require("plugins.lsp.servers.prisma"),
		terraformls = require("plugins.lsp.servers.terraform"),
		sqlls = require("plugins.lsp.servers.sql"),
		bashls = require("plugins.lsp.servers.bash"),
		marksman = require("plugins.lsp.servers.markdown"),
	}

	-- Configurar cada servidor LSP
	local lspconfig = require("lspconfig")
	for server_name, server_config in pairs(servers) do
		-- Aplicar capacidades aprimoradas
		server_config.capabilities = capabilities

		-- Configurar o servidor
		lspconfig[server_name].setup(server_config)
		vim.notify(
			string.format("Servidor LSP %s configurado com sucesso!", server_name),
			vim.log.levels.INFO,
			{ title = "LSP Configuração" }
		)
	end
end

-- Inicializa o módulo
M.setup()

return M
