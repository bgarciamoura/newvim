return {
	-- Biome tem configuração mínima pois a maioria das configurações vem do arquivo biome.json
	cmd = { "biome", "lsp-proxy" },
	root_dir = function(fname)
		local startpath = vim.fn.fnamemodify(fname, ":p:h")

		-- Buscar arquivos de configuração do Biome ou outros marcadores de projeto
		local root_file = vim.fs.find({ "biome.json", "biome.jsonc", "package.json", ".git" }, {
			path = startpath,
			upward = true,
		})[1]

		if root_file then
			return vim.fs.dirname(root_file)
		end
		return startpath
	end,
	single_file_support = true,
	settings = {
		-- Configurações específicas do Biome, se necessário
		-- Normalmente é preferível usar o arquivo biome.json no projeto
	},
	init_options = {
		-- Opções de inicialização, se necessário
	},
}
