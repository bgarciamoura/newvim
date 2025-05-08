return {
	settings = {
		sqlLanguageServer = {
			-- Validação
			validation = true,
			-- Linting
			lint = {
				lintOnOpen = true,
				lintOnSave = true,
				lintOnChange = true,
			},
			-- Indexação
			index = {
				enabled = true,
				realTimeIndexing = true,
			},
			-- Formatação
			format = {
				-- Configurações de formatação
				uppercaseKeywords = true,
				linesBetweenQueries = 2,
			},
			-- Dialeto padrão (pode ser alterado por projeto)
			defaultDialect = "postgresql", -- Pode ser "postgresql", "mysql", "sqlite", etc.
			-- Configurações de autocompletamento
			completion = {
				-- Colocar o snippet do comentário antes da coluna
				columnCommentSnippet = {
					includeTableName = true, -- Incluir nome da tabela no comentário
					withQuotes = true, -- Usar aspas nos identificadores
				},
				-- Ordem de snippets e sugestões de autocompletamento
				triggerSuggestOnDot = true, -- Sugerir ao digitar um ponto
				triggerSuggestOnColon = true, -- Sugerir ao digitar dois pontos
				snippetSuggestions = "inline", -- Posição para mostrar snippets
			},
		},
	},
	-- Detecção moderna da raiz do projeto
	root_dir = function(fname)
		local startpath = vim.fn.fnamemodify(fname, ":p:h")

		-- Buscar arquivos específicos de projetos com SQL
		local sql_project_files = {
			-- Arquivos de definição de banco de dados
			"schema.sql",
			"migrations",
			"database.json",
			"knexfile.js",
			"sequelize.config.js",
			"typeorm.config.js",
			"prisma/schema.prisma", -- Prisma geralmente tem esquemas SQL
			-- Arquivos de projeto comuns
			"package.json",
			"composer.json", -- Para projetos PHP
			"pom.xml", -- Para projetos Java
			"build.gradle", -- Para projetos Java/Kotlin
		}

		local root_file = vim.fs.find(sql_project_files, { path = startpath, upward = true })[1]

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
	-- Tipos de arquivo suportados
	filetypes = { "sql" },
	-- Suporte a arquivos individuais
	single_file_support = true,
	-- Ações a realizar ao conectar o servidor
	on_attach = function(client, bufnr)
		-- Configurar comandos específicos para SQL
		vim.api.nvim_buf_create_user_command(bufnr, "SQLFormat", function()
			vim.lsp.buf.format({ async = true })
		end, { desc = "Formatar SQL" })

		-- Adicionar keymaps específicos para SQL
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"<leader>sf",
			"<cmd>SQLFormat<CR>",
			{ noremap = true, desc = "Formatar SQL" }
		)
	end,
}
