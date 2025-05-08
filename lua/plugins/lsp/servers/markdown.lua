return {
	settings = {
		marksman = {
			-- Configurações específicas para Marksman
			includePaths = {}, -- Caminhos adicionais para incluir na análise
			excludePaths = {}, -- Caminhos para excluir da análise
			-- Customizações de diagnóstico
			diagnostics = {
				-- Problemas a reportar
				links = true, -- Verificar links no markdown
				references = true, -- Verificar referências
				heading = {
					-- Verificação de cabeçalhos
					duplicated = "warning", -- Nível para cabeçalhos duplicados
					incompatible = "warning", -- Cabeçalhos com estrutura incompatível
					missingSpaces = "warning", -- Espaços ausentes em cabeçalhos
				},
				trailing = "hint", -- Espaços em branco no final das linhas
				fenced = {
					-- Blocos de código
					missingEndFence = "warning", -- Cerca de código sem fechamento
				},
			},
		},
	},
	-- Detecção moderna da raiz do projeto
	root_dir = function(fname)
		local startpath = vim.fn.fnamemodify(fname, ":p:h")

		-- Buscar arquivos específicos de projetos Markdown
		local markdown_project_files = {
			-- Arquivos de documentação comuns
			"README.md",
			"docs",
			"documentation",
			"mkdocs.yml",
			"book.toml", -- Para mdBook
			-- Arquivos de blog/site estático
			"_config.yml", -- Jekyll
			"config.toml", -- Hugo
			-- Arquivos de projeto comuns que indicam um repositório com docs
			"package.json",
			"Cargo.toml", -- Para projetos Rust
			"Gemfile", -- Para projetos Ruby
		}

		local root_file = vim.fs.find(markdown_project_files, { path = startpath, upward = true })[1]

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
	filetypes = { "markdown", "markdown.mdx" },
	-- Suporte a arquivos individuais
	single_file_support = true,
	-- Ações a realizar ao conectar o servidor
	on_attach = function(client, bufnr)
		-- Adicionar comandos para melhorar a experiência com Markdown

		-- Comando para visualizar o arquivo Markdown atual
		vim.api.nvim_buf_create_user_command(bufnr, "MarkdownPreview", function()
			-- Verificar se o plugin 'markdown-preview.nvim' está disponível
			if vim.fn.exists(":MarkdownPreview") == 2 then
				vim.cmd("MarkdownPreview")
			else
				-- Fallback: abrir com o navegador padrão
				local filename = vim.fn.expand("%:p")
				local sys = vim.loop.os_uname().sysname

				if sys == "Windows_NT" then
					vim.fn.jobstart({ "cmd.exe", "/c", "start", filename })
				elseif sys == "Darwin" then
					vim.fn.jobstart({ "open", filename })
				else
					vim.fn.jobstart({ "xdg-open", filename })
				end
			end
		end, { desc = "Visualizar Markdown" })

		-- Comando para converter Markdown para HTML
		vim.api.nvim_buf_create_user_command(bufnr, "MarkdownToHTML", function()
			local input = vim.fn.expand("%:p")
			local output = vim.fn.expand("%:p:r") .. ".html"

			-- Verificar se pandoc está instalado
			if vim.fn.executable("pandoc") == 1 then
				vim.fn.jobstart({ "pandoc", input, "-o", output, "--standalone" }, {
					on_exit = function(_, code)
						if code == 0 then
							vim.notify("Markdown convertido para HTML: " .. output, vim.log.levels.INFO)
						else
							vim.notify("Falha ao converter para HTML", vim.log.levels.ERROR)
						end
					end,
				})
			else
				vim.notify("Pandoc não encontrado. Instale-o para converter Markdown para HTML.", vim.log.levels.ERROR)
			end
		end, { desc = "Converter Markdown para HTML" })

		-- Keymaps específicos para Markdown
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"<leader>mp",
			"<cmd>MarkdownPreview<CR>",
			{ noremap = true, desc = "Visualizar Markdown" }
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"<leader>mh",
			"<cmd>MarkdownToHTML<CR>",
			{ noremap = true, desc = "Converter para HTML" }
		)
	end,
}
