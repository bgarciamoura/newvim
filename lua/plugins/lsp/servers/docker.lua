return {
	-- Configuração padrão para dockerls
	settings = {
		docker = {
			languageserver = {
				formatter = {
					ignoreMultilineInstructions = false,
				},
			},
		},
	},
	root_dir = function(fname)
		local startpath = vim.fn.fnamemodify(fname, ":p:h")

		-- Buscar arquivos do Docker
		local docker_files = {
			"Dockerfile",
			"docker-compose.yml",
			"docker-compose.yaml",
			"compose.yml",
			"compose.yaml",
		}

		local root_file = vim.fs.find(docker_files, { path = startpath, upward = true })[1]

		if root_file then
			return vim.fs.dirname(root_file)
		end

		-- Fallback para .git
		root_file = vim.fs.find({ ".git" }, { path = startpath, upward = true })[1]

		if root_file then
			return vim.fs.dirname(root_file)
		end

		return startpath
	end,
	filetypes = {
		"dockerfile",
	},
	single_file_support = true,
	cmd = { "docker-langserver", "--stdio" },
}
