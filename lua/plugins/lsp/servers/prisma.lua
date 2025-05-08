return {
	settings = {
		prisma = {
			prismaFmtBinPath = "", -- Caminho para o binário prisma-fmt (deixe vazio para usar o padrão)
		},
	},
	-- Detecção moderna da raiz do projeto
	root_dir = function(fname)
		local startpath = vim.fn.fnamemodify(fname, ":p:h")

		-- Buscar arquivos específicos do Prisma
		local prisma_files = {
			"schema.prisma",
			"prisma/schema.prisma",
		}

		local root_file = vim.fs.find(prisma_files, { path = startpath, upward = true })[1]

		if root_file then
			return vim.fs.dirname(root_file)
		end

		-- Fallback para arquivos de projeto comuns
		root_file = vim.fs.find({ "package.json", ".git" }, { path = startpath, upward = true })[1]

		if root_file then
			return vim.fs.dirname(root_file)
		end

		return startpath
	end,
	-- Tipos de arquivo suportados
	filetypes = { "prisma" },
	-- Suporte a arquivos individuais
	single_file_support = true,
	-- Comandos personalizados
	commands = {
		PrismaFormat = {
			function()
				vim.lsp.buf.format({ async = true })
			end,
			description = "Formatar schema Prisma",
		},
	},
}
