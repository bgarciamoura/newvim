return {
	settings = {
		bashIde = {
			-- Padrão glob para arquivos Bash
			globPattern = "*@(.sh|.inc|.bash|.command|.zsh)",
			-- Incluir todas as variáveis na análise
			includeAllWorkspaceSymbols = true,
			-- Ativar formatação (shellcheck)
			enableSourceErrorDiagnostics = true,
			-- Configuração do shellcheck
			shellcheckPath = "shellcheck",
			shellcheckArguments = "",
			-- Explodir strings simples em parâmetros
			explainshellEndpoint = "", -- Use "https://explainshell.com/api/explain" se desejar ativar
			-- Formatação
			formatter = {
				-- Usar formatador externo (shfmt)
				external = {
					command = "shfmt",
					args = { "-i", "2", "-bn", "-ci", "-sr" },
				},
			},
		},
	},
	-- Detecção moderna da raiz do projeto
	root_dir = function(fname)
		local startpath = vim.fn.fnamemodify(fname, ":p:h")

		-- Buscar arquivos específicos de shell
		local shell_files = {
			".bashrc",
			".bash_profile",
			".zshrc",
			".profile",
			"package.json", -- Para projetos com scripts shell
			"Makefile", -- Projetos com Makefile geralmente têm scripts
		}

		local root_file = vim.fs.find(shell_files, { path = startpath, upward = true })[1]

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
	filetypes = { "sh", "bash", "zsh" },
	-- Suporte a arquivos individuais
	single_file_support = true,
	-- Ações a realizar ao conectar o servidor
	on_attach = function(client, bufnr)
		-- Adicionar comandos específicos para scripts shell
		vim.api.nvim_buf_create_user_command(bufnr, "ShellCheck", function()
			vim.cmd("!shellcheck -x " .. vim.fn.expand("%"))
		end, { desc = "Executar shellcheck no arquivo atual" })

		-- Formatar com shfmt (se disponível)
		vim.api.nvim_buf_create_user_command(bufnr, "ShellFormat", function()
			vim.lsp.buf.format({ async = true })
		end, { desc = "Formatar script shell" })

		-- Adicionar keymaps específicos para scripts shell
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"<leader>sc",
			"<cmd>ShellCheck<CR>",
			{ noremap = true, desc = "Verificar script com shellcheck" }
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"<leader>sf",
			"<cmd>ShellFormat<CR>",
			{ noremap = true, desc = "Formatar script shell" }
		)
	end,
}
