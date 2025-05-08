return {
	settings = {
		packageManager = "npm", -- Pode ser "npm", "yarn", "pnpm"
		codeAction = {
			disableRuleComment = {
				enable = true,
				location = "separateLine",
			},
			showDocumentation = {
				enable = true,
			},
		},
		codeActionOnSave = {
			enable = false, -- Controlado pelos autocmds
			mode = "all",
		},
		experimental = {
			useFlatConfig = false, -- Suporte para configuração plana (eslint.config.js)
		},
		format = true, -- Usar ESLint também como formatador
		quiet = false, -- Não mostrar avisos no diagnóstico
		onIgnoredFiles = "off", -- Não executar em arquivos ignorados
		rulesCustomizations = {}, -- Customizações de regras
		run = "onType", -- Executar em cada alteração
		useESLintClass = false, -- Usar nova API de classe do ESLint
		validate = "on", -- Quando validar: on, off, probe
		workingDirectory = {
			mode = "auto", -- Modo de detecção do diretório de trabalho
		},
	},
	-- Função para encontrar o diretório raiz (versão atualizada)
	root_dir = function(fname)
		local startpath = vim.fn.fnamemodify(fname, ":p:h")

		-- Buscar arquivos de configuração ESLint
		local eslint_configs = {
			".eslintrc",
			".eslintrc.js",
			".eslintrc.cjs",
			".eslintrc.yaml",
			".eslintrc.yml",
			".eslintrc.json",
			"eslint.config.js",
		}

		local root_file = vim.fs.find(eslint_configs, { path = startpath, upward = true })[1]

		if root_file then
			return vim.fs.dirname(root_file)
		end

		-- Fallback para package.json ou .git
		root_file = vim.fs.find({ "package.json", ".git" }, { path = startpath, upward = true })[1]

		if root_file then
			return vim.fs.dirname(root_file)
		end

		return startpath
	end,
	-- Configuração para notificar progresso
	handlers = {
		["eslint/openDoc"] = function(_, result)
			if not result then
				return
			end
			local sysname = vim.loop.os_uname().sysname
			if sysname:match("Windows") then
				os.execute(string.format("start %s", result.url))
			elseif sysname:match("Linux") then
				os.execute(string.format("xdg-open %s", result.url))
			else
				os.execute(string.format("open %s", result.url))
			end
			return {}
		end,
		["eslint/confirmESLintExecution"] = function(_, result)
			if not result then
				return
			end
			return { allow = true }
		end,
		["eslint/probeFailed"] = function()
			vim.notify(
				"[ESLint] Cannot find ESLint configuration. ESLint server may not work correctly.",
				vim.log.levels.WARN
			)
			return {}
		end,
		["eslint/noLibrary"] = function()
			vim.notify("[ESLint] Cannot find ESLint library. ESLint server may not work correctly.", vim.log.levels.WARN)
			return {}
		end,
	},
	-- Comandos personalizados
	commands = {
		ESLintFixAll = {
			function()
				vim.lsp.buf.execute_command({
					command = "eslint.applyAllFixes",
					arguments = {
						{
							uri = vim.uri_from_bufnr(0),
							version = vim.lsp.util.buf_versions[0],
						},
					},
				})
			end,
			description = "Fix all ESLint problems",
		},
	},
	on_attach = function(client, bufnr)
		-- Configure ESLintFixOnSave autocmd
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				-- Verificar se devemos usar Biome em vez de ESLint
				local utils = require("plugins.lsp.utils")
				local root = utils.get_project_root()
				if not utils.has_biome_config(root) then
					-- Use ESLint somente se não tiver configuração do Biome
					vim.lsp.buf.execute_command({
						command = "eslint.applyAllFixes",
						arguments = {
							{
								uri = vim.uri_from_bufnr(bufnr),
								version = vim.lsp.util.buf_versions[bufnr],
							},
						},
					})
				end
			end,
			group = vim.api.nvim_create_augroup("ESLintFixOnSave_" .. bufnr, { clear = true }),
		})
	end,
}
