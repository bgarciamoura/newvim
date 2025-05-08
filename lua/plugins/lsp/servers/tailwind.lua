return {
	settings = {
		tailwindCSS = {
			validate = true,
			experimental = {
				classRegex = {
					-- Suporte para vários padrões de regex para classes Tailwind
					{ 'class[:]\\s*"([^"]*)"', 1 },
					{ 'className[:]\\s*"([^"]*)"', 1 },
					{ 'class=\\s*"([^"]*)"', 1 },
					{ "class=\\s*'([^']*)'", 1 },
					{ 'class:\\s*"([^"]*)"', 1 },
					{ "class:\\s*'([^']*)'", 1 },
					{ "tw\\(([^)]*)\\)", 1 }, -- Para funções tw() do twin.macro
					{ "tw`([^`]*)`", 1 }, -- Para template strings tw`` do twin.macro
					{ "cx\\(([^)]*)\\)", 1 }, -- Para bibliotecas como classnames/clsx
					{ "clsx\\(([^)]*)\\)", 1 },
					{ "cva\\(([^)]*)\\)", 1 }, -- Para a biblioteca class-variance-authority
				},
			},
			emmetCompletions = true,
			includeLanguages = {
				heex = "html",
				eelixir = "html",
				elixir = "html",
				php = "html",
				blade = "html",
				astro = "html",
				htmlangular = "html",
				typescriptreact = "typescript",
				javascriptreact = "javascript",
				svelte = "html",
				vue = "html",
			},
			colorDecorators = true,
			hovers = true,
			suggestions = true,
			codeActions = true,
			lint = {
				cssConflict = "warning",
				invalidApply = "error",
				invalidScreen = "error",
				invalidVariant = "error",
				invalidConfigPath = "error",
				invalidTailwindDirective = "error",
			},
		},
	},
	root_dir = function(fname)
		-- Verifica múltiplos padrões para encontrar a raiz do projeto
		local startpath = vim.fn.fnamemodify(fname, ":p:h")

		-- Buscar arquivos de configuração Tailwind
		local tailwind_configs = {
			"tailwind.config.js",
			"tailwind.config.ts",
			"tailwind.config.cjs",
			"tailwind.config.mjs",
			"postcss.config.js",
			"postcss.config.ts",
			"postcss.config.cjs",
			"postcss.config.mjs",
		}

		local root_file = vim.fs.find(tailwind_configs, { path = startpath, upward = true })[1]

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
	filetypes = {
		-- Tipos de arquivo HTML/CSS padrão
		"html",
		"css",
		"scss",
		"sass",
		"less",

		-- JavaScript/TypeScript
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",

		-- Frameworks e outras linguagens
		"vue",
		"svelte",
		"astro",
		"php",
		"blade",
		"markdown",
		"mdx",
		"htmlangular",

		-- Outros frameworks que podem usar Tailwind
		"elixir",
		"eelixir",
		"heex",
	},
	init_options = {
		userLanguages = {
			heex = "html",
			elixir = "html",
			eelixir = "html",
			php = "html",
			blade = "blade",
			astro = "html",
			vue = "html",
			svelte = "html",
			mdx = "markdown",
		},
	},
}
