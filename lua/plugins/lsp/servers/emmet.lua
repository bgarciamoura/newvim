return {
	filetypes = {
		"astro",
		"css",
		"eruby",
		"html",
		"htmldjango",
		"javascriptreact",
		"less",
		"pug",
		"sass",
		"scss",
		"svelte",
		"typescriptreact",
		"vue",
		"htmlangular",
		"php",
		"blade",
		"markdown",
		"mdx",
	},
	-- Função moderna para determinar a raiz do projeto
	root_dir = function(fname)
		local startpath = vim.fn.fnamemodify(fname, ":p:h")

		-- Buscar arquivos comuns de projetos web
		local web_configs = {
			"package.json",
			"tsconfig.json",
			"jsconfig.json",
			"vite.config.js",
			"vite.config.ts",
			"nuxt.config.js",
			"nuxt.config.ts",
			"astro.config.mjs",
			"astro.config.js",
			"svelte.config.js",
			"next.config.js",
		}

		local root_file = vim.fs.find(web_configs, { path = startpath, upward = true })[1]

		if root_file then
			return vim.fs.dirname(root_file)
		end

		-- Fallback para HTML ou outros arquivos web
		root_file = vim.fs.find({ "index.html", ".git" }, { path = startpath, upward = true })[1]

		if root_file then
			return vim.fs.dirname(root_file)
		end

		-- Se nada for encontrado, use o diretório atual
		return startpath
	end,
	init_options = {
		-- Configurações específicas para diferentes linguagens
		html = {
			options = {
				-- Configurações de sintaxe para HTML
				["bem.enabled"] = true, -- Habilitar sugestões BEM
				["bem.element"] = "__", -- Separador de elemento BEM
				["bem.modifier"] = "_", -- Separador de modificador BEM
				["output.selfClosingStyle"] = "xhtml", -- Estilo de fechamento (html, xml, xhtml)
				["output.formatOnSave"] = true, -- Formatar ao salvar
				["comment.enabled"] = true, -- Habilitar comentários
				["comment.triggerWhenNoAttrs"] = true, -- Criação automática de comentários
			},
		},
		jsx = {
			options = {
				["jsx.enabled"] = true, -- Habilitar suporte JSX
				["markup.attributes"] = { -- Mapeamento de atributos HTML para JSX
					["class"] = "className",
					["for"] = "htmlFor",
				},
				["jsx.classComponent"] = false, -- Usar componentes de classe (depreciado)
			},
		},
	},
	-- Configurações globais do servidor
	settings = {
		emmet = {
			showExpandedAbbreviation = "always", -- Mostrar abreviação expandida (inLine, always, never)
			showAbbreviationSuggestions = true, -- Mostrar sugestões de abreviação
			showSuggestionsAsSnippets = true, -- Mostrar sugestões como snippets
			includeLanguages = { -- Mapeamento para tipos de arquivo não padrão
				["vue-html"] = "html",
				["javascript"] = "javascriptreact",
				["typescript"] = "typescriptreact",
				["erb"] = "html",
				["blade"] = "html",
				["heex"] = "html",
				["mdx"] = "markdown",
			},
			variables = { -- Variáveis personalizadas para snippets
				["lang"] = "pt-BR",
				["charset"] = "UTF-8",
				["indentation"] = "  ",
				["newline"] = "\n",
			},
			preferences = { -- Preferências para gerar HTML
				["output.inlineBreak"] = 0,
				["output.reverseAttributes"] = false,
				["output.selfClosingStyle"] = "xhtml",
				["css.floatDisplayValue"] = "flex", -- Valor moderno para floats como flex
				["css.intUnit"] = "px", -- Unidade para valores inteiros
				["css.unitAliases"] = { -- Aliases de unidades CSS
					["e"] = "em",
					["r"] = "rem",
					["p"] = "%",
					["x"] = "px",
					["v"] = "vh",
					["vw"] = "vw",
				},
				["bem.elementSeparator"] = "__",
				["bem.modifierSeparator"] = "_",
				["comment.enabled"] = true, -- Habilitar comentários
				["comment.trigger"] = false, -- Não adicionar comentários automaticamente
				["bem.enabled"] = true, -- Suporte para BEM
				["jsx.enabled"] = true, -- Suporte para JSX
			},
			syntaxProfiles = { -- Perfis de sintaxe para linguagens
				html = {
					["xhtml"] = true,
				},
				jsx = {
					["tag_case"] = "lower",
					["attr_quotes"] = "double",
					["self_closing"] = true,
				},
			},
		},
	},
}
