return {
	settings = {
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
			suggest = {
				completeFunctionCalls = true,
				includeCompletionsForImportStatements = true,
				includeAutomaticOptionalChainCompletions = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
				showOnAllFunctions = true,
			},
			format = {
				indentSize = 2,
				convertTabsToSpaces = true,
				tabSize = 2,
				insertSpaceAfterCommaDelimiter = true,
				insertSpaceAfterConstructor = false,
				insertSpaceAfterSemicolonInForStatements = true,
				insertSpaceBeforeAndAfterBinaryOperators = true,
				insertSpaceAfterKeywordsInControlFlowStatements = true,
				insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
				insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
				insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
				insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
				insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
				insertSpaceBeforeFunctionParenthesis = false,
				placeOpenBraceOnNewLineForFunctions = false,
				placeOpenBraceOnNewLineForControlBlocks = false,
				semicolons = "insert",
			},
		},
		javascript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
			suggest = {
				completeFunctionCalls = true,
				includeCompletionsForImportStatements = true,
				includeAutomaticOptionalChainCompletions = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
				showOnAllFunctions = true,
			},
			format = {
				indentSize = 2,
				convertTabsToSpaces = true,
				tabSize = 2,
			},
		},
	},
	-- Define funções personalizadas ou comandos
	commands = {
		OrganizeImports = {
			function()
				local params = {
					command = "_typescript.organizeImports",
					arguments = { vim.api.nvim_buf_get_name(0) },
					title = "Organize Imports",
				}
				vim.lsp.buf.execute_command(params)
			end,
			description = "Organize Imports",
		},
		GoToProjectConfig = {
			function()
				local params = {
					command = "_typescript.goToProjectConfig",
					arguments = { vim.api.nvim_buf_get_name(0) },
					title = "Go to Project Config",
				}
				vim.lsp.buf.execute_command(params)
			end,
			description = "Go to TSConfig/JSConfig",
		},
	},
	root_dir = function(fname)
		local startpath = vim.fn.fnamemodify(fname, ":p:h")

		-- Buscar arquivos de configuração TypeScript/JavaScript
		local root_file = vim.fs.find({ "tsconfig.json", "jsconfig.json", "package.json", ".git" }, {
			path = startpath,
			upward = true,
		})[1]

		if root_file then
			return vim.fs.dirname(root_file)
		end
		return startpath
	end,
	init_options = {
		hostInfo = "neovim",
		preferences = {
			includeInlayParameterNameHints = "all",
			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayVariableTypeHints = true,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayEnumMemberValueHints = true,
			importModuleSpecifierPreference = "shortest",
			allowRenameOfImportPath = true,
		},
	},
}
